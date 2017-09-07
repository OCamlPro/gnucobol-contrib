    01  db-name                        pic x(256).

    01  db-object.
      05  db-object-ptr                usage pointer.
        88  database-is-closed           value NULL.

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
      88  datatype-not-text              value -9.
      88  datatype-not-integer           value -10.
      88  datatype-unknown-unsupported   value -11.
      88  datatype-undefined             value -12.
      *> -- SQLite3 Library codes --------------------
      88  database-row-available         value +100.
      88  sql-statement-finished         value +101.

    01  sql-statement                  pic x(2048).

    01  sql-object.
      05  sql-object-ptr               usage pointer.

    01  dbinfo-buffer                  pic x(080).
    01  redefines dbinfo-buffer.
      05  dbinfo-rows-changed          pic s9(09) comp.

    01  error-message                  pic x(256).
