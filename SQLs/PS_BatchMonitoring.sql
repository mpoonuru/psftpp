--Find Inactive/Completed UNU Schedule JobSets
SELECT * FROM PS_SCHDLDEFN WHERE (SCHEDULENAME LIKE 'UNU%' OR OPRID = 'prakash.prashant') AND SCHEDULESTATUS <> 1;
--UNU Batch Monitoring
SELECT B.RUNSTATUS, (SELECT C.XLATLONGNAME FROM PSXLATITEM C WHERE C.FIELDNAME = 'RUNSTATUS' AND C.FIELDVALUE = B.RUNSTATUS)  RUNDESCR,
            DISTSTATUS,
            (SELECT D.XLATLONGNAME FROM PSXLATITEM D WHERE D.FIELDNAME = 'DISTSTATUS' AND D.FIELDVALUE = B.DISTSTATUS) DISTDESCR, 
            COUNT(1) 
FROM PSPRCSRQST B
WHERE (B.OPRID = 'prakash.prashant' or (B.PRCSJOBNAME LIKE 'UNU%' OR B.MAINJOBNAME LIKE 'UNU%'))
--   (B.PRCSJOBNAME LIKE 'UNU%' OR B.MAINJOBNAME LIKE 'UNU%')
GROUP BY B.RUNSTATUS, B.DISTSTATUS;
--All UNU Jobs
SELECT PRCSNAME, PRCSJOBNAME, MAINJOBNAME, RUNSTATUS,
        TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm ,
        TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm ,
        TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min,
        CAST(ENDDTTM AS DATE) - CAST(BEGINDTTM AS DATE) as diff,
        CAST(ENDDTTM AS DATE) - CAST(BEGINDTTM AS DATE) as diff,
        case when CAST(ENDDTTM AS DATE) - CAST(BEGINDTTM AS DATE) > 120/(24*60*60) then 1
                    else 0
        end as longer_than_threshold,
        case when CAST(ENDDTTM AS DATE) - CAST(BEGINDTTM AS DATE) > 138/(24*60*60) then 1
                    else 0
        end as over_thresholdPlus15Percent
FROM PSPRCSRQST
WHERE (OPRID = 'prakash.prashant' or (PRCSJOBNAME LIKE 'UNU%' OR MAINJOBNAME LIKE 'UNU%'))
     --AND TO_CHAR(rundttm,'YYYY-MM') = TO_CHAR(TRUNC(TRUNC(SYSDATE,'MM')-1,'MM'),'YYYY-MM')
	  AND TO_CHAR(rundttm,'YYYY-MM-DD') = TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
   --AND RUNSTATUS = 9
ORDER BY PRCSINSTANCE DESC;
--PS OOB SQL View for tracking PSJobs
SELECT MAINJOBINSTANCE, PRCSJOBNAME, RUNCNTLID, RUNDTTM, RUNSTATUS 
FROM PSPRCSRQST 
WHERE PRCSTYPE='PSJob' 
    AND GENPRCSTYPE = '0' 
    AND PRCSJOBSEQ = 0 
    AND RUNSTATUS <> '2'
    AND (PRCSJOBNAME LIKE '%UNU%' OR OPRID = 'prakash.prashant')
    AND TO_CHAR(((RUNDTTM ) + (0)),'YYYY-MM-DD') >= TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
    AND TO_CHAR(((RUNDTTM ) + (-1)),'YYYY-MM-DD') <= TO_CHAR(SYSDATE, 'YYYY-MM-DD')
ORDER BY 4 DESC;
--Find Processes/PSJobs triggered by UNU Atlas IDs as of today
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE, RUNSTATUS, 
            (SELECT XLATLONGNAME FROM PSXLATITEM C WHERE  C.FIELDNAME = 'RUNSTATUS' AND C.FIELDVALUE = PSPRCSRQST.RUNSTATUS)  RUNDESCR, 
            TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') AS BEGINTM, 
            TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') AS ENDTM, TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') AS HR_MIN
FROM PSPRCSRQST
WHERE TO_CHAR(RUNDTTM,'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD')
           --TO_CHAR(RUNDTTM,'YYYY-MM-DD') BETWEEN TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD') AND TO_CHAR(SYSDATE, 'YYYY-MM-DD')
           --TO_CHAR(RUNDTTM,'YYYY-MM-DD') = TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
    AND (OPRID IN (SELECT DISTINCT B.OPRID FROM PSUSEREMAIL A, PSOPRDEFN B WHERE B.OPRID = PSPRCSRQST.OPRID AND A.OPRID = B.OPRID AND A.EMAILID LIKE '%unu.edu')
    AND OPRID <> 'prakash.prashant')
ORDER BY PRCSINSTANCE DESC;
--Check UNU Jobs which have been Cancelled/Not Successful/Blocked/Restart/Hold/Error
SELECT PRCSNAME, PRCSJOBNAME, MAINJOBNAME, RUNSTATUS, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
        TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm ,
        TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm ,
        TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min        
FROM PSPRCSRQST
WHERE (OPRID = 'prakash.prashant' or (PRCSJOBNAME LIKE 'UNU%' OR MAINJOBNAME LIKE 'UNU%'))           
      AND RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
ORDER BY PRCSINSTANCE DESC;
--Check NEXTSTARTDTTM for UNU Schedule JobSets
SELECT I.SCHEDULENAME, I.JOBNAMESRC, S.TIMEZONE, I.NEXTSTARTDTTM, I.RECURDTTM, I.CURRENTJOBINSTANCE, S.DESCR, S.OPRID, 
       S.SCHEDULESTATUS, S.RUN_CNTL_ID, S.STARTDATETIME, S.RECURNAME
FROM PS_SCHDLDEFNINFO I, PS_SCHDLDEFN S
WHERE I.SCHEDULENAME (+) = S.SCHEDULENAME
    AND I.JOBNAMESRC (+) = S.JOBNAMESRC
    AND (S.SCHEDULENAME LIKE 'UNU%' OR S.OPRID = 'prakash.prashant')
    --AND (TO_CHAR(I.NEXTSTARTDTTM, 'YYYY-MM-DD') <= TO_CHAR(sysdate, 'YYYY-MM-DD') OR TO_CHAR(I.NEXTSTARTDTTM, 'YYYY-MM-DD') IS NULL)
ORDER BY S.SCHEDULESTATUS DESC, I.SCHEDULENAME, I.NEXTSTARTDTTM DESC;
--Summary of requested processes by process status
SELECT RQST.RUNSTATUS, RQST.PRCSTYPE, (SELECT XLAT.XLATLONGNAME FROM PSXLATITEM XLAT WHERE XLAT.EFFDT = (SELECT MAX(XLAT_ED.EFFDT) FROM PSXLATITEM XLAT_ED WHERE XLAT_ED.FIELDNAME = XLAT.FIELDNAME AND XLAT_ED.FIELDVALUE = XLAT.FIELDVALUE) 
                                                                                                                                                    AND XLAT.FIELDNAME = 'RUNSTATUS' 
                                                                                                                                                    AND XLAT.FIELDVALUE = RQST.RUNSTATUS) AS RUNSTATUS_XLAT,
          COUNT(RQST.PRCSINSTANCE) AS TOTAL_PROCESSES, MIN(RUNDTTM) AS FIRST_OCCURRED, MAX(RUNDTTM) AS LAST_OCCURRED
FROM PSPRCSRQST RQST
GROUP BY RQST.RUNSTATUS, RQST.PRCSTYPE
ORDER BY FIRST_OCCURRED DESC, RQST.PRCSTYPE, RUNSTATUS_XLAT;
--Find out Queued Processes which are supposed to run after today
SELECT OPRID, PRCSINSTANCE, RUNSTATUS, PRCSTYPE, PRCSNAME, SERVERNAMERQST, RUNDTTM, RECURNAME, RQSTDTTM, LASTUPDDTTM, RUNCNTLID, 
       JOBINSTANCE, MAINJOBINSTANCE, PRCSJOBSEQ, PRCSJOBNAME, PRCSITEMLEVEL, MAINJOBNAME, MAINJOBSEQ 
FROM PSPRCSRQST 
WHERE (RUNSTATUS = 5 OR RUNSTATUS <> 9) 
     AND TO_CHAR(RUNDTTM, 'YYYY-MM-DD') > TO_CHAR(SYSDATE, 'YYYY-MM-DD')
ORDER BY RUNDTTM DESC;
--Find out the Frequency of Job Runs by my ID
--V2
SELECT Q.OPRID, Q.PRCSNAME, Q.PRCSJOBNAME, Q.MAINJOBNAME, Q.RUNSTATUS,
            (SELECT XLAT.XLATLONGNAME FROM PSXLATITEM XLAT WHERE XLAT.EFFDT = (SELECT MAX(XLAT_ED.EFFDT) FROM PSXLATITEM XLAT_ED WHERE XLAT_ED.FIELDNAME = XLAT.FIELDNAME 
                                                                                                                                   AND XLAT_ED.FIELDVALUE = XLAT.FIELDVALUE) 
                                                                                                    AND XLAT.FIELDNAME = 'RUNSTATUS' 
                                                                                                    AND XLAT.FIELDVALUE = Q.RUNSTATUS) AS RUNSTATUS_XLAT, 
            COUNT(Q.PRCSINSTANCE) AS TOTAL_RUNS, MIN(Q.RUNDTTM) AS FIRST_OCCURRED, MAX(Q.RUNDTTM) AS LAST_OCCURRED, ROUND((24/COUNT(Q.PRCSINSTANCE)), 3) AS EVERY_XX_HRS
FROM PSPRCSRQST Q
WHERE (Q.OPRID = 'prakash.prashant' or (Q.PRCSJOBNAME LIKE 'UNU%' OR Q.MAINJOBNAME LIKE 'UNU%'))
           AND TO_CHAR(Q.RUNDTTM,'YYYY-MM-DD') = TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
           AND Q.PRCSJOBSEQ = 0 --comment this line if you want to see Processes as well
GROUP BY Q.OPRID, Q.PRCSNAME, Q.PRCSJOBNAME, Q.MAINJOBNAME, Q.RUNSTATUS
ORDER BY FIRST_OCCURRED, Q.MAINJOBNAME, Q.PRCSJOBNAME, Q.PRCSNAME;
--Special Monitoring for UNDP custom Mass Approval and Budget Check Voucher Page which triggers the AE - UN_APPBCHK
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, RUNSTATUS, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
       TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm ,
       TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm ,
       TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min        
FROM PSPRCSRQST
WHERE PRCSNAME = 'UN_APPBCHK'           
      AND RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
ORDER BY PRCSINSTANCE DESC;
--Special Monitoring for UNDP custom Paycycle process UN_F2025
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, RUNSTATUS, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
       TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm ,
       TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm ,
       TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min        
FROM PSPRCSRQST
WHERE PRCSNAME = 'UN_F2025'
      AND RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
ORDER BY PRCSINSTANCE DESC;
--Special Monitoring for UNDP custom processes UN_F2025
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, RUNSTATUS, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
       TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm ,
       TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm ,
       TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min        
FROM PSPRCSRQST
WHERE PRCSNAME IN ('UN_POKK_AE', 'UN_PO_CURREX')
      --AND RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
ORDER BY PRCSINSTANCE DESC;
--Monitor %RECV% Jobs (triggered by UNU user(s)) which have not run successfully
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
            RUNSTATUS, (SELECT C.XLATLONGNAME FROM PSXLATITEM C WHERE C.FIELDNAME = 'RUNSTATUS' AND C.FIELDVALUE = PSPRCSRQST.RUNSTATUS)  RUNDESCR, 
            TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm , 
            TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm , TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min
FROM PSPRCSRQST
WHERE (PRCSJOBNAME LIKE '%RECV%' OR MAINJOBNAME LIKE '%RECV%')
     --AND TO_CHAR(rundttm,'YYYY-MM') = TO_CHAR(TRUNC(TRUNC(SYSDATE,'MM')-1,'MM'),'YYYY-MM')
     --AND TO_CHAR(rundttm,'YYYY-MM-DD') = TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
     AND RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
    AND OPRID IN (SELECT DISTINCT B.OPRID FROM PSUSEREMAIL A, PSOPRDEFN B WHERE B.OPRID = PSPRCSRQST.OPRID AND A.OPRID = B.OPRID AND A.EMAILID LIKE '%unu.edu' AND B.ACCTLOCK = 0)
ORDER BY PRCSINSTANCE DESC;
--Monitor any Process/PSJob (triggered by UNU user(s)) which have not run successfully
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
            RUNSTATUS, (SELECT C.XLATLONGNAME FROM PSXLATITEM C WHERE C.FIELDNAME = 'RUNSTATUS' AND C.FIELDVALUE = PSPRCSRQST.RUNSTATUS)  RUNDESCR, 
            TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm , 
            TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm , TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min
FROM PSPRCSRQST
WHERE --(PRCSJOBNAME LIKE '%RECV%' OR MAINJOBNAME LIKE '%RECV%')
     --AND TO_CHAR(rundttm,'YYYY-MM') = TO_CHAR(TRUNC(TRUNC(SYSDATE,'MM')-1,'MM'),'YYYY-MM')
     --AND TO_CHAR(rundttm,'YYYY-MM-DD') = TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
     RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
     AND OPRID IN (SELECT DISTINCT B.OPRID FROM PSUSEREMAIL A, PSOPRDEFN B WHERE B.OPRID = PSPRCSRQST.OPRID AND A.OPRID = B.OPRID AND A.EMAILID LIKE '%unu.edu' AND B.ACCTLOCK = 0)
ORDER BY PRCSINSTANCE DESC;
--Monitor PSCSYSPURGE
SELECT * FROM PSPRCSRQST WHERE PRCSNAME = 'PRCSYSPURGE' ORDER BY RQSTDTTM;
--Identify Master Scheduler
SELECT A.SERVERNAME, X1.XLATLONGNAME AS SERVERACTIVITYTYPE, A.SERVERSTATE, TO_CHAR(A.LASTUPDDTTM,'DD-MM-YYYY HH:MI:SS') LAST_UPDATE_TIME 
FROM PS_SERVERACTVTY A, PSXLATITEM X1 
WHERE X1.FIELDNAME = 'SERVERACTIVITYTYPE'
    AND X1.FIELDVALUE = A.SERVERACTIVITYTYPE
    AND A.SERVERACTIVITYTYPE = '1'
    AND A.SERVERSTATE = 2
    AND (ROUND((CAST((SYSTIMESTAMP) AS DATE) - CAST((A.LASTUPDDTTM) AS DATE)) * 1440, 0) < 5)
ORDER BY 1;
--Monitor Process Scheduler
SELECT S.SRVRHOSTNAME, S.SERVERNAME, B.DESCR, X.XLATSHORTNAME, X.FIELDVALUE,
            NVL((SELECT SUM(ITEMCOUNT) FROM PS_PMN_PRCSACTV_VW PR WHERE PR.SERVERNAME = S.SERVERNAME), 0) AS ITEMCOUNT,
            cast(S.MAXCPU as varchar2(3))||'%' "CPU (%)",
            cast(S.MINMEM as varchar2(3))||'%' "Memory (%)",
            cast(S.PRCSDISKSPACE as varchar2(15))||' MB' PRCS_DISK_SPACE,            
            TO_CHAR(S.BEGINDTTM,'DD-MM-YYYY HH:MI:SS') BEGIN_DATE_TIME,
            TO_CHAR(S.LASTUPDDTTM,'DD-MM-YYYY HH:MI:SS') LAST_UPDATE_TIME
FROM PSSERVERSTAT S, PS_SERVERDEFN B, PSXLATITEM X
WHERE S.SERVERNAME = B.SERVERNAME
    AND X.FIELDNAME = 'SERVERSTATUS'
    AND X.FIELDVALUE = S.SERVERSTATUS
ORDER BY 1;
--Application Engine Processes Are Not Scheduled and Stuck in Queued
SELECT 'RETRYCOUNT_0', PRCSNAME, PRCSINSTANCE, OPRID, SERVERASSIGN, RQSTDTTM, COUNT(1) 
FROM PSPRCSQUE 
WHERE RETRYCOUNT = 0 
     AND RUNSTATUS = '3'
GROUP BY PRCSNAME, SERVERASSIGN, PRCSINSTANCE, OPRID, RQSTDTTM
ORDER BY PRCSNAME, SERVERASSIGN, PRCSINSTANCE, OPRID, RQSTDTTM;
--Temp Table Abends
--Load Abends
SELECT DISTINCT PROCESS_INSTANCE, OPRID, RUN_CNTL_ID, AE_APPLID, RUN_DTTM 
FROM PS_AETEMPTBLMGR 
WHERE PROCESS_INSTANCE NOT IN (SELECT PRCSINSTANCE FROM PSPRCSRQST) 
    AND PROCESS_INSTANCE NOT IN (SELECT PROCESS_INSTANCE FROM PS_AERUNCONTROL)
UNION 
SELECT DISTINCT PROCESS_INSTANCE, OPRID, RUN_CNTL_ID, AE_APPLID, RUN_DTTM 
FROM PS_AERUNCONTROL 
WHERE PROCESS_INSTANCE NOT IN (SELECT PRCSINSTANCE FROM PSPRCSRQST) 
ORDER BY PROCESS_INSTANCE DESC;
--Monitor runs of AE which have not ended Successfully
SELECT 'AE_TEMPTBL', AE.PROCESS_INSTANCE, AE.CURTEMPINSTANCE, AE.OPRID, AE.RUN_CNTL_ID, AE.AE_APPLID, PRCS.RUNDTTM, 
       AE.AE_DISABLE_RESTART, AE.AE_DEDICATED, AE.AE_TRUNCATED,
       PRCS.RUNSTATUS, LISTAGG(AE.RECNAME, '|') WITHIN GROUP (ORDER BY AE.RUN_DTTM) RECNAME
FROM PS_AETEMPTBLMGR AE, PSPRCSRQST PRCS
WHERE PRCS.PRCSINSTANCE = AE.PROCESS_INSTANCE
  AND PRCS.RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
GROUP BY AE.PROCESS_INSTANCE, AE.CURTEMPINSTANCE, AE.OPRID, AE.RUN_CNTL_ID, AE.AE_APPLID, PRCS.RUNDTTM,
         AE.AE_DISABLE_RESTART, AE.AE_DEDICATED, AE.AE_TRUNCATED, PRCS.RUNSTATUS
ORDER BY AE.PROCESS_INSTANCE DESC, AE.CURTEMPINSTANCE;
--Exclusive AE Monitoring
SELECT 'AE_MON', PL.PROCESS_INSTANCE, PL.MESSAGE_SEQ, PR.PRCSNAME, PR.PRCSJOBNAME, PR.MAINJOBNAME, PR.RUNSTATUS, ML.DTTM_STAMP_SEC, MSG.MESSAGE_TEXT, MSG.MESSAGE_SET_NBR, MSG.MESSAGE_NBR,
       RTRIM(XMLAGG(XMLELEMENT(E, PL.MESSAGE_PARM, '|').EXTRACT('//text()') ORDER BY PL.PARM_SEQ).GETCLOBVAL(),',') AS MESSAGE_PARM
FROM PS_MESSAGE_LOGPARM PL, PS_MESSAGE_LOG ML, PSPRCSRQST PR, PSMSGCATDEFN MSG
WHERE PL.PROCESS_INSTANCE = ML.PROCESS_INSTANCE
    AND PL.MESSAGE_SEQ = ML.MESSAGE_SEQ
    AND PL.PROCESS_INSTANCE = PR.PRCSINSTANCE
    AND ML.MESSAGE_SET_NBR = MSG.MESSAGE_SET_NBR
    AND ML.MESSAGE_NBR = MSG.MESSAGE_NBR    
    AND PL.PROCESS_INSTANCE IN (SELECT DISTINCT AE.PROCESS_INSTANCE FROM PS_AETEMPTBLMGR AE, PSPRCSRQST PRCS WHERE PRCS.PRCSINSTANCE = AE.PROCESS_INSTANCE AND PRCS.RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6))
    --AND PL.PROCESS_INSTANCE = 37617612
    AND ML.MESSAGE_SET_NBR = 108
GROUP BY PL.PROCESS_INSTANCE, PL.MESSAGE_SEQ, PR.PRCSNAME, PR.PRCSJOBNAME, PR.MAINJOBNAME, PR.RUNSTATUS, ML.DTTM_STAMP_SEC, MSG.MESSAGE_TEXT, MSG.MESSAGE_SET_NBR, MSG.MESSAGE_NBR
ORDER BY PL.PROCESS_INSTANCE DESC, PL.MESSAGE_SEQ;
--Monitoring for Processes/Jobs which have not run successfully within the last 1 day from date of running
SELECT PL.PROCESS_INSTANCE, PR.OPRID, PL.MESSAGE_SEQ, PR.PRCSNAME, PR.PRCSJOBNAME, PR.MAINJOBNAME, PR.RUNSTATUS, 
       ML.DTTM_STAMP_SEC, MSG.MESSAGE_TEXT, MSG.MESSAGE_SET_NBR, MSG.MESSAGE_NBR, 
       RTRIM(XMLAGG(XMLELEMENT(E, PL.MESSAGE_PARM, '|').EXTRACT('//text()') ORDER BY PL.PARM_SEQ).GETCLOBVAL(),',') AS MESSAGE_PARM
FROM PS_MESSAGE_LOGPARM PL, PS_MESSAGE_LOG ML, PSPRCSRQST PR, PSMSGCATDEFN MSG
WHERE PL.PROCESS_INSTANCE = ML.PROCESS_INSTANCE
    AND PL.MESSAGE_SEQ = ML.MESSAGE_SEQ
    AND PL.PROCESS_INSTANCE = PR.PRCSINSTANCE
    AND ML.MESSAGE_SET_NBR = MSG.MESSAGE_SET_NBR
    AND ML.MESSAGE_NBR = MSG.MESSAGE_NBR
    AND ((ML.MESSAGE_SET_NBR = 108) --OR (ML.MESSAGE_SET_NBR = 65 AND MSG.MESSAGE_NBR = 30)
    )
    AND PR.RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2, 5, 6)
    AND TO_CHAR(((RUNDTTM ) + (0)),'YYYY-MM-DD') >= TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
    AND TO_CHAR(((RUNDTTM ) + (-1)),'YYYY-MM-DD') <= TO_CHAR(SYSDATE, 'YYYY-MM-DD')
GROUP BY PL.PROCESS_INSTANCE, PR.OPRID, PL.MESSAGE_SEQ, PR.PRCSNAME, PR.PRCSJOBNAME, PR.MAINJOBNAME, PR.RUNSTATUS, 
         ML.DTTM_STAMP_SEC, MSG.MESSAGE_TEXT, MSG.MESSAGE_SET_NBR, MSG.MESSAGE_NBR
ORDER BY PL.PROCESS_INSTANCE DESC, PL.MESSAGE_SEQ;