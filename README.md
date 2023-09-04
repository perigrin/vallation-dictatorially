Having read John Napiorkowski's
[post](https://dev.to/jjn1056/benchmarking-core-class-573c) benchmarking the
new class feature in 5.38.0, I didn't find his results too surprising. I
noticed however his script was a little naieve in places. Moose does a lot of
work during compilation to speed up runtime performance. Moo originally
detected if Moose is loaded and just provided a shim, it may still or it may
not. So I modified his script to isolate each run using string eval in a BEGIN
block.

I also set it up to use `time` on each run to compare the startup times of the
various runs and here are the results I got on my 13-inch, M1, 2020 MacBook Pro:

```
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 29 wallclock secs (29.33 usr +  0.05 sys = 29.38 CPU) @ 680735.19/s (n=20000000)
Moose: Create object: 22 wallclock secs (21.75 usr +  0.04 sys = 21.79 CPU) @ 917852.23/s (n=20000000)
Moose size: 420 bytes
       55.30 real        55.10 user         0.10 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 24 wallclock secs (23.87 usr +  0.05 sys = 23.92 CPU) @ 836120.40/s (n=20000000)
Moo: Create object: 16 wallclock secs (16.03 usr +  0.03 sys = 16.06 CPU) @ 1245330.01/s (n=20000000)
Moo size: 420 bytes
       43.97 real        43.87 user         0.08 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 19 wallclock secs (19.24 usr +  0.04 sys = 19.28 CPU) @ 1037344.40/s (n=20000000)
Core: Create object: 12 wallclock secs (11.67 usr +  0.02 sys = 11.69 CPU) @ 1710863.99/s (n=20000000)
Core size: 107 bytes
       35.00 real        34.89 user         0.06 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 13 wallclock secs (13.68 usr +  0.03 sys = 13.71 CPU) @ 1458789.20/s (n=20000000)
Bless: Create object:  8 wallclock secs ( 7.13 usr +  0.01 sys =  7.14 CPU) @ 2801120.45/s (n=20000000)
Bless size: 420 bytes
       24.86 real        24.81 user         0.04 sys

```

I also ran this on an Intel Macbook to see if that was the difference, on my
13-inch, 2020 MacBook Pro with 2.3 GHz Quad-Core Intel Core i7:

```
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 49 wallclock secs (47.73 usr +  0.11 sys = 47.84 CPU) @ 418060.20/s (n=20000000)
Moose: Create object: 34 wallclock secs (34.58 usr +  0.05 sys = 34.63 CPU) @ 577533.93/s (n=20000000)
Moose size: 420 bytes
       89.20 real        88.83 user         0.17 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 34 wallclock secs (34.25 usr +  0.02 sys = 34.27 CPU) @ 583600.82/s (n=20000000)
Moo: Create object: 22 wallclock secs (23.20 usr +  0.02 sys = 23.22 CPU) @ 861326.44/s (n=20000000)
Moo size: 420 bytes
       62.66 real        62.49 user         0.06 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 30 wallclock secs (29.51 usr +  0.02 sys = 29.53 CPU) @ 677277.35/s (n=20000000)
Core: Create object: 19 wallclock secs (18.05 usr +  0.01 sys = 18.06 CPU) @ 1107419.71/s (n=20000000)
Core size: 107 bytes
       52.36 real        52.29 user         0.03 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 18 wallclock secs (18.36 usr +  0.01 sys = 18.37 CPU) @ 1088731.63/s (n=20000000)
Bless: Create object:  8 wallclock secs ( 9.69 usr +  0.01 sys =  9.70 CPU) @ 2061855.67/s (n=20000000)
Bless size: 420 bytes
       32.82 real        32.78 user         0.02 sys
```

I also tried this on a fresh install of Ubuntu 22.04.3 LTS in an LXC container on an older Intel Xenon CPU:

```
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 149 wallclock secs (148.54 usr +  0.00 sys = 148.54 CPU) @ 134643.87/s (n=20000000)
Moose: Create object: 105 wallclock secs (106.07 usr +  0.00 sys = 106.07 CPU) @ 188554.73/s (n=20000000)
Moose size: 420 bytes
276.36user 0.02system 4:36.49elapsed 99%CPU (0avgtext+0avgdata 19320maxresident)k
2012inputs+0outputs (35major+3952minor)pagefaults 0swaps
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 111 wallclock secs (111.87 usr +  0.01 sys = 111.88 CPU) @ 178762.96/s (n=20000000)
Moo: Create object: 71 wallclock secs (70.12 usr +  0.01 sys = 70.13 CPU) @ 285184.66/s (n=20000000)
Moo size: 420 bytes
203.17user 0.03system 3:23.29elapsed 99%CPU (0avgtext+0avgdata 8168maxresident)k
572inputs+0outputs (0major+1833minor)pagefaults 0swaps
+ COR=1
+ time perl ./test.pl
Core: Create and access: 82 wallclock secs (81.59 usr +  0.00 sys = 81.59 CPU) @ 245128.08/s (n=20000000)
Core: Create object: 45 wallclock secs (45.30 usr +  0.00 sys = 45.30 CPU) @ 441501.10/s (n=20000000)
Core size: 135 bytes
147.80user 0.00system 2:27.86elapsed 99%CPU (0avgtext+0avgdata 6008maxresident)k
447inputs+0outputs (2major+1250minor)pagefaults 0swaps
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 57 wallclock secs (55.83 usr +  0.01 sys = 55.84 CPU) @ 358166.19/s (n=20000000)
Bless: Create object: 31 wallclock secs (30.67 usr +  0.00 sys = 30.67 CPU) @ 652103.03/s (n=20000000)
Bless size: 420 bytes
108.34user 0.01system 1:48.40elapsed 99%CPU (0avgtext+0avgdata 5848maxresident)k
313inputs+0outputs (0major+990minor)pagefaults 0swaps

```

I ran each run 3x on each box to make sure there wasn't any system caching or
something that was going to affect performance and all the runs were
comparable. You can see them for yourself below.



## FULL RUN 13-inch, M1, 2020 MacBook Pro

```
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 29 wallclock secs (29.33 usr +  0.05 sys = 29.38 CPU) @ 680735.19/s (n=20000000)
Moose: Create object: 22 wallclock secs (21.75 usr +  0.04 sys = 21.79 CPU) @ 917852.23/s (n=20000000)
Moose size: 420 bytes
       55.30 real        55.10 user         0.10 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 24 wallclock secs (23.87 usr +  0.05 sys = 23.92 CPU) @ 836120.40/s (n=20000000)
Moo: Create object: 16 wallclock secs (16.03 usr +  0.03 sys = 16.06 CPU) @ 1245330.01/s (n=20000000)
Moo size: 420 bytes
       43.97 real        43.87 user         0.08 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 19 wallclock secs (19.24 usr +  0.04 sys = 19.28 CPU) @ 1037344.40/s (n=20000000)
Core: Create object: 12 wallclock secs (11.67 usr +  0.02 sys = 11.69 CPU) @ 1710863.99/s (n=20000000)
Core size: 107 bytes
       35.00 real        34.89 user         0.06 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 13 wallclock secs (13.68 usr +  0.03 sys = 13.71 CPU) @ 1458789.20/s (n=20000000)
Bless: Create object:  8 wallclock secs ( 7.13 usr +  0.01 sys =  7.14 CPU) @ 2801120.45/s (n=20000000)
Bless size: 420 bytes
       24.86 real        24.81 user         0.04 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 30 wallclock secs (29.83 usr +  0.08 sys = 29.91 CPU) @ 668672.68/s (n=20000000)
Moose: Create object: 22 wallclock secs (21.89 usr +  0.05 sys = 21.94 CPU) @ 911577.03/s (n=20000000)
Moose size: 420 bytes
       55.95 real        55.73 user         0.13 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 24 wallclock secs (24.44 usr +  0.05 sys = 24.49 CPU) @ 816659.86/s (n=20000000)
Moo: Create object: 17 wallclock secs (16.49 usr +  0.04 sys = 16.53 CPU) @ 1209921.36/s (n=20000000)
Moo size: 420 bytes
       45.06 real        44.92 user         0.09 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 19 wallclock secs (19.46 usr +  0.03 sys = 19.49 CPU) @ 1026167.27/s (n=20000000)
Core: Create object: 12 wallclock secs (11.77 usr +  0.05 sys = 11.82 CPU) @ 1692047.38/s (n=20000000)
Core size: 107 bytes
       35.34 real        35.23 user         0.08 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 14 wallclock secs (13.86 usr +  0.03 sys = 13.89 CPU) @ 1439884.81/s (n=20000000)
Bless: Create object:  7 wallclock secs ( 7.08 usr +  0.01 sys =  7.09 CPU) @ 2820874.47/s (n=20000000)
Bless size: 420 bytes
       25.00 real        24.94 user         0.04 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 30 wallclock secs (29.75 usr +  0.05 sys = 29.80 CPU) @ 671140.94/s (n=20000000)
Moose: Create object: 22 wallclock secs (21.89 usr +  0.04 sys = 21.93 CPU) @ 911992.70/s (n=20000000)
Moose size: 420 bytes
       55.87 real        55.71 user         0.11 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 24 wallclock secs (23.96 usr +  0.05 sys = 24.01 CPU) @ 832986.26/s (n=20000000)
Moo: Create object: 16 wallclock secs (16.13 usr +  0.04 sys = 16.17 CPU) @ 1236858.38/s (n=20000000)
Moo size: 420 bytes
       44.22 real        44.10 user         0.09 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 20 wallclock secs (19.69 usr +  0.04 sys = 19.73 CPU) @ 1013684.74/s (n=20000000)
Core: Create object: 12 wallclock secs (11.92 usr +  0.03 sys = 11.95 CPU) @ 1673640.17/s (n=20000000)
Core size: 107 bytes
       35.70 real        35.59 user         0.07 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 14 wallclock secs (13.62 usr +  0.02 sys = 13.64 CPU) @ 1466275.66/s (n=20000000)
Bless: Create object:  7 wallclock secs ( 7.05 usr +  0.00 sys =  7.05 CPU) @ 2836879.43/s (n=20000000)
Bless size: 420 bytes
       24.70 real        24.65 user         0.04 sys
```

## FULL RUN 13-inch, 2020 MacBook Pro with 2.3 GHz Quad-Core Intel Core i7
```
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 49 wallclock secs (47.73 usr +  0.11 sys = 47.84 CPU) @ 418060.20/s (n=20000000)
Moose: Create object: 34 wallclock secs (34.58 usr +  0.05 sys = 34.63 CPU) @ 577533.93/s (n=20000000)
Moose size: 420 bytes
       89.20 real        88.83 user         0.17 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 34 wallclock secs (34.25 usr +  0.02 sys = 34.27 CPU) @ 583600.82/s (n=20000000)
Moo: Create object: 22 wallclock secs (23.20 usr +  0.02 sys = 23.22 CPU) @ 861326.44/s (n=20000000)
Moo size: 420 bytes
       62.66 real        62.49 user         0.06 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 30 wallclock secs (29.51 usr +  0.02 sys = 29.53 CPU) @ 677277.35/s (n=20000000)
Core: Create object: 19 wallclock secs (18.05 usr +  0.01 sys = 18.06 CPU) @ 1107419.71/s (n=20000000)
Core size: 107 bytes
       52.36 real        52.29 user         0.03 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 18 wallclock secs (18.36 usr +  0.01 sys = 18.37 CPU) @ 1088731.63/s (n=20000000)
Bless: Create object:  8 wallclock secs ( 9.69 usr +  0.01 sys =  9.70 CPU) @ 2061855.67/s (n=20000000)
Bless size: 420 bytes
       32.82 real        32.78 user         0.02 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 42 wallclock secs (41.70 usr +  0.03 sys = 41.73 CPU) @ 479271.51/s (n=20000000)
Moose: Create object: 31 wallclock secs (30.84 usr +  0.02 sys = 30.86 CPU) @ 648088.14/s (n=20000000)
Moose size: 420 bytes
       77.42 real        77.30 user         0.06 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 34 wallclock secs (33.81 usr +  0.08 sys = 33.89 CPU) @ 590144.59/s (n=20000000)
Moo: Create object: 21 wallclock secs (22.50 usr +  0.02 sys = 22.52 CPU) @ 888099.47/s (n=20000000)
Moo size: 420 bytes
       61.32 real        61.06 user         0.10 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 29 wallclock secs (29.80 usr +  0.02 sys = 29.82 CPU) @ 670690.81/s (n=20000000)
Core: Create object: 19 wallclock secs (18.43 usr +  0.02 sys = 18.45 CPU) @ 1084010.84/s (n=20000000)
Core size: 107 bytes
       53.24 real        53.14 user         0.04 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 18 wallclock secs (18.31 usr +  0.02 sys = 18.33 CPU) @ 1091107.47/s (n=20000000)
Bless: Create object:  9 wallclock secs ( 9.81 usr +  0.00 sys =  9.81 CPU) @ 2038735.98/s (n=20000000)
Bless size: 420 bytes
       33.04 real        32.98 user         0.02 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 42 wallclock secs (41.72 usr +  0.02 sys = 41.74 CPU) @ 479156.68/s (n=20000000)
Moose: Create object: 31 wallclock secs (30.64 usr +  0.02 sys = 30.66 CPU) @ 652315.72/s (n=20000000)
Moose size: 420 bytes
       77.35 real        77.24 user         0.05 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 33 wallclock secs (32.33 usr +  0.02 sys = 32.35 CPU) @ 618238.02/s (n=20000000)
Moo: Create object: 22 wallclock secs (22.02 usr +  0.01 sys = 22.03 CPU) @ 907852.93/s (n=20000000)
Moo size: 420 bytes
       59.03 real        58.96 user         0.03 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 30 wallclock secs (29.13 usr +  0.01 sys = 29.14 CPU) @ 686341.80/s (n=20000000)
Core: Create object: 18 wallclock secs (18.14 usr + -0.00 sys = 18.14 CPU) @ 1102535.83/s (n=20000000)
Core size: 107 bytes
       52.01 real        51.95 user         0.03 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 19 wallclock secs (18.22 usr +  0.01 sys = 18.23 CPU) @ 1097092.70/s (n=20000000)
Bless: Create object: 10 wallclock secs ( 9.63 usr +  0.00 sys =  9.63 CPU) @ 2076843.20/s (n=20000000)
Bless size: 420 bytes
       32.63 real        32.59 user         0.02 sys
```

## FULL RUN Ubuntu Intel(R) Xeon(R) CPU L5639 @ 2.13GHz

```
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 149 wallclock secs (148.54 usr +  0.00 sys = 148.54 CPU) @ 134643.87/s (n=20000000)
Moose: Create object: 105 wallclock secs (106.07 usr +  0.00 sys = 106.07 CPU) @ 188554.73/s (n=20000000)
Moose size: 420 bytes
276.36user 0.02system 4:36.49elapsed 99%CPU (0avgtext+0avgdata 19320maxresident)k
2012inputs+0outputs (35major+3952minor)pagefaults 0swaps
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 111 wallclock secs (111.87 usr +  0.01 sys = 111.88 CPU) @ 178762.96/s (n=20000000)
Moo: Create object: 71 wallclock secs (70.12 usr +  0.01 sys = 70.13 CPU) @ 285184.66/s (n=20000000)
Moo size: 420 bytes
203.17user 0.03system 3:23.29elapsed 99%CPU (0avgtext+0avgdata 8168maxresident)k
572inputs+0outputs (0major+1833minor)pagefaults 0swaps
+ COR=1
+ time perl ./test.pl
Core: Create and access: 82 wallclock secs (81.59 usr +  0.00 sys = 81.59 CPU) @ 245128.08/s (n=20000000)
Core: Create object: 45 wallclock secs (45.30 usr +  0.00 sys = 45.30 CPU) @ 441501.10/s (n=20000000)
Core size: 135 bytes
147.80user 0.00system 2:27.86elapsed 99%CPU (0avgtext+0avgdata 6008maxresident)k
447inputs+0outputs (2major+1250minor)pagefaults 0swaps
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 57 wallclock secs (55.83 usr +  0.01 sys = 55.84 CPU) @ 358166.19/s (n=20000000)
Bless: Create object: 31 wallclock secs (30.67 usr +  0.00 sys = 30.67 CPU) @ 652103.03/s (n=20000000)
Bless size: 420 bytes
108.34user 0.01system 1:48.40elapsed 99%CPU (0avgtext+0avgdata 5848maxresident)k
313inputs+0outputs (0major+990minor)pagefaults 0swaps
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 147 wallclock secs (147.03 usr +  0.00 sys = 147.03 CPU) @ 136026.66/s (n=20000000)
Moose: Create object: 98 wallclock secs (98.17 usr +  0.00 sys = 98.17 CPU) @ 203728.23/s (n=20000000)
Moose size: 420 bytes
267.42user 0.03system 4:27.57elapsed 99%CPU (0avgtext+0avgdata 19276maxresident)k
2012inputs+0outputs (0major+6699minor)pagefaults 0swaps
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 109 wallclock secs (107.97 usr +  0.00 sys = 107.97 CPU) @ 185236.64/s (n=20000000)
Moo: Create object: 64 wallclock secs (65.10 usr +  0.00 sys = 65.10 CPU) @ 307219.66/s (n=20000000)
Moo size: 420 bytes
195.45user 0.03system 3:15.56elapsed 99%CPU (0avgtext+0avgdata 8132maxresident)k
572inputs+0outputs (0major+1999minor)pagefaults 0swaps
+ COR=1
+ time perl ./test.pl
Core: Create and access: 78 wallclock secs (78.73 usr +  0.00 sys = 78.73 CPU) @ 254032.77/s (n=20000000)
Core: Create object: 44 wallclock secs (44.19 usr +  0.00 sys = 44.19 CPU) @ 452591.08/s (n=20000000)
Core size: 135 bytes
143.30user 0.00system 2:23.36elapsed 99%CPU (0avgtext+0avgdata 6048maxresident)k
447inputs+0outputs (0major+1150minor)pagefaults 0swaps
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 55 wallclock secs (53.81 usr +  0.00 sys = 53.81 CPU) @ 371678.13/s (n=20000000)
Bless: Create object: 29 wallclock secs (29.42 usr +  0.00 sys = 29.42 CPU) @ 679809.65/s (n=20000000)
Bless size: 420 bytes
104.49user 0.00system 1:44.54elapsed 99%CPU (0avgtext+0avgdata 5728maxresident)k
313inputs+0outputs (0major+642minor)pagefaults 0swaps
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 145 wallclock secs (144.84 usr +  0.01 sys = 144.85 CPU) @ 138073.87/s (n=20000000)
Moose: Create object: 102 wallclock secs (101.55 usr +  0.00 sys = 101.55 CPU) @ 196947.32/s (n=20000000)
Moose size: 420 bytes
266.81user 0.03system 4:26.95elapsed 99%CPU (0avgtext+0avgdata 19188maxresident)k
2012inputs+0outputs (0major+6598minor)pagefaults 0swaps
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 110 wallclock secs (109.60 usr +  0.00 sys = 109.60 CPU) @ 182481.75/s (n=20000000)
Moo: Create object: 67 wallclock secs (67.73 usr +  0.00 sys = 67.73 CPU) @ 295290.12/s (n=20000000)
Moo size: 420 bytes
197.66user 0.01system 3:17.75elapsed 99%CPU (0avgtext+0avgdata 8092maxresident)k
572inputs+0outputs (0major+1815minor)pagefaults 0swaps
+ COR=1
+ time perl ./test.pl
Core: Create and access: 84 wallclock secs (84.85 usr +  0.00 sys = 84.85 CPU) @ 235710.08/s (n=20000000)
Core: Create object: 47 wallclock secs (47.77 usr +  0.00 sys = 47.77 CPU) @ 418672.81/s (n=20000000)
Core size: 135 bytes
152.90user 0.00system 2:32.97elapsed 99%CPU (0avgtext+0avgdata 6108maxresident)k
447inputs+0outputs (0major+708minor)pagefaults 0swaps
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 52 wallclock secs (52.73 usr +  0.00 sys = 52.73 CPU) @ 379290.73/s (n=20000000)
Bless: Create object: 28 wallclock secs (28.72 usr +  0.00 sys = 28.72 CPU) @ 696378.83/s (n=20000000)
Bless size: 420 bytes
103.28user 0.01system 1:43.35elapsed 99%CPU (0avgtext+0avgdata 5876maxresident)k
313inputs+0outputs (0major+645minor)pagefaults 0swaps
```

