CREATE OR REPLACE TABLE cortex_search_tutorial_db.public.raw_text AS
SELECT
    RELATIVE_PATH,
    TO_VARCHAR (
        SNOWFLAKE.CORTEX.PARSE_DOCUMENT (
            '@cortex_search_tutorial_db.public.fomc',
            RELATIVE_PATH,
            {'mode': 'LAYOUT'} ):content
        ) AS EXTRACTED_LAYOUT
FROM
    DIRECTORY('@cortex_search_tutorial_db.public.fomc')
WHERE
    RELATIVE_PATH LIKE '%.pdf';

CREATE OR REPLACE TABLE cortex_search_tutorial_db.public.doc_chunks AS
SELECT
    relative_path,
    BUILD_SCOPED_FILE_URL(@cortex_search_tutorial_db.public.fomc, relative_path) AS file_url,
    CONCAT(relative_path, ': ', c.value::TEXT) AS chunk,
    'English' AS language
FROM
    cortex_search_tutorial_db.public.raw_text,
    LATERAL FLATTEN(SNOWFLAKE.CORTEX.SPLIT_TEXT_RECURSIVE_CHARACTER(
        EXTRACTED_LAYOUT,
        'markdown',
        2000, -- chunks of 2000 characters
        300 -- 300 character overlap
    )) c;

CREATE OR REPLACE CORTEX SEARCH SERVICE cortex_search_tutorial_db.public.fomc_meeting
    ON chunk
    ATTRIBUTES language
    WAREHOUSE = cortex_search_tutorial_wh
    TARGET_LAG = '1 hour'
    AS (
    SELECT
        chunk,
        relative_path,
        file_url,
        language
    FROM cortex_search_tutorial_db.public.doc_chunks
    );
