    01  db-object                      pic x(008).
      88  database-is-closed             value NULL.

    01  db-status                      pic s9(04) comp.
      88  call-successful                value ZERO.
      *> -- CobolSQLite3 Function codes --------------
      88  database-already-open          value -1.
      88  database-open-failed           value -2.
      88  database-not-open              value -3.
      88  unreleased-sql-objects-exist   value -4.
      88  sql-compile-failed             value -5.
      88  database-lock-failed           value -6.
      88  sql-object-not-released        value -7.
      88  sql-object-not-reset           value -8.
      88  datatype-unknown-unsupported   value -11.
      88  datatype-undefined             value -12.
      88  invalid-dbinfo-mode            value -13.
      88  not-an-sqlite-database         value -14.
      88  no-data-returned               value -15.
      88  row-buffer-overflow            value -16.
      *> -- SQLite3 Library codes --------------------
      88  database-row-available         value 100.
      88  sql-statement-finished         value 101.

    01  sql-object                     pic x(008).
      88  object-released                value NULL.

    01  row-delims.
      05  field-delimiter              pic x(001) value x'1D'.
      05  row-delimiter                pic x(001) value x'1E'.

    01  dbinfo-buffer                  pic x(080).
    01  redefines dbinfo-buffer.
      05  dbinfo-rows-changed          pic s9(09) comp.

    01  error-message                  pic x(128).
