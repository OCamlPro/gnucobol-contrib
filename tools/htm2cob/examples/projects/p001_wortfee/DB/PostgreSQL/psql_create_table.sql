-- psql -l                          list databases
-- psql -d testdb                   connect to testdb
-- psql -f file_name                commands from file
--

-- #############################################################################
-- create database
CREATE DATABASE "wortfee"
    WITH OWNER "wortfee"
    ENCODING 'UTF8'
    LC_COLLATE = 'de_DE.UTF-8'
    LC_CTYPE = 'de_DE.UTF-8'
    TEMPLATE template0;

-- #############################################################################
-- TABLE: WF_SESSION

-- DROP TABLE WF_SESSION;

CREATE TABLE WF_SESSION
(
    SESS_SESSION_ID_HEX    CHARACTER(128) NOT NULL,
    SESS_NICKNAME          CHARACTER(15) NOT NULL,
    SESS_LANGUAGES         CHARACTER(5) NOT NULL,
    SESS_LEVEL             NUMERIC(1,0) NOT NULL,
    SESS_QUESTION_COUNT    NUMERIC(6,0) NOT NULL,
    SESS_ANSWER_OK_COUNT   NUMERIC(6,0) NOT NULL,
    SESS_SUCCESS_0         NUMERIC(4,0) NOT NULL,
    SESS_SUCCESS_1         NUMERIC(4,0) NOT NULL,
    SESS_SUCCESS_2         NUMERIC(4,0) NOT NULL,
    SESS_SUCCESS_3         NUMERIC(4,0) NOT NULL,
    SESS_SUCCESS_4         NUMERIC(4,0) NOT NULL,
    SESS_SUCCESS_5         NUMERIC(4,0) NOT NULL,
    SESS_MAX_USER_WORD     NUMERIC(4,0) NOT NULL,
    SESS_USER_WORD_TABLE   CHARACTER(15000) NOT NULL,
    SESS_CURR_IMG_NR       NUMERIC(1,0) NOT NULL,
    SESS_CURR_WORD_NR      NUMERIC(4,0) NOT NULL,
    SESS_LAST_WORD_NR_1    NUMERIC(4,0) NOT NULL,
    SESS_LAST_WORD_NR_2    NUMERIC(4,0) NOT NULL,
    SESS_INSERT_TIMESTAMP  TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    SESS_LUPD_TIMESTAMP    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    SESS_LUPD_COUNTER      NUMERIC(6,0) NOT NULL,
    CONSTRAINT WF_SESSION_PKEY PRIMARY KEY (SESS_SESSION_ID_HEX)
)
WITH (
    OIDS = FALSE
)
TABLESPACE PG_DEFAULT;

-- ALTER TABLE WF_SESSION
--     OWNER TO POSTGRES;

-- #############################################################################
-- TABLE: WF_DICTIONARY

-- DROP TABLE WF_DICTIONARY;

CREATE TABLE WF_DICTIONARY
(
    DICT_WORD_NR           NUMERIC(4,0) NOT NULL,
    DICT_WORD              CHARACTER(80) NOT NULL,
    DICT_IMAGE             CHARACTER(80) NOT NULL,
    DICT_IMAGE_OWNER       CHARACTER(80) NOT NULL,
    DICT_LEVEL             NUMERIC(1,0) NOT NULL,
    DICT_WORD_DE           CHARACTER(80) NOT NULL,
    DICT_WORD_EN           CHARACTER(80) NOT NULL,
    DICT_WORD_HU           CHARACTER(80) NOT NULL,
    CONSTRAINT WF_DICTIONARY_PKEY PRIMARY KEY (DICT_WORD_NR)
)
WITH (
    OIDS = FALSE
)
TABLESPACE PG_DEFAULT;

-- ALTER TABLE WF_DICTIONARY
--     OWNER TO POSTGRES;


-- #############################################################################
-- TABLE: WF_GUESTLIST

-- DROP TABLE WF_GUESTLIST;

CREATE TABLE WF_GUESTLIST
(
    GLST_SESSION_ID_HEX    CHARACTER(128) NOT NULL,
    GLST_START_TIMESTAMP   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    GLST_END_TIMESTAMP     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    GLST_NICKNAME          CHARACTER(15) NOT NULL,
    GLST_LANGUAGES         CHARACTER(5) NOT NULL,
    GLST_LEVEL             NUMERIC(1,0) NOT NULL,
    GLST_QUESTION_COUNT    NUMERIC(6,0) NOT NULL,
    GLST_ANSWER_OK_COUNT   NUMERIC(6,0) NOT NULL,
    GLST_MAX_USER_WORD     NUMERIC(4,0) NOT NULL,
    GLST_INSERT_TIMESTAMP  TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT WF_GUESTLIST_PKEY PRIMARY KEY (GLST_SESSION_ID_HEX,
                                              GLST_START_TIMESTAMP)
)
WITH (
    OIDS = FALSE
)
TABLESPACE PG_DEFAULT;

-- ALTER TABLE WF_GUESTLIST
--     OWNER TO POSTGRES;


-- #############################################################################
-- import data
-- cygwin
SET CLIENT_ENCODING TO 'utf8';
COPY WF_DICTIONARY(DICT_WORD_NR, DICT_WORD, DICT_IMAGE, DICT_IMAGE_OWNER, DICT_LEVEL, DICT_WORD_DE, DICT_WORD_EN, DICT_WORD_HU) 
FROM 'C:\cygwin64\home\laszlo.erdoes\htm2cob\examples\projects\p001_wortfee\DB\PostgreSQL\words_unicode_2019_12_27.csv' DELIMITER '|' encoding 'UTF8';

-- import data
-- linux
SET CLIENT_ENCODING TO 'utf8';
\COPY WF_DICTIONARY(DICT_WORD_NR, DICT_WORD, DICT_IMAGE, DICT_IMAGE_OWNER, DICT_LEVEL, DICT_WORD_DE, DICT_WORD_EN, DICT_WORD_HU) FROM '/home/wortfee/htm2cob/examples/projects/p001_wortfee/DB/PostgreSQL/words_unicode_2019_12_27.csv' DELIMITER '|' encoding 'UTF8';

-- #############################################################################
-- selects
select *
from   WF_DICTIONARY
;

select SESS_SESSION_ID_HEX
     , SESS_NICKNAME        
     , SESS_LANGUAGES       
     , SESS_LEVEL           
     , SESS_QUESTION_COUNT  
     , SESS_ANSWER_OK_COUNT 
     , SESS_SUCCESS_0       
     , SESS_SUCCESS_1       
     , SESS_SUCCESS_2       
     , SESS_SUCCESS_3       
     , SESS_SUCCESS_4       
     , SESS_SUCCESS_5       
     , SESS_MAX_USER_WORD   
     , SESS_CURR_IMG_NR     
     , SESS_CURR_WORD_NR    
     , SESS_LAST_WORD_NR_1  
     , SESS_LAST_WORD_NR_2  
     , SESS_INSERT_TIMESTAMP
     , SESS_LUPD_TIMESTAMP
     , SESS_LUPD_COUNTER
from   WF_SESSION
order by SESS_LUPD_TIMESTAMP
;
