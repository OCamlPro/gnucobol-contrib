       01 :tag:evaluator-record.
          05 :tag:evaluator         usage pointer.
          05 :tag:evaluator-image   usage pointer.
          05 :tag:evaluator-prime   usage pointer.
          05 :tag:prime-image       usage pointer.
          05 :tag:variable-names    usage pointer.
          05 :tag:variable-count    usage binary-long.

       01 :tag:NAME-LIMIT           constant as 16.
       01 :tag:name-list            based.               
          05 :tag:variable-name     usage pointer
                                   occurs :tag:NAME-LIMIT times.
       01 :tag:value-list.
          05 :tag:variable-value    usage float-long
                                   occurs :tag:NAME-LIMIT times.
       01 :tag:lme-result           usage float-long.

