--Version 11
--Added PO Budget Date from PO Distrib level
SELECT T.BUSINESS_UNIT, T.PO_ID, T.LINE_NBR, T.SCHED_NBR, T.DISTRIB_LINE_NUM, --' ', ' ', ' ', ' ', ' ', ' ', 
            T.PO_DT, T.ACCOUNTING_DT, T.BUDGET_DT, T.HDR_CURR_CD, T.PO_HDR_RATE, T.PO_DIST_RATE, T.CURRENT_RATE,
            T.INV_ITEM_ID, T.DESCR254_MIXED, T.UNIT_OF_MEASURE, T.RECV_REQ, T.AMT_ONLY_FLG, --T.QTY_TYPE,  
            T.ACCOUNT, T.OPERATING_UNIT, T.FUND_CODE, T.DEPTID, T.PROJECT_ID, T.ACTIVITY_ID, T.CHARTFIELD2,
            --SUM(T.QTY_ORDERED) AS QTY_ORDERED, SUM(T.AMT_ORDERED) AS AMT_ORDERED, T.CURRENCY_CD, SUM(T.AMT_ORDERED_BASE) AS AMT_ORDERED_BASE,
            T.QTY_ORDERED, T.AMT_ORDERED, T.CURRENCY_CD, T.AMT_ORDERED_BASE,
            SUM(T.QTY_RECEIVED) AS QTY_RECEIVED, SUM(T.QTY_ACCEPTED) AS QTY_ACCEPTED, SUM(T.AMT_RECEIVED) AS AMT_RECEIVED, T.RCPT_CURR_CD,
            SUM(T.AMT_RECEIVED_BASE) AS AMT_RECEIVED_BASE,
            SUM(T.QTY_INVOICED) AS QTY_INVOICED, SUM(T.AMT_INVOICED) AS AMT_INVOICED, T.INV_CURR_CD, SUM(T.AMT_INVOICED_BASE) AS AMT_INVOICED_BASE,
            SUM(T.QTY_MATCHED) AS QTY_MATCHED, SUM(T.AMT_MATCHED) AS AMT_MATCHED, T.MATCH_CURR_CD
FROM (
SELECT X.BUSINESS_UNIT, X.PO_ID, X.LINE_NBR, X.SCHED_NBR, X.DISTRIB_LINE_NUM, HDR.PO_DT, HDR.ACCOUNTING_DT, DIST.BUDGET_DT, 
            HDR.CURRENCY_CD AS HDR_CURR_CD, NVL(ROUND((HDR.RATE_MULT/HDR.RATE_DIV), 7), 0) AS PO_HDR_RATE, 
            NVL(ROUND((DIST.RATE_MULT/DIST.RATE_DIV), 7), 0) AS PO_DIST_RATE, NVL(ROUND(E.CUR_EXCHNG_RT, 7), 0) AS CURRENT_RATE,
            X.INV_ITEM_ID, X.DESCR254_MIXED, X.UNIT_OF_MEASURE, X.RECV_REQ, X.AMT_ONLY_FLG, --X.QTY_TYPE,
            X.ACCOUNT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, X.PROJECT_ID, X.ACTIVITY_ID, X.CHARTFIELD2,
            X.QTY_ORDERED, X.AMT_ORDERED, X.CURRENCY_CD, X.AMT_ORDERED_BASE,
            --SUM(X.QTY_ORDERED) AS QTY_ORDERED, SUM(X.AMT_ORDERED) AS AMT_ORDERED, X.CURRENCY_CD, SUM(X.AMT_ORDERED_BASE) AS AMT_ORDERED_BASE,
            SUM(X.QTY_RECEIVED) AS QTY_RECEIVED, SUM(X.QTY_ACCEPTED) AS QTY_ACCEPTED, SUM(X.AMT_RECEIVED) AS AMT_RECEIVED, 
            DECODE(X.RCPT_CURR_CD, ' ', X.CURRENCY_CD, X.RCPT_CURR_CD) AS RCPT_CURR_CD, SUM(X.AMT_RECEIVED_BASE) AS AMT_RECEIVED_BASE,
            SUM(X.QTY_INVOICED) AS QTY_INVOICED, SUM(X.AMT_INVOICED) AS AMT_INVOICED, 
            DECODE(X.INV_CURR_CD, ' ', DECODE(SUM(X.QTY_INVOICED), 0, X.CURRENCY_CD, X.INV_CURR_CD), X.INV_CURR_CD) AS INV_CURR_CD, 
            SUM(X.AMT_INVOICED_BASE) AS AMT_INVOICED_BASE,
            SUM(X.QTY_MATCHED) AS QTY_MATCHED, SUM(X.AMT_MATCHED) AS AMT_MATCHED, 
            DECODE(X.MATCH_CURR_CD, ' ', DECODE(SUM(X.QTY_MATCHED), 0, X.CURRENCY_CD, X.MATCH_CURR_CD), X.MATCH_CURR_CD) MATCH_CURR_CD
FROM ( --PO Details Clause
SELECT L.BUSINESS_UNIT, L.PO_ID, L.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM, 
            L.INV_ITEM_ID, L.DESCR254_MIXED, L.UNIT_OF_MEASURE, L.RECV_REQ, L.AMT_ONLY_FLG, --L.QTY_TYPE,  
            --NVL(ROUND(SUM(DIST.QTY_PO), 3), 0) AS QTY_ORDERED, NVL(ROUND(SUM(DIST.MERCHANDISE_AMT), 3), 0) AS AMT_ORDERED, DIST.CURRENCY_CD, 
            --NVL(ROUND(SUM(DIST.MERCH_AMT_BSE), 3), 0) AS AMT_ORDERED_BASE,            
            DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2,
            DIST.QTY_PO AS QTY_ORDERED, DIST.MERCHANDISE_AMT AS AMT_ORDERED, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE AS AMT_ORDERED_BASE,            
            0.00 AS QTY_RECEIVED, 0.00 AS QTY_ACCEPTED, 0.00 AS AMT_RECEIVED, ' ' AS RCPT_CURR_CD, 0.00 AS AMT_RECEIVED_BASE,
            0.00 AS QTY_INVOICED, 0.00 AS AMT_INVOICED, ' ' AS INV_CURR_CD, 0.00 AS AMT_INVOICED_BASE,
            0.00 AS QTY_MATCHED, 0.00 AS AMT_MATCHED, ' ' AS MATCH_CURR_CD
FROM PS_PO_LINE L, PS_PO_LINE_DISTRIB DIST
WHERE L.BUSINESS_UNIT = DIST.BUSINESS_UNIT 
    AND L.PO_ID = DIST.PO_ID 
    AND L.LINE_NBR = DIST.LINE_NBR
    AND L.CANCEL_STATUS NOT IN ('C', 'X')
    AND DIST.DISTRIB_LN_STATUS NOT IN ('X', 'C') 
    AND L.BUSINESS_UNIT LIKE '6%'
    --AND L.PO_ID = '0000001978'
GROUP BY L.BUSINESS_UNIT, L.PO_ID, L.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM,
               L.INV_ITEM_ID, L.DESCR254_MIXED, L.UNIT_OF_MEASURE, L.RECV_REQ, L.AMT_ONLY_FLG, --L.QTY_TYPE,
               DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2,
               DIST.QTY_PO, DIST.MERCHANDISE_AMT, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE 
               --DIST.CURRENCY_CD
--ORDER BY 1,2,3;
UNION ALL --Receipt Clause
SELECT DIST.BUSINESS_UNIT, DIST.PO_ID, DIST.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM, --' ', ' ', ' ', ' ', ' ', ' ',
            L.INV_ITEM_ID, L.DESCR254_MIXED, L.UNIT_OF_MEASURE, L.RECV_REQ, L.AMT_ONLY_FLG, --L.QTY_TYPE, 
            DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2,
            DIST.QTY_PO AS QTY_ORDERED, DIST.MERCHANDISE_AMT AS AMT_ORDERED, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE AS AMT_ORDERED_BASE,
            --0.00 AS QTY_ORDERED, 0.00 AS AMT_ORDERED, ' ' AS CURRENCY_CD, 0.00 AS AMT_ORDERED_BASE,
            --NVL(ROUND(SUM(RECV.QTY_SH_RECVD_VUOM), 3), 0) QTY_RECEIVED, NVL(ROUND(SUM(RECV.QTY_SH_NETRCV_VUOM), 3), 0) QTY_ACCEPTED,
            NVL(ROUND(SUM(QTY_DS_ACCPT_VUOM), 3), 0) AS QTY_RECEIVED, 0.00 AS QTY_ACCEPTED,
            NVL(ROUND(SUM(RCVD.MERCHANDISE_AMT), 3), 0) AMT_RECEIVED, NVL(RCVD.CURRENCY_CD, ' ') AS RCPT_CURR_CD,
             NVL(ROUND(SUM(RCVD.MERCH_AMT_BSE), 3), 0) AMT_RECEIVED_BASE,
            0.00 AS QTY_INVOICED, 0.00 AS AMT_INVOICED, ' ' AS INV_CURR_CD, 0.00 AS AMT_INVOICED_BASE,
            0.00 AS QTY_MATCHED, 0.00 AS AMT_MATCHED, ' ' AS MATCH_CURR_CD
FROM PS_PO_LINE_DISTRIB DIST, PS_RECV_LN_DISTRIB RCVD, PS_PO_LINE L --,PS_RECV_LN_SHIP RECV
WHERE RCVD.BUSINESS_UNIT_PO = DIST.BUSINESS_UNIT 
    AND RCVD.PO_ID = DIST.PO_ID 
    AND RCVD.LINE_NBR = DIST.LINE_NBR
    AND RCVD.SCHED_NBR = DIST.SCHED_NBR
    AND RCVD.PO_DIST_LINE_NUM = DIST.DISTRIB_LINE_NUM
    AND L.BUSINESS_UNIT = DIST.BUSINESS_UNIT
    AND L.PO_ID = DIST.PO_ID 
    AND L.LINE_NBR = DIST.LINE_NBR    
    AND DIST.BUSINESS_UNIT LIKE '6%'
    --AND DIST.PO_ID IN ('0000001945')
    AND RCVD.RECV_DS_STATUS <> 'X' 
    AND L.CANCEL_STATUS NOT IN ('C', 'X')
    AND DIST.DISTRIB_LN_STATUS NOT IN ('X', 'C')
    --AND RECV.RECV_SHIP_STATUS <> 'X'
GROUP BY DIST.BUSINESS_UNIT, DIST.PO_ID, DIST.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM,
                L.INV_ITEM_ID, L.DESCR254_MIXED, L.UNIT_OF_MEASURE, L.RECV_REQ, L.AMT_ONLY_FLG, --L.QTY_TYPE,
                DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2, 
                DIST.QTY_PO, DIST.MERCHANDISE_AMT, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE,
                RCVD.CURRENCY_CD
--ORDER BY 1,2,3;
UNION ALL --Invoice/Voucher Clause
SELECT DIST.BUSINESS_UNIT, DIST.PO_ID, DIST.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM, --' ', ' ', ' ', ' ', ' ', ' ',
            POL.INV_ITEM_ID, POL.DESCR254_MIXED, POL.UNIT_OF_MEASURE, POL.RECV_REQ, POL.AMT_ONLY_FLG, --L.QTY_TYPE,
            DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2,
            DIST.QTY_PO AS QTY_ORDERED, DIST.MERCHANDISE_AMT AS AMT_ORDERED, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE AS AMT_ORDERED_BASE,
            --0.00 AS QTY_ORDERED, 0.00 AS AMT_ORDERED, ' ' AS CURRENCY_CD, 0.00 AS AMT_ORDERED_BASE,
            0.00 AS QTY_RECEIVED, 0.00 AS QTY_ACCEPTED, 0.00 AS AMT_RECEIVED, ' ' AS RCPT_CURR_CD, 0.00 AS AMT_RECEIVED_BASE,
            NVL(ROUND(SUM(DLV.QTY_VCHR), 3), 0) QTY_INVOICED, NVL(ROUND(SUM(DLV.FOREIGN_AMOUNT), 3), 0) AMT_INVOICED, NVL(DLV.TXN_CURRENCY_CD, ' ') AS INV_CURR_CD, 
            NVL(ROUND(SUM(DLV.MERCH_AMT_BSE), 3), 0) AMT_INVOICED_BASE,
            0.00 AS QTY_MATCHED, 0.00 AS AMT_MATCHED, ' ' AS MATCH_CURR_CD 
FROM PS_VOUCHER_LINE L, PS_VOUCHER V, PS_DISTRIB_LINE DLV, PS_PO_LINE_DISTRIB DIST, PS_PO_LINE POL 
WHERE V.BUSINESS_UNIT = L.BUSINESS_UNIT 
  AND V.VOUCHER_ID = L.VOUCHER_ID
  AND V.BUSINESS_UNIT = DLV.BUSINESS_UNIT 
  AND V.VOUCHER_ID = DLV.VOUCHER_ID
  AND L.VOUCHER_LINE_NUM = DLV.VOUCHER_LINE_NUM
  AND L.BUSINESS_UNIT_PO = DIST.BUSINESS_UNIT 
  AND L.PO_ID = DIST.PO_ID 
  AND L.LINE_NBR = DIST.LINE_NBR
  AND DLV.SCHED_NBR = DIST.SCHED_NBR
  AND DLV.PO_DIST_LINE_NUM = DIST.DISTRIB_LINE_NUM
  AND POL.BUSINESS_UNIT = DIST.BUSINESS_UNIT
  AND POL.PO_ID = DIST.PO_ID 
  AND POL.LINE_NBR = DIST.LINE_NBR
  AND L.BUSINESS_UNIT_PO <> ' ' 
  AND L.PO_ID <> ' ' 
  AND V.ENTRY_STATUS <> 'X' 
  AND V.VOUCHER_STYLE <> 'THRD' 
  AND (V.MANUAL_CLOSE_DT IS NULL OR EXISTS (SELECT 'X' FROM PS_PYMNT_VCHR_XREF X WHERE X.BUSINESS_UNIT = V.BUSINESS_UNIT AND X.VOUCHER_ID = V.VOUCHER_ID AND X.PYMNT_SELCT_STATUS <> 'X'))
  AND POL.CANCEL_STATUS NOT IN ('C', 'X')
  AND DIST.DISTRIB_LN_STATUS NOT IN ('X', 'C')
  AND DIST.BUSINESS_UNIT LIKE '6%'
  --AND DIST.PO_ID IN ('0000001978')
GROUP BY DIST.BUSINESS_UNIT, DIST.PO_ID, DIST.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM,
               POL.INV_ITEM_ID, POL.DESCR254_MIXED, POL.UNIT_OF_MEASURE, POL.RECV_REQ, POL.AMT_ONLY_FLG, --L.QTY_TYPE,
               DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2, 
               DIST.QTY_PO, DIST.MERCHANDISE_AMT, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE,
               DLV.TXN_CURRENCY_CD
--ORDER BY 1,2,3;
UNION ALL --Matching Clause
SELECT DIST.BUSINESS_UNIT, DIST.PO_ID, DIST.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM, --' ', ' ', ' ', ' ', ' ', ' ',
            L.INV_ITEM_ID, L.DESCR254_MIXED, L.UNIT_OF_MEASURE, L.RECV_REQ, L.AMT_ONLY_FLG, --L.QTY_TYPE,
            DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2,
            DIST.QTY_PO AS QTY_ORDERED, DIST.MERCHANDISE_AMT AS AMT_ORDERED, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE AS AMT_ORDERED_BASE,
            --0.00 AS QTY_ORDERED, 0.00 AS AMT_ORDERED, ' ' AS CURRENCY_CD, 0.00 AS AMT_ORDERED_BASE, 
            0.00 AS QTY_RECEIVED, 0.00 AS QTY_ACCEPTED, 0.00 AS AMT_RECEIVED, ' ' AS RCPT_CURR_CD, 0.00 AS AMT_RECEIVED_BASE,
            0.00 AS QTY_INVOICED, 0.00 AS AMT_INVOICED, ' ' AS INV_CURR_CD, 0.00 AS AMT_INVOICED_BASE,
            NVL(ROUND(SUM(MTCH.QTY_VCHR_CNVT), 3), 0) QTY_MATCHED, NVL(ROUND(SUM(MTCH.MERCH_AMT_CNVT), 3), 0) AMT_MATCHED, 
            NVL(MTCH.CURRENCY_CD, ' ') AS MATCH_CURR_CD
FROM PS_PO_LINE_MATCHED MTCH, PS_PO_LINE_DISTRIB DIST, PS_PO_LINE L
WHERE MTCH.BUSINESS_UNIT = DIST.BUSINESS_UNIT 
    AND MTCH.PO_ID = DIST.PO_ID 
    AND MTCH.LINE_NBR = DIST.LINE_NBR
    AND MTCH.SCHED_NBR = DIST.SCHED_NBR
    AND L.BUSINESS_UNIT = DIST.BUSINESS_UNIT
    AND L.PO_ID = DIST.PO_ID 
    AND L.LINE_NBR = DIST.LINE_NBR
    AND L.CANCEL_STATUS NOT IN ('C', 'X')
    AND DIST.DISTRIB_LN_STATUS NOT IN ('X', 'C')
    AND DIST.BUSINESS_UNIT LIKE '6%'
    --AND DIST.PO_ID IN ('0000001978')
GROUP BY DIST.BUSINESS_UNIT, DIST.PO_ID, DIST.LINE_NBR, DIST.SCHED_NBR, DIST.DISTRIB_LINE_NUM, 
               L.INV_ITEM_ID, L.DESCR254_MIXED, L.UNIT_OF_MEASURE, L.RECV_REQ, L.AMT_ONLY_FLG, --L.QTY_TYPE,
               DIST.ACCOUNT, DIST.OPERATING_UNIT, DIST.FUND_CODE, DIST.DEPTID, DIST.PROJECT_ID, DIST.ACTIVITY_ID, DIST.CHARTFIELD2,
               DIST.QTY_PO, DIST.MERCHANDISE_AMT, DIST.CURRENCY_CD, DIST.MERCH_AMT_BSE,
               MTCH.CURRENCY_CD) X, PS_PO_HDR HDR, PS_PO_LINE_DISTRIB DIST, PS_CUR_RT_TBL E, PS_BUS_UNIT_TBL_GL F
WHERE X.BUSINESS_UNIT = HDR.BUSINESS_UNIT
    AND X.PO_ID = HDR.PO_ID 
    AND X.BUSINESS_UNIT = DIST.BUSINESS_UNIT
    AND X.PO_ID = DIST.PO_ID
    AND X.LINE_NBR = DIST.LINE_NBR
    AND X.SCHED_NBR = DIST.SCHED_NBR
    AND X.DISTRIB_LINE_NUM = DIST.DISTRIB_LINE_NUM
    AND DIST.BUSINESS_UNIT_GL = F.BUSINESS_UNIT
    AND E.FROM_CUR = HDR.CURRENCY_CD
    AND E.TO_CUR = F.BASE_CURRENCY
    AND E.CUR_RT_TYPE = 'UNORE'
    AND E.EFFDT = (SELECT MAX(E1.EFFDT) FROM PS_CUR_RT_TBL E1 WHERE E.FROM_CUR = E1.FROM_CUR AND E.TO_CUR = E1.TO_CUR AND E.CUR_RT_TYPE = E1.CUR_RT_TYPE 
                                                                                                            AND E1.EFFDT <= SYSDATE)
    AND E.EFF_STATUS = 'A'
    AND X.BUSINESS_UNIT LIKE '6%'
    --AND HDR.PO_ID IN ('0000001978')
    AND HDR.PO_STATUS NOT IN ('C', 'X', 'PX')
    AND DIST.DISTRIB_LN_STATUS NOT IN ('X', 'C') 
    AND DIST.KK_CLOSE_FLAG <> 'Y'
    AND DIST.BUDGET_DT BETWEEN TO_DATE('2013-01-01','YYYY-MM-DD') AND TO_DATE('2013-12-31','YYYY-MM-DD')
    AND X.BUSINESS_UNIT <> ' '
    AND X.PO_ID <> ' '
GROUP BY X.BUSINESS_UNIT, X.PO_ID, X.LINE_NBR, X.SCHED_NBR, X.DISTRIB_LINE_NUM, HDR.PO_DT, HDR.ACCOUNTING_DT, DIST.BUDGET_DT, HDR.CURRENCY_CD, 
               NVL(ROUND((HDR.RATE_MULT/HDR.RATE_DIV), 7), 0), NVL(ROUND((DIST.RATE_MULT/DIST.RATE_DIV), 7), 0), NVL(ROUND(E.CUR_EXCHNG_RT, 7), 0),
               X.INV_ITEM_ID, X.DESCR254_MIXED, X.UNIT_OF_MEASURE, X.RECV_REQ, X.AMT_ONLY_FLG, --X.QTY_TYPE, 
               X.ACCOUNT, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, X.PROJECT_ID, X.ACTIVITY_ID, X.CHARTFIELD2,
               X.QTY_ORDERED, X.AMT_ORDERED, X.CURRENCY_CD, X.AMT_ORDERED_BASE, 
               X.CURRENCY_CD, X.RCPT_CURR_CD, X.INV_CURR_CD, X.MATCH_CURR_CD) T
GROUP BY T.BUSINESS_UNIT, T.PO_ID, T.LINE_NBR, T.SCHED_NBR, T.DISTRIB_LINE_NUM,
               T.PO_DT, T.ACCOUNTING_DT, T.BUDGET_DT, T.HDR_CURR_CD, T.PO_HDR_RATE, T.PO_DIST_RATE, T.CURRENT_RATE,
               T.INV_ITEM_ID, T.DESCR254_MIXED, T.UNIT_OF_MEASURE, T.RECV_REQ, T.AMT_ONLY_FLG, --T.QTY_TYPE, 
               T.ACCOUNT, T.OPERATING_UNIT, T.FUND_CODE, T.DEPTID, T.PROJECT_ID, T.ACTIVITY_ID, T.CHARTFIELD2,
               T.QTY_ORDERED, T.AMT_ORDERED, T.CURRENCY_CD, T.AMT_ORDERED_BASE,
               T.CURRENCY_CD, T.RCPT_CURR_CD, T.INV_CURR_CD, T.MATCH_CURR_CD
ORDER BY 1,2,3,4,5;
