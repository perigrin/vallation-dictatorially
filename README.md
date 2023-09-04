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
time: command terminated abnormally
        0.59 real         0.57 user         0.00 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 30 wallclock secs (30.28 usr +  0.11 sys = 30.39 CPU) @ 658111.22/s (n=20000000)
Moose: Create object: 23 wallclock secs (22.32 usr +  0.08 sys = 22.40 CPU) @ 892857.14/s (n=20000000)
Moose size: 420 bytes
       57.29 real        56.81 user         0.22 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 24 wallclock secs (24.01 usr +  0.09 sys = 24.10 CPU) @ 829875.52/s (n=20000000)
Moo: Create object: 16 wallclock secs (16.04 usr +  0.06 sys = 16.10 CPU) @ 1242236.02/s (n=20000000)
Moo size: 420 bytes
       44.28 real        44.06 user         0.17 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 20 wallclock secs (19.83 usr +  0.11 sys = 19.94 CPU) @ 1003009.03/s (n=20000000)
Core: Create object: 11 wallclock secs (12.05 usr +  0.03 sys = 12.08 CPU) @ 1655629.14/s (n=20000000)
Core size: 107 bytes
       36.41 real        35.90 user         0.14 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 13 wallclock secs (13.57 usr +  0.02 sys = 13.59 CPU) @ 1471670.35/s (n=20000000)
Bless: Create object:  7 wallclock secs ( 7.01 usr +  0.01 sys =  7.02 CPU) @ 2849002.85/s (n=20000000)
Bless size: 420 bytes
       24.68 real        24.62 user         0.05 sys
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

I also tried this on a fresh install of ubuntu in an LXC container:





## FULL RUN 13-inch, M1, 2020 MacBook Pro

```
+ MOOSE=1
+ time perl ./test.pl
time: command terminated abnormally
        0.59 real         0.57 user         0.00 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 30 wallclock secs (30.28 usr +  0.11 sys = 30.39 CPU) @ 658111.22/s (n=20000000)
Moose: Create object: 23 wallclock secs (22.32 usr +  0.08 sys = 22.40 CPU) @ 892857.14/s (n=20000000)
Moose size: 420 bytes
       57.29 real        56.81 user         0.22 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 24 wallclock secs (24.01 usr +  0.09 sys = 24.10 CPU) @ 829875.52/s (n=20000000)
Moo: Create object: 16 wallclock secs (16.04 usr +  0.06 sys = 16.10 CPU) @ 1242236.02/s (n=20000000)
Moo size: 420 bytes
       44.28 real        44.06 user         0.17 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 20 wallclock secs (19.83 usr +  0.11 sys = 19.94 CPU) @ 1003009.03/s (n=20000000)
Core: Create object: 11 wallclock secs (12.05 usr +  0.03 sys = 12.08 CPU) @ 1655629.14/s (n=20000000)
Core size: 107 bytes
       36.41 real        35.90 user         0.14 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 13 wallclock secs (13.57 usr +  0.02 sys = 13.59 CPU) @ 1471670.35/s (n=20000000)
Bless: Create object:  7 wallclock secs ( 7.01 usr +  0.01 sys =  7.02 CPU) @ 2849002.85/s (n=20000000)
Bless size: 420 bytes
       24.68 real        24.62 user         0.05 sys

+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 29 wallclock secs (29.84 usr +  0.07 sys = 29.91 CPU) @ 668672.68/s (n=20000000)
Moose: Create object: 22 wallclock secs (21.91 usr +  0.04 sys = 21.95 CPU) @ 911161.73/s (n=20000000)
Moose size: 420 bytes
       55.99 real        55.80 user         0.12 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 25 wallclock secs (24.01 usr +  0.04 sys = 24.05 CPU) @ 831600.83/s (n=20000000)
Moo: Create object: 16 wallclock secs (16.15 usr +  0.03 sys = 16.18 CPU) @ 1236093.94/s (n=20000000)
Moo size: 420 bytes
       44.32 real        44.19 user         0.08 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 19 wallclock secs (19.41 usr +  0.03 sys = 19.44 CPU) @ 1028806.58/s (n=20000000)
Core: Create object: 12 wallclock secs (11.73 usr +  0.02 sys = 11.75 CPU) @ 1702127.66/s (n=20000000)
Core size: 107 bytes
       35.21 real        35.14 user         0.05 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 14 wallclock secs (13.49 usr +  0.03 sys = 13.52 CPU) @ 1479289.94/s (n=20000000)
Bless: Create object:  6 wallclock secs ( 6.95 usr +  0.01 sys =  6.96 CPU) @ 2873563.22/s (n=20000000)
Bless size: 420 bytes
       24.50 real        24.44 user         0.04 sys
+ MOOSE=1
+ time perl ./test.pl
Moose: Create and access: 30 wallclock secs (30.29 usr +  0.05 sys = 30.34 CPU) @ 659195.78/s (n=20000000)
Moose: Create object: 22 wallclock secs (22.33 usr +  0.04 sys = 22.37 CPU) @ 894054.54/s (n=20000000)
Moose size: 420 bytes
       56.84 real        56.71 user         0.09 sys
+ MOO=1
+ time perl ./test.pl
Moo: Create and access: 23 wallclock secs (23.90 usr +  0.04 sys = 23.94 CPU) @ 835421.89/s (n=20000000)
Moo: Create object: 17 wallclock secs (16.04 usr +  0.02 sys = 16.06 CPU) @ 1245330.01/s (n=20000000)
Moo size: 420 bytes
       44.04 real        43.95 user         0.06 sys
+ COR=1
+ time perl ./test.pl
Core: Create and access: 19 wallclock secs (19.39 usr +  0.03 sys = 19.42 CPU) @ 1029866.12/s (n=20000000)
Core: Create object: 12 wallclock secs (11.69 usr +  0.01 sys = 11.70 CPU) @ 1709401.71/s (n=20000000)
Core size: 107 bytes
       35.18 real        35.10 user         0.06 sys
+ BLESS=1
+ time perl ./test.pl
Bless: Create and access: 13 wallclock secs (13.30 usr +  0.02 sys = 13.32 CPU) @ 1501501.50/s (n=20000000)
Bless: Create object:  7 wallclock secs ( 6.95 usr +  0.02 sys =  6.97 CPU) @ 2869440.46/s (n=20000000)
Bless size: 420 bytes
       24.30 real        24.25 user         0.04 sys
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

