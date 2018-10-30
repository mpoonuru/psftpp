--Scripts to identify changes for Upgrade
-- Application Engine
SELECT ITEM.OBJECTVALUE1 AS "Application Engine", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSAEAPPLDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 33
AND ITEM.OBJECTVALUE1 = DEFN.AE_APPLID
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- Application Engine Section
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) AS "Application Engine Section", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSAESECTDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 34
AND ITEM.OBJECTVALUE1 = DEFN.AE_APPLID AND ITEM.OBJECTVALUE2 = DEFN.AE_SECTION
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Application Package
Select RTRIM(ITEM.OBJECTVALUE2) || RTRIM(ITEM.OBJECTVALUE3) || RTRIM(ITEM.OBJECTVALUE1) AS "Application Package", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPACKAGEDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 57
AND ITEM.OBJECTVALUE1 = DEFN.PACKAGEID AND ITEM.OBJECTVALUE2 = DEFN.PACKAGEROOT
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE2, ITEM.OBJECTVALUE1;

-- Component Interfaces
Select RTRIM(ITEM.OBJECTVALUE1) AS "Component Interfaces", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSBCDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 32
AND ITEM.OBJECTVALUE1 = DEFN.BCNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Components
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) AS "Components", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPNLGRPDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 7
AND ITEM.OBJECTVALUE1 = DEFN.PNLGRPNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Fields
SELECT ITEM.OBJECTVALUE1 AS "Fields", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSDBFIELD DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 2
AND ITEM.OBJECTVALUE1 = DEFN.FIELDNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- Menus
SELECT ITEM.OBJECTVALUE1 AS "Menus", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSMENUDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 6
AND ITEM.OBJECTVALUE1 = DEFN.MENUNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- Message Catalog Entries
Select RTRIM(ITEM.OBJECTVALUE1) || ', ' || RTRIM(ITEM.OBJECTVALUE2) AS "Message Catalog Entries", DEFN.LAST_UPDATE_DTTM
FROM PSPROJECTITEM ITEM, PSMSGCATDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 25
AND ITEM.OBJECTVALUE1 = DEFN.MESSAGE_SET_NBR AND ITEM.OBJECTVALUE2 = DEFN.MESSAGE_NBR
AND DEFN.LAST_UPDATE_DTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Message Channels
SELECT ITEM.OBJECTVALUE1 AS "Message Channels", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSCHNLDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 36
AND ITEM.OBJECTVALUE1 = DEFN.CHNLNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- Messages
SELECT ITEM.OBJECTVALUE1 AS "Messages", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSMSGDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 37
AND ITEM.OBJECTVALUE1 = DEFN.MSGNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- Pages
Select RTRIM(ITEM.OBJECTVALUE1) AS "Pages", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPNLDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 5
AND ITEM.OBJECTVALUE1 = DEFN.PNLNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- PeopleCode goes here

-- Application Engine PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(SUBSTR(ITEM.OBJECTVALUE2, 1, 8)) || '.' || RTRIM(SUBSTR(ITEM.OBJECTVALUE2, 9, 3)) || '.' || RTRIM(ITEM.OBJECTVALUE3) AS "Application Engine PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 43
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND SUBSTR(ITEM.OBJECTVALUE2, 1, 8) = DEFN.OBJECTVALUE2 AND SUBSTR(ITEM.OBJECTVALUE2, 9, 3) = DEFN.OBJECTVALUE3 AND ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE6
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Application Package PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) || '.' || RTRIM(ITEM.OBJECTVALUE3) AS "Application Package PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 58
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2 AND (ITEM.OBJECTID3 <> 107 OR ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE3) AND (ITEM.OBJECTID4 <> 107 OR ITEM.OBJECTVALUE4 = DEFN.OBJECTVALUE4)
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2, ITEM.OBJECTVALUE3;

-- Component Interface PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) AS "Component Interface PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 42
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Component PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) || '.' || RTRIM(ITEM.OBJECTVALUE3) AS "Component PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 46
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2 AND ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE3
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Component Record Field PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) || '.' || RTRIM(ITEM.OBJECTVALUE3) || '.' || RTRIM(SUBSTR(ITEM.OBJECTVALUE4, 1, 18)) || '.' || RTRIM(SUBSTR(ITEM.OBJECTVALUE4, 19, 12)) AS "Comp Record Field PeopleCode"
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 48
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2 AND ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE3 AND SUBSTR(ITEM.OBJECTVALUE4, 1, 18) = DEFN.OBJECTVALUE4 AND SUBSTR(ITEM.OBJECTVALUE4, 19, 12) = DEFN.OBJECTVALUE5
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2, ITEM.OBJECTVALUE3;

-- Component Record PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) || '.' || RTRIM(ITEM.OBJECTVALUE3) || '.' || RTRIM(ITEM.OBJECTVALUE4) AS "Component Record PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 47
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2 AND ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE3 AND ITEM.OBJECTVALUE4 = DEFN.OBJECTVALUE4
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2, ITEM.OBJECTVALUE3, ITEM.OBJECTVALUE4;

-- Page PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) AS "Page PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 44
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Record PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) || '.' || RTRIM(ITEM.OBJECTVALUE3) AS "Record PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 8
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2 AND ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE3
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2, ITEM.OBJECTVALUE3;

-- Message PeopleCode
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE2) || '.' || RTRIM(ITEM.OBJECTVALUE3) AS "Message PeopleCode", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPCMPROG DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 40
AND ITEM.OBJECTVALUE1 = DEFN.OBJECTVALUE1 AND ITEM.OBJECTVALUE2 = DEFN.OBJECTVALUE2 AND ITEM.OBJECTVALUE3 = DEFN.OBJECTVALUE3
AND DEFN.PROGSEQ = 0
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2, ITEM.OBJECTVALUE3;

-- Portal Registry Structure
Select RTRIM(ITEM.OBJECTVALUE1) || '.' || RTRIM(ITEM.OBJECTVALUE3) AS "Portal Registry Structure", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSPRSMDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTVALUE1 = DEFN.PORTAL_NAME
AND ITEM.OBJECTVALUE3 = DEFN.PORTAL_OBJNAME
AND ITEM.OBJECTTYPE = 55
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY OBJECTVALUE1, OBJECTVALUE3;

-- Permission Lists
SELECT RTRIM(ITEM.OBJECTVALUE1) AS "Permission Lists", DEFN.CLASSDEFNDESC, DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSCLASSDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 53
AND ITEM.OBJECTVALUE1 = DEFN.CLASSID
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;


-- Records
Select RTRIM(ITEM.OBJECTVALUE1) AS "Records", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSRECDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 0
AND ITEM.OBJECTVALUE1 = DEFN.RECNAME
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- SQL (Non Application Engine)
Select RTRIM(ITEM.OBJECTVALUE1) AS "SQL (Non Application Engine)", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSSQLDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 30 and ITEM.OBJECTVALUE2 IN (0,2)
AND ITEM.OBJECTVALUE1 = DEFN.SQLID
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- SQL (Applicaiton Engine)
Select RTRIM(SUBSTR(ITEM.OBJECTVALUE1, 1, 12)) || '.' || RTRIM(SUBSTR(ITEM.OBJECTVALUE1, 13, 8)) || '.' || RTRIM(SUBSTR(ITEM.OBJECTVALUE1, 21, 8)) AS "SQL (Application Engine)", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSSQLDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 30 and ITEM.OBJECTVALUE2 = 1
AND ITEM.OBJECTVALUE1 = DEFN.SQLID
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1;

-- Translate Values
Select RTRIM(ITEM.OBJECTVALUE1) || ':' || RTRIM(ITEM.OBJECTVALUE2) AS "Translate Values", DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSXLATITEM DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 4
AND ITEM.OBJECTVALUE1 = DEFN.FIELDNAME AND ITEM.OBJECTVALUE2 = DEFN.FIELDVALUE
AND DEFN.LASTUPDDTTM > TO_DATE('2000-01-01', 'YYYY-MM-DD')
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;

-- Process Definitions
SELECT RTRIM(ITEM.OBJECTVALUE1) || ':' || RTRIM(ITEM.OBJECTVALUE2) AS "Process Definitions", DEFN.DESCR, DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PS_PRCSDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 20
AND ITEM.OBJECTVALUE2 = DEFN.PRCSNAME
ORDER BY ITEM.OBJECTVALUE1, ITEM.OBJECTVALUE2;


-- Query
Select RTRIM(ITEM.OBJECTVALUE1) AS "Query", DEFN.DESCR, DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSQRYDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 10
AND ITEM.OBJECTVALUE1 = DEFN.QRYNAME
ORDER BY RTRIM(ITEM.OBJECTVALUE1);

-- Style Sheet
Select RTRIM(ITEM.OBJECTVALUE1) AS "Style Sheet", DEFN.DESCR, DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSSTYLSHEETDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 50
AND ITEM.OBJECTVALUE1 = DEFN.STYLESHEETNAME
ORDER BY ITEM.OBJECTVALUE1;


-- Style Sheet
Select RTRIM(ITEM.OBJECTVALUE1) AS "Style Sheet", DEFN.DESCR, DEFN.LASTUPDOPRID, DEFN.LASTUPDDTTM
FROM PSPROJECTITEM ITEM, PSSTYLSHEETDEFN DEFN
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 50
AND ITEM.OBJECTVALUE1 = DEFN.STYLESHEETNAME
ORDER BY ITEM.OBJECTVALUE1;


-- HTML Definitions (What's the table?)
Select RTRIM(ITEM.OBJECTVALUE1) AS "HTML Definitions"
FROM PSPROJECTITEM ITEM
WHERE ITEM.PROJECTNAME = ('ZAKTST')
AND ITEM.OBJECTTYPE = 51
ORDER BY ITEM.OBJECTVALUE1;

-- Objects in Project not Listed
SELECT * FROM PSPROJECTITEM WHERE PROJECTNAME = 'ZAKTST'
AND OBJECTTYPE NOT IN (33, 34, 57, 32, 7, 2, 6, 25, 36, 37, 5, 43, 58, 42, 46, 48, 47, 44, 8, 40, 55, 0, 30, 4, 20, 10, 50, 51, 53);
