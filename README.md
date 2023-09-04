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

These results are consistent across several runs (see the bottom for a 3x run) on this machine.




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
