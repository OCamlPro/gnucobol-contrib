-- Table: book

-- DROP TABLE book;

CREATE TABLE book
(
    ISBN              numeric(13,0) NOT NULL,
    AUTHORS           character(40) NOT NULL,
    TITLE             character(60) NOT NULL,
    PUB_DATE          date NOT NULL,
    PAGE_NR           numeric(4,0) NOT NULL,
    INSERT_USER       character(20) NOT NULL,
    INSERT_TIMESTAMP  timestamp without time zone NOT NULL,
    LUPD_USER         character(20) NOT NULL,
    LUPD_TIMESTAMP    timestamp without time zone NOT NULL,
    LUPD_COUNTER      numeric(6,0) NOT NULL,
    CONSTRAINT book_pkey PRIMARY KEY (ISBN)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

-- ALTER TABLE book
--     OWNER to postgres;
COMMENT ON TABLE book
     IS 'book example';

-- Index: BOOKX1

-- DROP INDEX "BOOKX1";

CREATE INDEX BOOKX1
    ON book USING btree
    (AUTHORS, TITLE, ISBN)
    TABLESPACE pg_default;

COMMENT ON INDEX BOOKX1
    IS 'Index for book table.';
