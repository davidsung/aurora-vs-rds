# Benchmark Performance for Aurora and RDS PostgreSQL
## Warning
:warning: This terraform script will provision AWS Resources with high cost spending!

# Preparation
* Create Keypair
```sh
aws ec2 create-key-pair --key-name <keypair_name> --query 'KeyMaterial' --output text > </path/to/key.pem>
chmod 400 </path/to/key.pem>
```

* Copy `terraform-example.tfvars` to `terraform.tfvars`
```sh
cp terraform-example.tfvars terraform.tfvars
```

* Modify `whitelist_ip` & `keypair_path` in `terraform.tfvars` according to your environment

* Run `terraform`
```sh
terraform init
terraform plan
terraform apply
```

# Patch `pgbench` for handling massive connections using `ppoll`
* https://commitfest.postgresql.org/18/1388/
* Apply patch on [postgresql-11.8 source code](https://ftp.postgresql.org/pub/source/v11.8/postgresql-11.8.tar.gz) with https://www.postgresql.org/message-id/attachment/64966/pgbench-ppoll-17.patch 
* add `ppoll` in `configure` & `configure.in`

# SSH Access to instance for running benchmark 
```sh
ssh -i </path/to/key.pem> -o ProxyCommand="ssh -i </path/to/key.pem> -W %h:%p ec2-user@$(terraform output bastion_endpoint)" ec2-user@$(terraform output benchmark_endpoint)
```

# Run Readwrite Initialization script
RDS Single-AZ
```sh
$ scripts/rds_saz_benchmark_init.sh
```

RDS Multi-AZ
```sh
$ scripts/rds_maz_benchmark_init.sh
```

Aurora
```sh
$ scripts/aurora_benchmark_init.sh
```

# Run Readwrite Benchmark script
RDS Single-AZ
```sh
$ scripts/rds_saz_benchmark_readwrite.sh
```

RDS Multi-AZ
```sh
$ scripts/rds_maz_benchmark_readwrite.sh
```

Aurora
```sh
$ scripts/aurora_benchmark_readwrite.sh
```

# Run Write Initialization script
RDS Single-AZ
```sh
$ scripts/rds_saz_benchmark_prepare.sh
```

RDS Multi-AZ
```sh
$ scripts/rds_maz_benchmark_prepare.sh
```

Aurora
```sh
$ scripts/aurora_benchmark_prepare.sh
```

# Run Write Benchmark script
RDS Single-AZ
```sh
$ scripts/rds_saz_benchmark_write.sh
```

RDS Multi-AZ
```sh
$ scripts/rds_maz_benchmark_write.sh
```

Aurora
```sh
$ scripts/aurora_benchmark_write.sh
```

# References
* https://d1.awsstatic.com/product-marketing/Aurora/RDS_Aurora_PostgreSQL_Performance_Assessment_Benchmarking_V1-0.pdf
* https://www.percona.com/live/e18/sites/default/files/slides/Deep%20Dive%20on%20Amazon%20Aurora%20-%20FileId%20-%20160328.pdf

# Unresolved issue
`pgbench` readwrite test experienced the following error if using postgresql DNS endpoint
```
could not translate host name "xxxxx.yyyyyyy.<region>.rds.amazonaws.com" to address: Name or service not known
```
## Workaround
Resolved the DB host name by `dig +short $AURORA_ENDPOINT` / `dig +short $RDS_MAZ_ENDPOINT` / `dig +short $RDS_SAZ_ENDPOINT` before running the benchmark scripts
