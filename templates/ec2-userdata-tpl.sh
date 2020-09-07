#!/bin/bash

# configure /etc/security.limits.conf
mv /etc/security/limits.conf /etc/security/limits.conf.bak
cat > /etc/security/limits.conf <<EOF
ec2-user         hard    nofile          65000
ec2-user         soft    nofile          65000
ec2-user         hard    nproc           65000
ec2-user         soft    nproc           65000
EOF

# Install build tools
yum update
yum -y install ant git php gnuplot gcc make readline-devel zlib-devel postgresql-jdbc bzr automake libtool patch libevent-devel openssl-devel curses-devel
# Install diagnosis tools
yum -y install htop nc

EC2_USER_HOME=/home/ec2-user
SCRIPTS_PATH=$EC2_USER_HOME/scripts
mkdir -p $SCRIPTS_PATH

# patch pgbench
cat > $SCRIPTS_PATH/install-benchmark-tools.sh <<EOF
# pgbench
wget https://ftp.postgresql.org/pub/source/v11.8/postgresql-11.8.tar.gz
wget https://gist.githubusercontent.com/davidsung/25194a91f6561058187ccf1b2cf85286/raw/ad4259dadf04cb4f5b2ead0f887ec0a93c96be12/pgbench11_8-ppoll.patch
tar -xzf postgresql-11.8.tar.gz
cd postgresql-11.8
patch -p1 -b < ../pgbench11_8-ppoll.patch
./configure
make -j 4 all
sudo make install
cd ..

# sysbench
git clone -b 0.5 https://github.com/akopytov/sysbench.git
cd sysbench
./autogen.sh
CFLAGS="-L/usr/local/pgsql/lib/ -I /usr/local/pgsql/include/" | ./configure \
  --with-pgsql --without-mysql --with-pgsql-includes=/usr/local/pgsql/include/ \
  --with-pgsql-libs=/usr/local/pgsql/lib/
make
sudo make install
cd sysbench/tests
sudo make install
EOF
chmod +x $SCRIPTS_PATH/install-benchmark-tools.sh
chown ec2-user: $SCRIPTS_PATH/install-benchmark-tools.sh

echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/pgsql/lib" >> /home/ec2-user/.bash_profile
echo "export PATH=$PATH:/usr/local/pgsql/bin/" >> /home/ec2-user/.bash_profile
echo 'AURORA_ENDPOINT="${aurora_writer_endpoint}"' >> /home/ec2-user/.bash_profile
echo 'AURORA_ENDPOINT_IP="$(dig +short ${aurora_writer_endpoint})"' >> /home/ec2-user/.bash_profile
echo 'RDS_MAZ_ENDPOINT="${rds_maz_endpoint}"' >> /home/ec2-user/.bash_profile
echo 'RDS_MAZ_ENDPOINT_IP="$(dig +short ${rds_maz_endpoint})"' >> /home/ec2-user/.bash_profile
echo 'RDS_SAZ_ENDPOINT="${rds_saz_endpoint}"' >> /home/ec2-user/.bash_profile
echo 'RDS_SAZ_ENDPOINT_IP="$(dig +short ${rds_saz_endpoint})"' >> /home/ec2-user/.bash_profile
echo 'BENCHMARK_TIME=300' >> /home/ec2-user/.bash_profile
echo 'BENCHMARK_JOBS=2048' >> /home/ec2-user/.bash_profile
echo 'BENCHMARK_CLIENTS=2048' >> /home/ec2-user/.bash_profile

cat > $SCRIPTS_PATH/aurora_benchmark_init.sh <<EOF
#!/bin/bash
pgbench -i --fillfactor=90 --scale=10000 --host='$AURORA_ENDPOINT_IP' --username='${database_username}' ${database_name}
EOF

cat > $SCRIPTS_PATH/rds_maz_benchmark_init.sh <<EOF
#!/bin/bash
pgbench -i --fillfactor=90 --scale=10000 --host='$RDS_MAZ_ENDPOINT_IP' --username='${database_username}' ${database_name}
EOF

cat > $SCRIPTS_PATH/rds_saz_benchmark_init.sh <<EOF
#!/bin/bash
pgbench -i --fillfactor=90 --scale=10000 --host='$RDS_SAZ_ENDPOINT_IP' --username='${database_username}' ${database_name}
EOF

cat > $SCRIPTS_PATH/aurora_benchmark_readwrite.sh <<EOF
#!/bin/bash
pgbench --host='$AURORA_ENDPOINT_IP' --username='${database_username}' --protocol=prepared -P 60 --time=$BENCHMARK_TIME --client=$BENCHMARK_CLIENTS --jobs=$BENCHMARK_JOBS ${database_name}
EOF

cat > $SCRIPTS_PATH/rds_maz_benchmark_readwrite.sh <<EOF
#!/bin/bash
pgbench --host='$RDS_MAZ_ENDPOINT_IP' --username='${database_username}' --protocol=prepared -P 60 --time=$BENCHMARK_TIME --client=$BENCHMARK_CLIENTS --jobs=$BENCHMARK_JOBS ${database_name}
EOF

cat > $SCRIPTS_PATH/rds_saz_benchmark_readwrite.sh <<EOF
#!/bin/bash
pgbench --host='$RDS_SAZ_ENDPOINT_IP' --username='${database_username}' --protocol=prepared -P 60 --time=$BENCHMARK_TIME --client=$BENCHMARK_CLIENTS --jobs=$BENCHMARK_JOBS ${database_name}
EOF

cat > $SCRIPTS_PATH/aurora_benchmark_prepare.sh <<EOF
#!/bin/bash
sysbench --test=/usr/local/share/sysbench/oltp.lua \
  --pgsql-host='$AURORA_ENDPOINT_IP' --pgsql-db='${database_name}' \
  --pgsql-user='${database_username}' --pgsql-password='${database_password}' --pgsql-port=5432 \
  --oltp-tables-count=250 --oltp-table-size=450000 prepare
EOF

cat > $SCRIPTS_PATH/rds_maz_benchmark_prepare.sh <<EOF
#!/bin/bash
sysbench --test=/usr/local/share/sysbench/oltp.lua \
  --pgsql-host='$RDS_MAZ_ENDPOINT_IP' --pgsql-db='${database_name}' \
  --pgsql-user='${database_username}' --pgsql-password='${database_password}' --pgsql-port=5432 \
  --oltp-tables-count=250 --oltp-table-size=450000 prepare
EOF

cat > $SCRIPTS_PATH/rds_saz_benchmark_prepare.sh <<EOF
#!/bin/bash
sysbench --test=/usr/local/share/sysbench/oltp.lua \
  --pgsql-host='$RDS_SAZ_ENDPOINT_IP' --pgsql-db='${database_name}' \
  --pgsql-user='${database_username}' --pgsql-password='${database_password}' --pgsql-port=5432 \
  --oltp-tables-count=250 --oltp-table-size=450000 prepare
EOF

cat > $SCRIPTS_PATH/aurora_benchmark_write.sh <<EOF
#!/bin/bash
sysbench --test=/usr/local/share/sysbench/oltp.lua \
  --pgsql-host='$AURORA_ENDPOINT_IP' \
  --pgsql-db='${database_name}' \
  --pgsql-user='${database_username}' \
  --pgsql-password='${database_password}' \
  --pgsql-port=5432 \
  --oltp-tables-count=250 --oltp-table-size=450000 --max-requests=0 --forced-shutdown \
  --report-interval=60 --oltp_simple_ranges=0 --oltp-distinct-ranges=0 \
  --oltp-sum-ranges=0 --oltp-order-ranges=0 --oltp-point-selects=0 --rand-type=uniform \
  --max-time=$BENCHMARK_TIME --num-threads=$BENCHMARK_CLIENTS run
EOF

cat > $SCRIPTS_PATH/rds_maz_benchmark_write.sh <<EOF
#!/bin/bash
sysbench --test=/usr/local/share/sysbench/oltp.lua \
  --pgsql-host='$RDS_MAZ_ENDPOINT_IP' \
  --pgsql-db='${database_name}' \
  --pgsql-user='${database_username}' \
  --pgsql-password='${database_password}' \
  --pgsql-port=5432 \
  --oltp-tables-count=250 --oltp-table-size=450000 --max-requests=0 --forced-shutdown \
  --report-interval=60 --oltp_simple_ranges=0 --oltp-distinct-ranges=0 \
  --oltp-sum-ranges=0 --oltp-order-ranges=0 --oltp-point-selects=0 --rand-type=uniform \
  --max-time=$BENCHMARK_TIME --num-threads=$BENCHMARK_CLIENTS run
EOF

cat > $SCRIPTS_PATH/rds_saz_benchmark_write.sh <<EOF
#!/bin/bash
sysbench --test=/usr/local/share/sysbench/oltp.lua \
  --pgsql-host='$RDS_SAZ_ENDPOINT_IP' \
  --pgsql-db='${database_name}' \
  --pgsql-user='${database_username}' \
  --pgsql-password='${database_password}' \
  --pgsql-port=5432 \
  --oltp-tables-count=250 --oltp-table-size=450000 --max-requests=0 --forced-shutdown \
  --report-interval=60 --oltp_simple_ranges=0 --oltp-distinct-ranges=0 \
  --oltp-sum-ranges=0 --oltp-order-ranges=0 --oltp-point-selects=0 --rand-type=uniform \
  --max-time=$BENCHMARK_TIME --num-threads=$BENCHMARK_CLIENTS run
EOF

cat > /home/ec2-user/wipedb.sql <<EOF
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
EOF

chmod +x $SCRIPTS_PATH/*.sh
chown -R ec2-user: $SCRIPTS_PATH/*

su - ec2-user -c '/home/ec2-user/scripts/install-benchmark-tools.sh'

reboot
