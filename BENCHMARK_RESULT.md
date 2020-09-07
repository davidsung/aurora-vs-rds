# RDS Single AZ Env
## pgbench init
```
1000000000 of 1000000000 tuples (100%) done (elapsed 703.50 s, remaining 0.00 s)
vacuuming...
creating primary keys...
total time: 2045.15 s (drop 0.00 s, tables 0.01 s, insert 703.87 s, commit 0.06 s, primary 203.84 s, foreign 0.00 s, vacuum 1137.37 s)
done.
```

## Readwrite workload
```
starting vacuum...end.
progress: 60.0 s, 12745.1 tps, lat 158.945 ms stddev 133.651
progress: 120.0 s, 10737.3 tps, lat 190.622 ms stddev 153.021
progress: 180.0 s, 11233.4 tps, lat 182.399 ms stddev 145.723
progress: 240.0 s, 11826.5 tps, lat 172.042 ms stddev 141.602
progress: 300.0 s, 12262.3 tps, lat 168.101 ms stddev 140.951
progress: 360.0 s, 12669.0 tps, lat 161.648 ms stddev 129.060
progress: 420.0 s, 11961.6 tps, lat 170.416 ms stddev 136.319
progress: 480.0 s, 12355.6 tps, lat 166.385 ms stddev 132.376
progress: 540.0 s, 11610.8 tps, lat 176.490 ms stddev 148.114
progress: 600.0 s, 9814.7 tps, lat 208.319 ms stddev 198.787
progress: 660.0 s, 10335.7 tps, lat 197.193 ms stddev 183.561
progress: 720.0 s, 11367.2 tps, lat 181.437 ms stddev 170.483
progress: 780.0 s, 12904.6 tps, lat 158.429 ms stddev 140.270
progress: 840.0 s, 11189.1 tps, lat 183.334 ms stddev 146.940
progress: 900.0 s, 7543.3 tps, lat 269.113 ms stddev 231.614
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 10000
query mode: prepared
number of clients: 2048
number of threads: 2048
duration: 900 s
number of transactions actually processed: 10235422
latency average = 179.999 ms
latency stddev = 156.458 ms
tps = 11367.270891 (including connections establishing)
tps = 11374.327819 (excluding connections establishing)
```

## Write intensive workload
```
$ scripts/rds_saz_benchmark_write.sh
sysbench 0.5:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 2048
Report intermediate results every 60 second(s)
Random number generator seed is 0 and will be ignored

Forcing shutdown in 315 seconds

Initializing worker threads...

Threads started!

[  60s] threads: 2048, tps: 9383.77, reads: 0.00, writes: 37604.46, response time: 385.42ms (95%), errors: 0.22, reconnects:  0.00
[ 120s] threads: 2048, tps: 13280.27, reads: 0.00, writes: 53189.54, response time: 258.76ms (95%), errors: 0.22, reconnects:  0.00
[ 180s] threads: 2048, tps: 22179.82, reads: 0.00, writes: 88630.23, response time: 205.13ms (95%), errors: 0.48, reconnects:  0.00
[ 240s] threads: 2048, tps: 20190.99, reads: 0.00, writes: 80856.13, response time: 293.08ms (95%), errors: 0.57, reconnects:  0.00
[ 300s] threads: 2048, tps: 16843.99, reads: 0.00, writes: 67353.06, response time: 212.57ms (95%), errors: 0.42, reconnects:  0.00
OLTP test statistics:
    queries performed:
        read:                            0
        write:                           19659462
        other:                           9829674
        total:                           29489136
    transactions:                        4914780 (16380.27 per sec.)
    read/write requests:                 19659462 (65522.20 per sec.)
    other operations:                    9829674 (32760.91 per sec.)
    ignored errors:                      114    (0.38 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          300.0428s
    total number of events:              4914780
    total time taken by event execution: 614426.1590s
    response time:
         min:                                  3.20ms
         avg:                                125.02ms
         max:                               1152.62ms
         approx.  95 percentile:             276.21ms

Threads fairness:
    events (avg/stddev):           2399.7949/15.66
    execution time (avg/stddev):   300.0128/0.01
```

# RDS Multi_AZ Env
## Readwrite workload
```
starting vacuum...end.
progress: 60.0 s, 9511.4 tps, lat 210.502 ms stddev 287.233
progress: 120.0 s, 2909.3 tps, lat 708.903 ms stddev 548.006
progress: 180.0 s, 5691.4 tps, lat 354.010 ms stddev 444.532
progress: 240.0 s, 7102.0 tps, lat 290.264 ms stddev 389.901
progress: 300.0 s, 2486.4 tps, lat 827.306 ms stddev 486.096
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 10000
query mode: prepared
number of clients: 2048
number of threads: 2048
duration: 300 s
number of transactions actually processed: 1664076
latency average = 368.912 ms
latency stddev = 449.851 ms
tps = 5528.260643 (including connections establishing)
tps = 5543.824245 (excluding connections establishing)
```

## Write intensive workload
```
$ scripts/rds_maz_benchmark_write.sh
sysbench 0.5:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 2048
Report intermediate results every 60 second(s)
Random number generator seed is 0 and will be ignored

Forcing shutdown in 315 seconds

Initializing worker threads...

Threads started!

[  60s] threads: 2048, tps: 5006.99, reads: 0.00, writes: 20165.05, response time: 720.94ms (95%), errors: 0.18, reconnects:  0.00
[ 120s] threads: 2048, tps: 8245.13, reads: 0.00, writes: 32980.98, response time: 469.47ms (95%), errors: 0.15, reconnects:  0.00
[ 180s] threads: 2048, tps: 10372.83, reads: 0.00, writes: 41492.14, response time: 465.83ms (95%), errors: 0.28, reconnects:  0.00
[ 240s] threads: 2048, tps: 6465.97, reads: 0.00, writes: 25864.41, response time: 701.78ms (95%), errors: 0.17, reconnects:  0.00
[ 300s] threads: 2048, tps: 8910.77, reads: 0.00, writes: 35643.67, response time: 356.67ms (95%), errors: 0.20, reconnects:  0.00
OLTP test statistics:
    queries performed:
        read:                            0
        write:                           9368781
        other:                           4684361
        total:                           14053142
    transactions:                        2342151 (7803.03 per sec.)
    read/write requests:                 9368781 (31212.71 per sec.)
    other operations:                    4684361 (15606.26 per sec.)
    ignored errors:                      59     (0.20 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          300.1592s
    total number of events:              2342151
    total time taken by event execution: 614636.2793s
    response time:
         min:                                  6.52ms
         avg:                                262.42ms
         max:                               1906.72ms
         approx.  95 percentile:             607.49ms

Threads fairness:
    events (avg/stddev):           1143.6284/9.34
    execution time (avg/stddev):   300.1154/0.03
```

# Aurora
## Readwrite intensive benchmark
```
starting vacuum...end.
progress: 60.0 s, 29067.3 tps, lat 68.752 ms stddev 27.714
progress: 120.0 s, 29484.5 tps, lat 69.466 ms stddev 27.391
progress: 180.0 s, 29236.6 tps, lat 70.045 ms stddev 27.695
progress: 240.0 s, 29233.6 tps, lat 70.067 ms stddev 27.126
progress: 300.0 s, 29278.0 tps, lat 69.942 ms stddev 27.360
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 10000
query mode: prepared
number of clients: 2048
number of threads: 2048
duration: 300 s
number of transactions actually processed: 8780048
latency average = 69.676 ms
latency stddev = 27.566 ms
tps = 29192.216527 (including connections establishing)
tps = 29326.171143 (excluding connections establishing)
```

## Write intensive benchmark
```
$ scripts/aurora_benchmark_write.sh
sysbench 0.5:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 2048
Report intermediate results every 60 second(s)
Random number generator seed is 0 and will be ignored

Forcing shutdown in 315 seconds

Initializing worker threads...

Threads started!

[  60s] threads: 2048, tps: 20244.62, reads: 0.00, writes: 81096.88, response time: 156.50ms (95%), errors: 0.52, reconnects:  0.00
[ 120s] threads: 2048, tps: 21338.20, reads: 0.00, writes: 85364.04, response time: 145.12ms (95%), errors: 0.50, reconnects:  0.00
[ 180s] threads: 2048, tps: 21038.52, reads: 0.00, writes: 84143.88, response time: 150.16ms (95%), errors: 0.43, reconnects:  0.00
[ 240s] threads: 2048, tps: 19887.93, reads: 0.00, writes: 79574.26, response time: 156.68ms (95%), errors: 0.37, reconnects:  0.00
[ 300s] threads: 2048, tps: 18941.32, reads: 0.00, writes: 75766.64, response time: 164.42ms (95%), errors: 0.45, reconnects:  0.00
OLTP test statistics:
    queries performed:
        read:                            0
        write:                           24356756
        other:                           12178310
        total:                           36535066
    transactions:                        6089087 (20293.92 per sec.)
    read/write requests:                 24356756 (81177.04 per sec.)
    other operations:                    12178310 (40588.29 per sec.)
    ignored errors:                      136    (0.45 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          300.0449s
    total number of events:              6089087
    total time taken by event execution: 614427.9077s
    response time:
         min:                                  4.73ms
         avg:                                100.91ms
         max:                                553.28ms
         approx.  95 percentile:             155.05ms

Threads fairness:
    events (avg/stddev):           2973.1870/14.25
    execution time (avg/stddev):   300.0136/0.01
```