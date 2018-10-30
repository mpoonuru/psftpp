--UNU GL Ledger Vs Ledger KK Vs Activity Log KK
SELECT T.BUSINESS_UNIT, T.OPERATING_UNIT, T.FUND_CODE, T.DEPTID, T.PROJECT_ID, T.PRJ_DESCR, T.CHARTFIELD2, T.AFFILIATE, T.AFFILIATE_INTRA1, T.AFFILIATE_INTRA2,  
            T.ACCT_ROLLUP, T.ACCOUNT, T.ACCT_DESCR,
            SUM(T.EXP_AMT_GL) AS EXP_AMT_GL, SUM(T.EXP_AMT_KK) AS EXP_AMT_KK, SUM(T.EXP_AMT_ACT) AS EXP_AMT_ACT, 
            (SUM(T.EXP_AMT_ACT) - SUM(T.EXP_AMT_KK)) AS "Variance-ACT-KK",  (SUM(T.EXP_AMT_GL) - SUM(T.EXP_AMT_KK)) AS "Variance-GL-KK", 
            (SUM(T.EXP_AMT_GL) - SUM(T.EXP_AMT_ACT)) AS "Variance-GL-ACT",
            SUM(T.JAN_GL) AS JAN_GL, SUM(T.JAN_KK) AS JAN_KK, SUM(T.JAN_ACT) AS JAN_ACT, SUM(T.FEB_GL) AS FEB_GL, SUM(T.FEB_KK) AS FEB_KK, SUM(T.FEB_ACT) AS FEB_ACT, 
            SUM(T.MAR_GL) AS MAR_GL, SUM(T.MAR_KK) AS MAR_KK, SUM(T.MAR_ACT) AS MAR_ACT, SUM(T.APR_GL) AS APR_GL, SUM(T.APR_KK) AS APR_KK, SUM(T.APR_ACT) AS APR_ACT, 
            SUM(T.MAY_GL) AS MAY_GL, SUM(T.MAY_KK) AS MAY_KK, SUM(T.MAY_ACT) AS MAY_ACT, SUM(T.JUN_GL) AS JUN_GL, SUM(T.JUN_KK) AS JUN_KK, SUM(T.JUN_ACT) AS JUN_ACT, 
            SUM(T.JUL_GL) AS JUL_GL, SUM(T.JUL_KK) AS JUL_KK, SUM(T.JUL_ACT) AS JUL_ACT, SUM(T.AUG_GL) AS AUG_GL, SUM(T.AUG_KK) AS AUG_KK, SUM(T.AUG_ACT) AS AUG_ACT, 
            SUM(T.SEP_GL) AS SEP_GL, SUM(T.SEP_KK) AS SEP_KK, SUM(T.SEP_ACT) AS SEP_ACT, SUM(T.OCT_GL) AS OCT_GL, SUM(T.OCT_KK) AS OCT_KK, SUM(T.OCT_ACT) AS OCT_ACT, 
            SUM(T.NOV_GL) AS NOV_GL, SUM(T.NOV_KK) AS NOV_KK, SUM(T.NOV_ACT) AS NOV_ACT, SUM(T.DEC_GL) AS DEC_GL, SUM(T.DEC_KK) AS DEC_KK, SUM(T.DEC_ACT) AS DEC_ACT
FROM
(SELECT X.BUSINESS_UNIT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, C.DESCR AS DEPT_DESCR, X.PROJECT_ID, B.DESCR AS PRJ_DESCR, X.CHARTFIELD2, 
             X.AFFILIATE, X.AFFILIATE_INTRA1, X.AFFILIATE_INTRA2, 
             (SUBSTR(X.ACCOUNT,1,LENGTH(X.ACCOUNT)-2) || '00') AS ACCT_ROLLUP, X.ACCOUNT, X.DESCR AS ACCT_DESCR,
             SUM(X.EXP_AMT) AS EXP_AMT_GL, 0.00 AS EXP_AMT_KK, 0.00 AS EXP_AMT_ACT,
             SUM(X.JAN) JAN_GL, 0.00 AS JAN_KK, 0.00 AS JAN_ACT, SUM(X.FEB) FEB_GL, 0.00 AS FEB_KK, 0.00 AS FEB_ACT, 
             SUM(X.MAR) MAR_GL, 0.00 AS MAR_KK, 0.00 AS MAR_ACT, SUM(X.APR) APR_GL, 0.00 AS APR_KK, 0.00 AS APR_ACT, 
             SUM(X.MAY) MAY_GL, 0.00 AS MAY_KK, 0.00 AS MAY_ACT, SUM(X.JUN) JUN_GL, 0.00 AS JUN_KK, 0.00 AS JUN_ACT, 
             SUM(X.JUL) JUL_GL, 0.00 AS JUL_KK, 0.00 AS JUL_ACT, SUM(X.AUG) AUG_GL, 0.00 AS AUG_KK, 0.00 AS AUG_ACT, 
             SUM(X.SEP) SEP_GL, 0.00 AS SEP_KK, 0.00 AS SEP_ACT, SUM(X.OCT) OCT_GL, 0.00 AS OCT_KK, 0.00 AS OCT_ACT, 
             SUM(X.NOV) NOV_GL, 0.00 AS NOV_KK, 0.00 AS NOV_ACT, SUM(X.DEC) DEC_GL, 0.0 AS DEC_KK, 0.00 AS DEC_ACT
FROM 
(SELECT ST.BUSINESS_UNIT, ST.OPERATING_UNIT, ST.FUND_CODE, ST.DEPTID, ST.ACCOUNT, ET.DESCR, ST.PROJECT_ID, ST.CHARTFIELD2, ST.AFFILIATE, ST.AFFILIATE_INTRA1, ST.AFFILIATE_INTRA2,
             SUM(ST.POSTED_TOTAL_AMT) AS EXP_AMT   
           , CASE ST.ACCOUNTING_PERIOD WHEN 1 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS JAN
           , CASE ST.ACCOUNTING_PERIOD WHEN 2 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS FEB 
           , CASE ST.ACCOUNTING_PERIOD WHEN 3 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS MAR 
           , CASE ST.ACCOUNTING_PERIOD WHEN 4 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS APR 
           , CASE ST.ACCOUNTING_PERIOD WHEN 5 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS MAY 
           , CASE ST.ACCOUNTING_PERIOD WHEN 6 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS JUN 
           , CASE ST.ACCOUNTING_PERIOD WHEN 7 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS JUL 
           , CASE ST.ACCOUNTING_PERIOD WHEN 8 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS AUG 
           , CASE ST.ACCOUNTING_PERIOD WHEN 9 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS SEP 
           , CASE ST.ACCOUNTING_PERIOD WHEN 10 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS OCT 
           , CASE ST.ACCOUNTING_PERIOD WHEN 11 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS NOV 
           , CASE ST.ACCOUNTING_PERIOD WHEN 12 THEN SUM(ST.POSTED_TOTAL_AMT) ELSE 0 END AS DEC 
FROM  PS_LEDGER ST, PS_GL_ACCOUNT_TBL ET, PS_SET_CNTRL_REC B2
WHERE ST.BUSINESS_UNIT = 'UNUNI'
    --AND ET.SETID = 'SHARE'    
    AND B2.SETCNTRLVALUE = ST.BUSINESS_UNIT
    AND B2.RECNAME = 'GL_ACCOUNT_TBL'
    AND B2.SETID = ET.SETID
    AND ST.ACCOUNT = ET.ACCOUNT
    AND ET.EFFDT = (SELECT MAX(CJ.EFFDT) FROM PS_GL_ACCOUNT_TBL CJ WHERE CJ.SETID = ET.SETID AND CJ.ACCOUNT = ET.ACCOUNT AND CJ.EFFDT <= sysdate)      
    AND ST.LEDGER = 'USD'
    AND (ST.FISCAL_YEAR IN ('2013') AND  (ST.ACCOUNTING_PERIOD BETWEEN 1 AND 12))
    --AND ST.STATISTICS_CODE = ' ' 
    --AND ST.CURRENCY_CD = 'USD'
    --AND ET.ACCOUNT_TYPE IN ('E', 'R')
    AND ST.BASE_CURRENCY = ST.CURRENCY_CD
    --AND ST.PROJECT_ID = '00086239'
    --AND ST.DEPTID = '11901'
GROUP BY ST.BUSINESS_UNIT, ST.OPERATING_UNIT, ST.FUND_CODE, ST.DEPTID, ST.ACCOUNT, ET.DESCR, ST.PROJECT_ID, ST.CHARTFIELD2, 
               ST.AFFILIATE, ST.AFFILIATE_INTRA1, ST.AFFILIATE_INTRA2, ST.ACCOUNTING_PERIOD) X, PS_PROJECT B, PS_DEPTID_BUGL_VW C
WHERE X.BUSINESS_UNIT = B.BUSINESS_UNIT (+)
    AND X.PROJECT_ID = B.PROJECT_ID (+)
    AND C.SETID = (SELECT SETID FROM PS_SET_CNTRL_REC G WHERE G.SETCNTRLVALUE = X.BUSINESS_UNIT AND G.RECNAME = 'DEPT_TBL')
    AND X.DEPTID = C.DEPTID
    AND C.EFFDT = (SELECT MAX(C_ED.EFFDT) FROM PS_DEPTID_BUGL_VW C_ED WHERE C.SETID = C_ED.SETID AND C.DEPTID = C_ED.DEPTID AND C_ED.EFFDT <= SYSDATE)    
GROUP BY X.BUSINESS_UNIT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, C.DESCR, X.ACCOUNT, X.DESCR, X.PROJECT_ID, B.DESCR, X.CHARTFIELD2, 
               X.AFFILIATE, X.AFFILIATE_INTRA1, X.AFFILIATE_INTRA2
UNION ALL
--LEDGER_KK
SELECT X.BUSINESS_UNIT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, C.DESCR AS DEPT_DESCR, X.PROJECT_ID, B.DESCR AS PRJ_DESCR, X.CHARTFIELD2,
            X.AFFILIATE, X.AFFILIATE_INTRA1, X.AFFILIATE_INTRA2, 
            (SUBSTR(X.ACCOUNT,1,LENGTH(X.ACCOUNT)-2) || '00') AS ACCT_ROLLUP, X.ACCOUNT, X.DESCR AS ACCT_DESCR,
            0.00 AS EXP_AMT_GL, SUM(X.EXP_AMT) AS EXP_AMT_KK, 0.00 AS EXP_AMT_ACT,  
            0.00 AS JAN_GL, SUM(X.JAN) JAN_KK, 0.00 AS JAN_ACT, 0.00 AS FEB_GL, SUM(X.FEB) FEB_KK, 0.00 AS FEB_ACT, 0.00 AS MAR_GL, SUM(X.MAR) MAR_KK, 0.00 AS MAR_ACT, 
            0.00 AS APR_GL, SUM(X.APR) APR_KK, 0.00 AS APR_ACT, 0.00 AS MAY_GL, SUM(X.MAY) MAY_KK, 0.00 AS MAY_ACT, 0.00 AS JUN_GL, SUM(X.JUN) JUN_KK, 0.00 AS JUN_ACT, 
            0.00 AS JUL_GL, SUM(X.JUL) JUL_KK, 0.00 AS JUL_ACT, 0.00 AS AUG_GL, SUM(X.AUG) AUG_KK, 0.00 AS AUG_ACT, 0.00 AS SEP_GL, SUM(X.SEP) SEP_KK, 0.00 AS SEP_ACT, 
            0.00 AS OCT_GL, SUM(X.OCT) OCT_KK, 0.00 AS OCT_ACT, 0.00 AS NOV_GL, SUM(X.NOV) NOV_KK, 0.0 AS NOV_ACT, 0.00 AS DEC_GL, SUM(X.DEC) DEC_KK, 0.00 AS DEC_ACT
FROM
(SELECT A.BUSINESS_UNIT, A.OPERATING_UNIT, A.FUND_CODE, A.DEPTID, A.ACCOUNT, D.DESCR, A.PROJECT_ID, A.CHARTFIELD2, A.AFFILIATE, A.AFFILIATE_INTRA1, A.AFFILIATE_INTRA2, 
            DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) AS EXP_AMT,
            CASE A.ACCOUNTING_PERIOD WHEN 1 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS JAN
          , CASE A.ACCOUNTING_PERIOD WHEN 2 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS FEB 
          , CASE A.ACCOUNTING_PERIOD WHEN 3 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS MAR 
          , CASE A.ACCOUNTING_PERIOD WHEN 4 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS APR 
          , CASE A.ACCOUNTING_PERIOD WHEN 5 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS MAY 
          , CASE A.ACCOUNTING_PERIOD WHEN 6 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS JUN 
          , CASE A.ACCOUNTING_PERIOD WHEN 7 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS JUL 
          , CASE A.ACCOUNTING_PERIOD WHEN 8 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS AUG 
          , CASE A.ACCOUNTING_PERIOD WHEN 9 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS SEP 
          , CASE A.ACCOUNTING_PERIOD WHEN 10 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS OCT 
          , CASE A.ACCOUNTING_PERIOD WHEN 11 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS NOV 
          , CASE A.ACCOUNTING_PERIOD WHEN 12 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(POSTED_TOTAL_AMT),0) ELSE 0 END AS DEC            
FROM PS_LEDGER_KK A, PS_GL_ACCOUNT_TBL D, PS_SET_CNTRL_REC B4
WHERE A.BUSINESS_UNIT = 'UNUNI'
     AND B4.SETCNTRLVALUE = A.BUSINESS_UNIT
     AND B4.RECNAME = 'GL_ACCOUNT_TBL'
     AND B4.SETID = D.SETID
     AND A.ACCOUNT = D.ACCOUNT
     AND D.EFFDT = (SELECT MAX(CJ.EFFDT) FROM PS_GL_ACCOUNT_TBL CJ WHERE CJ.SETID = D.SETID AND CJ.ACCOUNT = D.ACCOUNT AND CJ.EFFDT <= sysdate)
     AND (A.FISCAL_YEAR IN ('2013') AND (A.ACCOUNTING_PERIOD BETWEEN 1 AND 12))
     --AND A.BUDGET_PERIOD IN ('2013')
     AND A.LEDGER LIKE 'DET_UU%'
     AND A.CURRENCY_CD = A.BASE_CURRENCY
     --AND A.PROJECT_ID = '00086239'
     --AND A.DEPTID = '11901'
     --AND A.POSTED_TOTAL_AMT <> 0
     --AND D.ACCOUNT_TYPE IN ('E', 'R')
GROUP BY A.BUSINESS_UNIT, A.OPERATING_UNIT, A.FUND_CODE, A.DEPTID, A.ACCOUNT, D.DESCR, A.PROJECT_ID, A.CHARTFIELD2, 
               A.AFFILIATE, A.AFFILIATE_INTRA1, A.AFFILIATE_INTRA2, A.ACCOUNTING_PERIOD, LEDGER) X, PS_PROJECT B, PS_DEPTID_BUGL_VW C
WHERE X.BUSINESS_UNIT = B.BUSINESS_UNIT (+)
     AND X.PROJECT_ID = B.PROJECT_ID (+)     
     AND C.SETID = (SELECT SETID FROM PS_SET_CNTRL_REC G WHERE G.SETCNTRLVALUE = X.BUSINESS_UNIT AND G.RECNAME = 'DEPT_TBL')
     AND X.DEPTID = C.DEPTID
     AND C.EFFDT = (SELECT MAX(C_ED.EFFDT) FROM PS_DEPTID_BUGL_VW C_ED WHERE C.SETID = C_ED.SETID AND C.DEPTID = C_ED.DEPTID AND C_ED.EFFDT <= SYSDATE)    
GROUP BY X.BUSINESS_UNIT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, C.DESCR, X.PROJECT_ID, B.DESCR, X.CHARTFIELD2, X.AFFILIATE, X.AFFILIATE_INTRA1, X.AFFILIATE_INTRA2, 
               X.ACCOUNT, X.DESCR
UNION ALL
--KK_ACTIVITY_LOG
SELECT X.BUSINESS_UNIT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, C.DESCR AS DEPT_DESCR, X.PROJECT_ID, B.DESCR AS PRJ_DESCR, X.CHARTFIELD2,
            X.AFFILIATE, X.AFFILIATE_INTRA1, X.AFFILIATE_INTRA2, 
            (SUBSTR(X.ACCOUNT,1,LENGTH(X.ACCOUNT)-2) || '00') AS ACCT_ROLLUP, X.ACCOUNT, X.DESCR AS ACCT_DESCR,
            0.00 AS EXP_AMT_GL, 0.00 AS EXP_AMT_KK, SUM(X.EXP_AMT) AS EXP_AMT_ACT,  
            0.00 AS JAN_GL, 0.00 AS JAN_KK, SUM(X.JAN) JAN_ACT, 0.00 AS FEB_GL, 0.00 AS FEB_KK, SUM(X.FEB) FEB_ACT, 0.00 AS MAR_GL, 0.00 AS MAR_KK, SUM(X.MAR) MAR_ACT, 
            0.00 AS APR_GL, 0.00 AS APR_KK, SUM(X.APR) APR_ACT, 0.00 AS MAY_GL, 0.00 AS MAY_KK, SUM(X.MAY) MAY_ACT, 0.00 AS JUN_GL, 0.00 AS JUN_KK, SUM(X.JUN) JUN_ACT, 
            0.00 AS JUL_GL, 0.00 AS JUL_KK, SUM(X.JUL) JUL_ACT, 0.00 AS AUG_GL, 0.00 AS AUG_KK, SUM(X.AUG) AUG_ACT, 0.00 AS SEP_GL, 0.00 AS SEP_KK, SUM(X.SEP) SEP_ACT, 
            0.00 AS OCT_GL, 0.00 AS OCT_KK, SUM(X.OCT) OCT_ACT, 0.00 AS NOV_GL, 0.0 AS NOV_KK, SUM(X.NOV) NOV_ACT, 0.00 AS DEC_GL, 0.00 AS DEC_KK, SUM(X.DEC) DEC_ACT
FROM
(SELECT A.BUSINESS_UNIT, A.OPERATING_UNIT, A.FUND_CODE, A.DEPTID, A.ACCOUNT, D.DESCR, A.PROJECT_ID, A.CHARTFIELD2,
             A.AFFILIATE, A.AFFILIATE_INTRA1, A.AFFILIATE_INTRA2, 
            DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) AS EXP_AMT,
            CASE A.ACCOUNTING_PERIOD WHEN 1 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS JAN
          , CASE A.ACCOUNTING_PERIOD WHEN 2 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS FEB 
          , CASE A.ACCOUNTING_PERIOD WHEN 3 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS MAR 
          , CASE A.ACCOUNTING_PERIOD WHEN 4 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS APR 
          , CASE A.ACCOUNTING_PERIOD WHEN 5 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS MAY 
          , CASE A.ACCOUNTING_PERIOD WHEN 6 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS JUN 
          , CASE A.ACCOUNTING_PERIOD WHEN 7 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS JUL 
          , CASE A.ACCOUNTING_PERIOD WHEN 8 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS AUG 
          , CASE A.ACCOUNTING_PERIOD WHEN 9 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS SEP 
          , CASE A.ACCOUNTING_PERIOD WHEN 10 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS OCT 
          , CASE A.ACCOUNTING_PERIOD WHEN 11 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS NOV 
          , CASE A.ACCOUNTING_PERIOD WHEN 12 THEN DECODE(SUBSTR(LEDGER,1,6),'DET_UU',SUM(MONETARY_AMOUNT),0) ELSE 0 END AS DEC            
FROM PS_KK_ACTIVITY_LOG A, PS_GL_ACCOUNT_TBL D, PS_SET_CNTRL_REC B4
WHERE A.BUSINESS_UNIT = 'UNUNI'
     AND B4.SETCNTRLVALUE = A.BUSINESS_UNIT
     AND B4.RECNAME = 'GL_ACCOUNT_TBL'
     AND B4.SETID = D.SETID
     AND A.ACCOUNT = D.ACCOUNT
     AND D.EFFDT = (SELECT MAX(CJ.EFFDT) FROM PS_GL_ACCOUNT_TBL CJ WHERE CJ.SETID = D.SETID AND CJ.ACCOUNT = D.ACCOUNT AND CJ.EFFDT <= sysdate)
     AND (A.FISCAL_YEAR IN ('2013') AND (A.ACCOUNTING_PERIOD BETWEEN 1 AND 12))
     --AND A.BUDGET_PERIOD IN ('2013')
     AND A.LEDGER LIKE 'DET_UU%'
     AND A.BASE_CURRENCY = 'USD'
     --AND A.PROJECT_ID = '00086239'
     --AND A.DEPTID = '11901'
     --AND A.POSTED_TOTAL_AMT <> 0
     --AND D.ACCOUNT_TYPE IN ('E', 'R')
GROUP BY A.BUSINESS_UNIT, A.OPERATING_UNIT, A.FUND_CODE, A.DEPTID, A.ACCOUNT, D.DESCR, A.PROJECT_ID, A.CHARTFIELD2, 
               A.AFFILIATE, A.AFFILIATE_INTRA1, A.AFFILIATE_INTRA2, A.ACCOUNTING_PERIOD, LEDGER) X, PS_PROJECT B, PS_DEPTID_BUGL_VW C
WHERE X.BUSINESS_UNIT = B.BUSINESS_UNIT (+)
     AND X.PROJECT_ID = B.PROJECT_ID (+)     
     AND C.SETID = (SELECT SETID FROM PS_SET_CNTRL_REC G WHERE G.SETCNTRLVALUE = X.BUSINESS_UNIT AND G.RECNAME = 'DEPT_TBL')
     AND X.DEPTID = C.DEPTID
     AND C.EFFDT = (SELECT MAX(C_ED.EFFDT) FROM PS_DEPTID_BUGL_VW C_ED WHERE C.SETID = C_ED.SETID AND C.DEPTID = C_ED.DEPTID AND C_ED.EFFDT <= SYSDATE)    
GROUP BY X.BUSINESS_UNIT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, C.DESCR, X.PROJECT_ID, B.DESCR, X.CHARTFIELD2, 
               X.AFFILIATE, X.AFFILIATE_INTRA1, X.AFFILIATE_INTRA2, X.ACCOUNT, X.DESCR) T
GROUP BY T.BUSINESS_UNIT, T.OPERATING_UNIT, T.FUND_CODE, T.DEPTID, T.PROJECT_ID, T.PRJ_DESCR, T.CHARTFIELD2, T.AFFILIATE, T.AFFILIATE_INTRA1, T.AFFILIATE_INTRA2,
               T.ACCT_ROLLUP, T.ACCOUNT, T.ACCT_DESCR
--HAVING (SUM(T.EXP_AMT_GL) <> 0 AND SUM(T.EXP_AMT_KK) <> 0)
ORDER BY ACCOUNT,2,3,4,5,6,7,8;