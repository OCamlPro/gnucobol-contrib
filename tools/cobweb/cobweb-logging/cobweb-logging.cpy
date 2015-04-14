      *> ***************************************************************
      *>****C* cobweb/logging
      *> AUTHOR
      *>   Brian Tiffin
      *> DATE
      *>   20150413
      *> LICENSE
      *>   GNU Lesser General Public License, LGPL, 3.0 (or greater)
      *> PURPOSE
      *>   Enumerated values for syslog.  
      *> TECTONICS
      *>   COPY cobweb-logging.
      *> SOURCE
      *> ***************************************************************
       01 log-priorities.
          05 LOG-EMERG         usage binary-long      value   0.
          05 LOG-EMERG-MASK    usage binary-long      value   1.
          05 LOG-ALERT         usage binary-long      value   1.
          05 LOG-ALERT-MASK    usage binary-long      value   2.
          05 LOG-CRIT          usage binary-long      value   2.
          05 LOG-CRIT-MASK     usage binary-long      value   4.
          05 LOG-ERR           usage binary-long      value   3.
          05 LOG-ERR-MASK      usage binary-long      value   8.
          05 LOG-WARNING       usage binary-long      value   4.
          05 LOG-WARNING-MASK  usage binary-long      value  16.
          05 LOG-NOTICE        usage binary-long      value   5.
          05 LOG-NOTICE-MASK   usage binary-long      value  32.
          05 LOG-INFO          usage binary-long      value   6.
          05 LOG-INFO-MASK     usage binary-long      value  64.
          05 LOG-DEBUG         usage binary-long      value   7.
          05 LOG-DEBUG-MASK    usage binary-long      value 128.

       01 log-facilities.
          05 LOG-USER          usage binary-long      value   8.
          05 LOG-LOCAL0        usage binary-long      value 128.
          05 LOG-LOCAL1        usage binary-long      value 136.
          05 LOG-LOCAL2        usage binary-long      value 144.
          05 LOG-LOCAL3        usage binary-long      value 152.
          05 LOG-LOCAL4        usage binary-long      value 160.
          05 LOG-LOCAL5        usage binary-long      value 168.
          05 LOG-LOCAL6        usage binary-long      value 176.
          05 LOG-LOCAL7        usage binary-long      value 184.

       01 log-options.
          05 LOG-PID           usage binary-long      value  1.
          05 LOG-CONS          usage binary-long      value  2.
          05 LOG-ODELAY        usage binary-long      value  4.
          05 LOG-NDELAY        usage binary-long      value  8.
          05 LOG-NOWAIT        usage binary-long      value 16.
          05 LOG-PERROR        usage binary-long      value 32.
