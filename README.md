sqbl-schema
===========

SQBL - The Simple ( or Structured ) Questionnaire Building Language 
  www.sqbl.org

The SQBL Schema is free software distributed within the public domain.
You are free to download, remix, change and modify these schemas to your hearts content. 

SQBL - The Simple (or Structured) Questionnaire Building Language (pronounced Squabble) is a lightweight XML format for the description of questionnaires, surveys and similar related data collection methods. SQBL is designed to capture all of the logical and conceptual information around when one person asks another information to gather data.


Directory structure:

    \ schemas  -- The SQBL schema files and associated XML files
    \ tests    -- Example SQBL documents valid against the current schema
    \ util     -- Various utility files
       \ DDI   -- XSLTs for the DDI XML format
          \ Tests  -- Test files for checking the DDI XSLTs
             \ xxx.input.ddi.xml -- All test input files end with .input.ddi.xml
             \ xxx.output.sqbl   -- All test output files end with .output.sqbl
