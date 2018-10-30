--V4
--UNION ALL both Processes and PSJobs
SELECT N.NAVIGATION, ' ' AS PRCSJOBNAME, PRCS.PRCSNAME, PRCS.PRCSTYPE, PRCS.DESCR, PORTAL_DESC
FROM (
SELECT SYS_CONNECT_BY_PATH(A.PORTAL_LABEL ,'->') NAVIGATION, '/EMPLOYEE/ERP/C/' || PORTAL_URI_SEG1 || '.' || PORTAL_URI_SEG2 || '.' || PORTAL_URI_SEG3 URL, 
            PORTAL_URI_SEG2 AS PORTAL_PNLGRPNAME, PORTAL_DESC , PORTAL_URLTEXT
FROM (
SELECT DISTINCT A.PORTAL_NAME, A.PORTAL_LABEL, A.PORTAL_OBJNAME, A.PORTAL_PRNTOBJNAME, A.DESCR254 AS PORTAL_DESC, A.PORTAL_URI_SEG1, A.PORTAL_URI_SEG2, 
            A.PORTAL_URI_SEG3, A.PORTAL_REFTYPE, PORTAL_URLTEXT
FROM PSPRSMDEFN A WHERE PORTAL_NAME = 'EMPLOYEE' AND PORTAL_OBJNAME <> PORTAL_PRNTOBJNAME) 
A START WITH A.PORTAL_PRNTOBJNAME = 'PORTAL_ROOT_OBJECT' 
CONNECT BY PRIOR A.PORTAL_OBJNAME = A.PORTAL_PRNTOBJNAME) N, PS_PRCSDEFNPNL PR, PS_PRCSDEFN PRCS 
WHERE PORTAL_PNLGRPNAME = PR.PNLGRPNAME
    AND PRCS.PRCSNAME = PR.PRCSNAME
    AND PRCS.PRCSTYPE = PR.PRCSTYPE
    --AND PRCS.PRCSNAME IN ('APY2100-', 'APY2101-', 'PVY2000-', 'PORC700', 'APS8001-', 'APS8001J')
    --AND UPPER(NAVIGATION) LIKE UPPER('%PeopleTools%')
    AND UPPER(N.NAVIGATION) NOT LIKE '%PORTAL%OBJECTS%'

UNION ALL

SELECT N.NAVIGATION, PR.PRCSJOBNAME, PRCS.PRCSNAME, PRCS.PRCSTYPE, PRCS.DESCR, PORTAL_DESC
FROM (
SELECT SYS_CONNECT_BY_PATH(A.PORTAL_LABEL ,'->') NAVIGATION, '/EMPLOYEE/ERP/C/' || PORTAL_URI_SEG1 || '.' || PORTAL_URI_SEG2 || '.' || PORTAL_URI_SEG3 URL, 
            PORTAL_URI_SEG2 AS PORTAL_PNLGRPNAME, PORTAL_DESC , PORTAL_URLTEXT
FROM (
SELECT DISTINCT A.PORTAL_NAME, A.PORTAL_LABEL, A.PORTAL_OBJNAME, A.PORTAL_PRNTOBJNAME, A.DESCR254 AS PORTAL_DESC, A.PORTAL_URI_SEG1, A.PORTAL_URI_SEG2, 
            A.PORTAL_URI_SEG3, A.PORTAL_REFTYPE, PORTAL_URLTEXT
FROM PSPRSMDEFN A WHERE PORTAL_NAME = 'EMPLOYEE' AND PORTAL_OBJNAME <> PORTAL_PRNTOBJNAME) A 
START WITH A.PORTAL_PRNTOBJNAME = 'PORTAL_ROOT_OBJECT' CONNECT BY PRIOR A.PORTAL_OBJNAME = A.PORTAL_PRNTOBJNAME) N, 
PS_PRCSJOBPNL PR, PS_PRCSDEFN PRCS, PS_PRCSJOBITEM PRJ
WHERE PORTAL_PNLGRPNAME = PR.PNLGRPNAME    
    AND PR.PRCSJOBNAME = PRJ.PRCSJOBNAME
    AND PRCS.PRCSNAME = PRJ.PRCSNAME
    AND PRCS.PRCSTYPE = PRJ.PRCSTYPE    
    --AND PRCS.PRCSNAME IN ('APY2100-', 'APY2101-', 'PVY2000-', 'PORC700', 'APS8001-', 'APS8001J')
    --AND UPPER(NAVIGATION) LIKE UPPER('%PeopleTools%')
    AND UPPER(N.NAVIGATION) NOT LIKE '%PORTAL%OBJECTS%';