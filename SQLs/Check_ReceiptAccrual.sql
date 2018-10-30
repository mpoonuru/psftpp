--Check RA process run
SELECT * FROM PSPRCSRQST WHERE PRCSNAME = 'PO_RECVACCR' ORDER BY PRCSINSTANCE DESC;
--Find all those REQs where FINANCIAL_ASSET_SW = 'Y' for AM BU UNUNI
SELECT * FROM PS_REQ_LN_DISTRIB WHERE BUSINESS_UNIT LIKE '6%' AND BUSINESS_UNIT_AM = 'UNUNI' AND FINANCIAL_ASSET_SW = 'Y';
--Find all those POs where FINANCIAL_ASSET_SW = 'Y' for AM BU UNUNI
SELECT * FROM PS_PO_LINE_DISTRIB WHERE BUSINESS_UNIT LIKE '6%' AND BUSINESS_UNIT_AM = 'UNUNI' AND FINANCIAL_ASSET_SW = 'Y';
--Find all those Receipts where FINANCIAL_ASSET_SW = 'Y' for AM BU UNUNI
SELECT * FROM PS_RECV_LN_DISTRIB WHERE BUSINESS_UNIT LIKE '6%' AND BUSINESS_UNIT_AM = 'UNUNI' AND FINANCIAL_ASSET_SW = 'Y';
--Find all UNU receipts which are not closed and raised since 7th Oct 2013
SELECT H.BUSINESS_UNIT, H.RECEIVER_ID, H.RECEIPT_DT, S.OPRID, H.MATCH_STATUS_RECV, S.RECV_LN_NBR, S.RECV_SHIP_SEQ_NBR, LD.DISTRIB_LINE_NUM, S.CURRENCY_CD, 
            S.QTY_SH_NETRCV_VUOM, S.MERCHANDISE_AMT, S.MERCH_AMT_BSE, S.MERCH_AMT_PO_BSE, S.BUSINESS_UNIT_PO AS BU_PO, S.PO_ID, L.LINE_NBR, D.SCHED_NBR, 
            D.DISTRIB_LINE_NUM, S.DISTRIB_MTHD_FLG, S.INV_ITEM_ID, L.CATEGORY_ID, G.CATEGORY_CD, G.DESCR, G.ACCOUNT AS CAT_ACCOUNT,
            S.DESCR254_MIXED,
            LD.BUSINESS_UNIT_AM, LD.BUSINESS_UNIT_GL, LD.PROFILE_ID, LD.FINANCIAL_ASSET_SW, LD.RECV_DS_STATUS, LD.MERCHANDISE_AMT_PO, LD.LOCATION, LD.REQ_ID,
            S.QTY_LN_ASSET_SUOM, S.QTY_LN_INV_SUOM, S.QTY_SH_ACCPT, S.QTY_SH_ACCPT_SUOM, S.QTY_SH_ACCPT_VUOM, S.QTY_SH_NETRCV_VUOM, S.QTY_SH_RECVD, 
            S.QTY_SH_RECVD_SUOM, S.QTY_SH_RECVD_VUOM, S.REJECT_ACTION, S.REJECT_REASON, 
            S.RECEIPT_ALLOC_TYPE, S.RECEIPT_DTTM, S.RECEIPT_UM, S.RECEIVE_UOM, S.RECV_LN_MATCH_OPT, S.RECV_SHIP_STATUS, S.RECV_STOCK_UOM, 
            S.SERIAL_CONTROL, S.SERIAL_STATUS, S.SHIP_DATE_STATUS, S.SHIP_QTY_STATUS, S.UNIT_MEASURE_STD
FROM PS_RECV_HDR H, PS_PO_LINE L, PS_RECV_LN_SHIP S, PS_PO_LINE_DISTRIB D, PS_SET_CNTRL_REC F, PS_ITM_CAT_TBL G, PS_RECV_LN_DISTRIB LD
WHERE H.BUSINESS_UNIT = S.BUSINESS_UNIT
    AND H.RECEIVER_ID = S.RECEIVER_ID
    AND S.BUSINESS_UNIT_PO = L.BUSINESS_UNIT 
    AND S.PO_ID = L.PO_ID 
    AND S.LINE_NBR = L.LINE_NBR    
    AND S.BUSINESS_UNIT_PO = D.BUSINESS_UNIT 
    AND S.PO_ID = D.PO_ID 
    AND S.LINE_NBR = D.LINE_NBR
    AND S.BUSINESS_UNIT = LD.BUSINESS_UNIT 
    AND S.RECEIVER_ID = LD.RECEIVER_ID 
    AND S.RECV_LN_NBR = LD.RECV_LN_NBR 
    AND S.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR
    AND F.SETCNTRLVALUE = S.BUSINESS_UNIT
    AND G.SETID = F.SETID
    AND G.CATEGORY_ID = S.CATEGORY_ID
    AND F.RECNAME = 'ITM_CAT_TBL'   
    AND G.EFFDT = (SELECT MAX(G_ED.EFFDT) FROM PS_ITM_CAT_TBL G_ED WHERE G.SETID = G_ED.SETID AND G.CATEGORY_TYPE = G_ED.CATEGORY_TYPE 
           AND G.CATEGORY_CD = G_ED.CATEGORY_CD 
           AND G.CATEGORY_ID = G_ED.CATEGORY_ID AND G_ED.EFFDT <= SYSDATE)
    AND H.BUSINESS_UNIT LIKE '6%'
    AND H.RECV_STATUS <> 'C' 
    AND TO_CHAR(((H.LAST_DTTM_UPDATE ) + (0)),'YYYY-MM-DD') >= '2013-10-07' 
    AND TO_CHAR(((H.LAST_DTTM_UPDATE ) + (-1)),'YYYY-MM-DD') <= TO_CHAR(SYSDATE, 'YYYY-MM-DD')
    --AND INTFC_ASSET = 'Y' 
ORDER BY S.RECEIPT_DTTM DESC, H.BUSINESS_UNIT, H.RECEIVER_ID;
-----------------RA
--Actual Receipt Accrual
SELECT H.BUSINESS_UNIT AS BU_RECV, H.RECEIVER_ID, H.RECEIPT_DT, H.MATCH_STATUS_RECV, S.RECV_LN_NBR, S.RECV_SHIP_SEQ_NBR, LD.DISTRIB_LINE_NUM, S.CURRENCY_CD, S.QTY_SH_NETRCV_VUOM, 
            S.MERCHANDISE_AMT, S.MERCH_AMT_BSE, S.MERCH_AMT_PO_BSE, S.BUSINESS_UNIT_PO AS BU_PO, S.PO_ID, L.LINE_NBR, D.SCHED_NBR, S.DISTRIB_MTHD_FLG,
            D.DISTRIB_LINE_NUM, G.CATEGORY_CD, G.DESCR, G.RECV_REQ, P.VENDOR_SETID, P.VENDOR_ID, S.CONVERSION_RATE, 
            LD.BUSINESS_UNIT_AM, LD.BUSINESS_UNIT_GL, LD.PROFILE_ID, LD.FINANCIAL_ASSET_SW, LD.RECV_DS_STATUS  
FROM PS_RECV_HDR H, PS_PO_HDR P, PS_PO_LINE L, PS_RECV_LN_SHIP S, PS_PO_LINE_DISTRIB D, PS_SET_CNTRL_REC F, PS_ITM_CAT_TBL G, PS_RECV_LN_DISTRIB LD
WHERE H.BUSINESS_UNIT LIKE '6%'
   AND S.BUSINESS_UNIT = H.BUSINESS_UNIT 
   AND S.RECEIVER_ID = H.RECEIVER_ID 
   AND S.MATCH_LINE_FLG = 'Y' 
   AND S.RECV_LN_MATCH_OPT <> 'F' 
   AND S.PRODUCTION_ID = ' ' 
   AND S.BUSINESS_UNIT_PO = P.BUSINESS_UNIT 
   AND S.PO_ID = P.PO_ID 
   AND S.PO_ID <> ' ' 
   AND S.BUSINESS_UNIT_PO = L.BUSINESS_UNIT 
   AND S.PO_ID = L.PO_ID 
   AND S.LINE_NBR = L.LINE_NBR    
   AND S.BUSINESS_UNIT_PO = D.BUSINESS_UNIT 
   AND S.PO_ID = D.PO_ID 
   AND S.LINE_NBR = D.LINE_NBR
   --Added 10Mar2015
   AND S.SCHED_NBR = D.SCHED_NBR
   --End
   AND S.BUSINESS_UNIT = LD.BUSINESS_UNIT 
   AND S.RECEIVER_ID = LD.RECEIVER_ID 
   AND S.RECV_LN_NBR = LD.RECV_LN_NBR 
   AND S.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR
   --Added 10Mar2015
   AND LD.PO_DIST_LINE_NUM = D.DISTRIB_LINE_NUM
   --End
   AND F.SETCNTRLVALUE = S.BUSINESS_UNIT
   AND G.SETID = F.SETID
   AND G.CATEGORY_ID = S.CATEGORY_ID
   AND F.RECNAME = 'ITM_CAT_TBL'   
   AND G.EFFDT = (SELECT MAX(G_ED.EFFDT) FROM PS_ITM_CAT_TBL G_ED WHERE G.SETID = G_ED.SETID AND G.CATEGORY_TYPE = G_ED.CATEGORY_TYPE AND G.CATEGORY_CD = G_ED.CATEGORY_CD 
          AND G.CATEGORY_ID = G_ED.CATEGORY_ID AND G_ED.EFFDT <= SYSDATE)    
   AND L.RECV_REQ = 'Y' 
   AND S.MERCHANDISE_AMT <> 0 
   AND S.RECV_SHIP_STATUS IN ('O', 'R') 
   AND H.RECV_STATUS IN ('N', 'O', 'P','R','M') 
   AND P.MATCH_STATUS_PO NOT IN ('N')
   AND H.MATCH_STATUS_RECV <> 'M' 
   AND D.DST_ACCT_TYPE = 'DST'
   AND D.KK_CLOSE_FLAG <> 'Y'   
   --AND NOT EXISTS (SELECT 'X' FROM PS_RECV_LN_ACCTG LN WHERE LN.BUSINESS_UNIT = LD.BUSINESS_UNIT AND LN.RECEIVER_ID = LD.RECEIVER_ID AND LN.RECV_LN_NBR = LD.RECV_LN_NBR AND LN.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR AND LN.DISTRIB_LINE_NUM = LD.DISTRIB_LINE_NUM)
   AND EXISTS (SELECT 'X' FROM PS_RECV_LN_SHP_MTH M WHERE S.BUSINESS_UNIT = M.BUSINESS_UNIT AND S.RECEIVER_ID  = M.RECEIVER_ID AND S.RECV_LN_NBR = M.RECV_LN_NBR AND S.RECV_SHIP_SEQ_NBR = M.RECV_SHIP_SEQ_NBR)
   AND NOT EXISTS (SELECT 'X' FROM PS_PO_LINE_SHIP LS WHERE LS.BUSINESS_UNIT = S.BUSINESS_UNIT_PO AND LS.PO_ID = S.PO_ID AND LS.LINE_NBR = S.LINE_NBR AND LS.SCHED_NBR = S.SCHED_NBR AND LS.MATCH_LINE_OPT = 'N')    
ORDER BY 1,2,3,4,5,D.LINE_NBR, D.SCHED_NBR, D.DISTRIB_LINE_NUM;
--Modify Receipt Accrual Query to include
-- 1. Item ID and Item Description
-- 2. PO Line Description
-- 3. PO Line Distrib Account
SELECT H.BUSINESS_UNIT AS BU_RECV, H.RECEIVER_ID, H.RECEIPT_DT, S.OPRID, H.MATCH_STATUS_RECV, 
            S.RECV_LN_NBR, S.RECV_SHIP_SEQ_NBR, LD.DISTRIB_LINE_NUM, S.CURRENCY_CD, 
            S.QTY_SH_NETRCV_VUOM, S.MERCHANDISE_AMT, S.MERCH_AMT_BSE, S.MERCH_AMT_PO_BSE, 
            S.BUSINESS_UNIT_PO AS BU_PO, S.PO_ID, L.LINE_NBR, D.SCHED_NBR, S.DISTRIB_MTHD_FLG,
            D.DISTRIB_LINE_NUM, G.CATEGORY_CD, G.DESCR, G.ACCOUNT AS CAT_ACCOUNT, L.INV_ITEM_ID, ITM.DESCR AS ITM_DESCR, L.DESCR254_MIXED, 
            G.RECV_REQ, P.VENDOR_SETID, P.VENDOR_ID, V.NAME1, S.CONVERSION_RATE,
            LD.BUSINESS_UNIT_AM, LD.BUSINESS_UNIT_GL, LD.PROFILE_ID, LD.FINANCIAL_ASSET_SW, LD.RECV_DS_STATUS, LD.MERCHANDISE_AMT_PO, LD.LOCATION, LD.REQ_ID,
            S.QTY_LN_ASSET_SUOM, S.QTY_LN_INV_SUOM, S.QTY_SH_ACCPT, S.QTY_SH_ACCPT_SUOM, S.QTY_SH_ACCPT_VUOM, S.QTY_SH_NETRCV_VUOM, S.QTY_SH_RECVD, 
            S.QTY_SH_RECVD_SUOM, S.QTY_SH_RECVD_VUOM, S.REJECT_ACTION, S.REJECT_REASON, 
            S.RECEIPT_ALLOC_TYPE, S.RECEIPT_DTTM, S.RECEIPT_UM, S.RECEIVE_UOM, S.RECV_LN_MATCH_OPT, S.RECV_SHIP_STATUS, S.RECV_STOCK_UOM, 
            S.SERIAL_CONTROL, S.SERIAL_STATUS, S.SHIP_DATE_STATUS, S.SHIP_QTY_STATUS, S.UNIT_MEASURE_STD
FROM PS_RECV_HDR H, PS_PO_HDR P, PS_PO_LINE L, PS_RECV_LN_SHIP S, PS_PO_LINE_DISTRIB D, PS_SET_CNTRL_REC F, PS_ITM_CAT_TBL G, PS_RECV_LN_DISTRIB LD,
          PS_MASTER_ITEM_TBL ITM, PS_VENDOR V
WHERE H.BUSINESS_UNIT LIKE '6%'
   AND S.BUSINESS_UNIT = H.BUSINESS_UNIT
   AND S.RECEIVER_ID = H.RECEIVER_ID
   AND S.MATCH_LINE_FLG = 'Y' 
   AND S.RECV_LN_MATCH_OPT <> 'F' 
   AND S.PRODUCTION_ID = ' ' 
   AND S.BUSINESS_UNIT_PO = P.BUSINESS_UNIT 
   AND S.PO_ID = P.PO_ID 
   AND S.PO_ID <> ' ' 
   AND S.BUSINESS_UNIT_PO = L.BUSINESS_UNIT 
   AND S.PO_ID = L.PO_ID 
   AND S.LINE_NBR = L.LINE_NBR    
   AND S.BUSINESS_UNIT_PO = D.BUSINESS_UNIT 
   AND S.PO_ID = D.PO_ID 
   AND S.LINE_NBR = D.LINE_NBR
   --Added 10Mar2015
   AND S.SCHED_NBR = D.SCHED_NBR
   --End
   AND S.BUSINESS_UNIT = LD.BUSINESS_UNIT 
   AND S.RECEIVER_ID = LD.RECEIVER_ID 
   AND S.RECV_LN_NBR = LD.RECV_LN_NBR 
   AND S.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR
   --Added 10Mar2015
   AND LD.PO_DIST_LINE_NUM = D.DISTRIB_LINE_NUM
   --End
   AND F.SETCNTRLVALUE = S.BUSINESS_UNIT
   AND G.SETID = F.SETID
   AND G.CATEGORY_ID = S.CATEGORY_ID
   AND F.RECNAME = 'ITM_CAT_TBL'   
   AND G.EFFDT = (SELECT MAX(G_ED.EFFDT) FROM PS_ITM_CAT_TBL G_ED WHERE G.SETID = G_ED.SETID AND G.CATEGORY_TYPE = G_ED.CATEGORY_TYPE AND G.CATEGORY_CD = G_ED.CATEGORY_CD 
          AND G.CATEGORY_ID = G_ED.CATEGORY_ID AND G_ED.EFFDT <= SYSDATE)   
   AND L.ITM_SETID = ITM.SETID (+)
   AND L.INV_ITEM_ID = ITM.INV_ITEM_ID (+)
   AND P.VENDOR_SETID = V.SETID
   AND P.VENDOR_ID = V.VENDOR_ID     
   AND L.RECV_REQ = 'Y'
   AND S.MERCHANDISE_AMT <> 0 
   AND S.RECV_SHIP_STATUS IN ('O', 'R') 
   AND H.RECV_STATUS IN ('N', 'O', 'P','R','M') 
   AND P.MATCH_STATUS_PO NOT IN ('N')
   AND H.MATCH_STATUS_RECV <> 'M' 
   AND D.DST_ACCT_TYPE = 'DST'
   AND D.KK_CLOSE_FLAG <> 'Y'
   --AND NOT EXISTS (SELECT 'X' FROM PS_RECV_LN_ACCTG LN WHERE LN.BUSINESS_UNIT = LD.BUSINESS_UNIT AND LN.RECEIVER_ID = LD.RECEIVER_ID AND LN.RECV_LN_NBR = LD.RECV_LN_NBR AND LN.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR AND LN.DISTRIB_LINE_NUM = LD.DISTRIB_LINE_NUM)
   AND EXISTS (SELECT 'X' FROM PS_RECV_LN_SHP_MTH M WHERE S.BUSINESS_UNIT = M.BUSINESS_UNIT AND S.RECEIVER_ID  = M.RECEIVER_ID AND S.RECV_LN_NBR = M.RECV_LN_NBR AND S.RECV_SHIP_SEQ_NBR = M.RECV_SHIP_SEQ_NBR)
   AND NOT EXISTS (SELECT 'X' FROM PS_PO_LINE_SHIP LS WHERE LS.BUSINESS_UNIT = S.BUSINESS_UNIT_PO AND LS.PO_ID = S.PO_ID AND LS.LINE_NBR = S.LINE_NBR AND LS.SCHED_NBR = S.SCHED_NBR AND LS.MATCH_LINE_OPT = 'N')    
ORDER BY 1,2,3,4,5,D.LINE_NBR, D.SCHED_NBR, D.DISTRIB_LINE_NUM;
--Receipt accrual lines with Budget Error
--UNU_REC_ACCRUAL_BUD_ERROR
SELECT DISTINCT A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, B.RECEIPT_DT, E.KK_SOURCE_TRAN,
            A.DST_ACCT_TYPE, A.ACCOUNT, A.OPERATING_UNIT, A.DEPTID, A.FUND_CODE, A.CHARTFIELD2, A.PROJECT_ID, A.ACTIVITY_ID, A.FOREIGN_AMOUNT, A.FOREIGN_CURRENCY, A.MONETARY_AMOUNT, 
            A.BUSINESS_UNIT_PO, A.PO_ID, A.LINE_NBR, A.BUDGET_LINE_STATUS, E.EXCPTN_TYPE, E.LEDGER_GROUP, E.PROCESS_INSTANCE, A.ACCOUNTING_PERIOD
FROM PS_RECV_LN_ACCTG A, PS_RECV_HDR B, PS_KK_SOURCE_HDR C, PS_KK_SOURCE_LN D, PS_KK_EXCPTN_TBL E
WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT
     AND A.RECEIVER_ID = B.RECEIVER_ID
     AND A.BUSINESS_UNIT LIKE '6%'
     --AND A.ACCOUNTING_DT = TO_DATE(:1,'YYYY-MM-DD')
     AND A.BUDGET_LINE_STATUS IN ('E','N')
     AND A.BUSINESS_UNIT = C.BUSINESS_UNIT
     AND A.RECEIVER_ID = C.RECEIVER_ID
     AND A.RECV_LN_NBR = C.RECV_LN_NBR
     AND A.RECV_SHIP_SEQ_NBR = C.RECV_SHIP_SEQ_NBR
     AND A.DISTRIB_LINE_NUM = C.DISTRIB_LINE_NUM
     AND C.KK_TRAN_ID = D.KK_TRAN_ID
     AND C.KK_TRAN_DT = D.KK_TRAN_DT
     AND D.KK_TRAN_ID = E.KK_TRAN_ID
     AND D.KK_TRAN_DT = E.KK_TRAN_DT
     AND D.KK_TRAN_LN = E.KK_TRAN_LN
     AND A.DST_ACCT_TYPE <> 'RAC'
ORDER BY 1,2,3,4,5;
--Check INTFC_PRE_AM Table
SELECT * FROM PS_INTFC_PRE_AM WHERE BUSINESS_UNIT_AM = 'UNUNI' ORDER BY DTTM_STAMP DESC;
--UNU_RECEIPTS_NOT_MOVED
--Check to see if Receipts eligible for interfacing to AM have MOVED or not
SELECT BUSINESS_UNIT, MOVE_STAT_AM, COUNT(1)
FROM PS_RECV_LN_SHIP 
WHERE BUSINESS_UNIT LIKE '6%'
AND MOVE_STAT_AM <> 'N'
GROUP BY BUSINESS_UNIT, MOVE_STAT_AM
ORDER BY 1,2,3;
--Report on Pending Receipts
SELECT * FROM PS_RECV_LN_SHIP WHERE BUSINESS_UNIT LIKE '6%' AND MOVE_STAT_AM = 'P' ORDER BY RECEIPT_DTTM DESC, BUSINESS_UNIT, RECEIVER_ID;
--UNU_REC_ACCRUAL_ENTRY
SELECT A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, B.RECEIPT_DT, A.DST_ACCT_TYPE, A.ACCOUNTING_PERIOD, A.FISCAL_YEAR,
            A.QTY_DS_ACCPT_SUOM, A.QTY_DS_ACCPT_VUOM, A.QTY_PO, A.BUSINESS_UNIT_PO, A.PO_ID, A.LINE_NBR, A.SCHED_NBR, A.PO_DIST_LINE_NUM,
            A.MONETARY_AMOUNT, A.GL_DISTRIB_STATUS, A.JOURNAL_ID, A.BUDGET_LINE_STATUS, A.ACCOUNTING_DT, A.BUDGET_DT, BUDGET_HDR_STATUS, 
            A.ACCOUNT, A.DEPTID, A.FUND_CODE, A.OPERATING_UNIT, A.PROJECT_ID, A.ACTIVITY_ID, A.CHARTFIELD2, A.FOREIGN_AMOUNT, A.FOREIGN_CURRENCY,
            C.CANCEL_STATUS, B.OPRID
FROM PS_RECV_LN_ACCTG A, PS_RECV_HDR B, PS_PO_LINE_SHIP C
WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT
     AND A.RECEIVER_ID = B.RECEIVER_ID
     AND A.BUSINESS_UNIT LIKE '6%'
     AND A.BUSINESS_UNIT_PO = C.BUSINESS_UNIT (+)
     AND A.PO_ID = C.PO_ID (+)
     AND A.LINE_NBR = C.LINE_NBR (+)
     AND A.SCHED_NBR = C.SCHED_NBR (+)
     AND A.DST_ACCT_TYPE <> 'ENR' -- 'Reserve for Encumbrances'
     AND A.BUSINESS_UNIT_GL = 'UNUNI'
     --AND A.ACCOUNTING_DT = TO_DATE(:1,'YYYY-MM-DD')
ORDER BY A.ACCOUNTING_DT DESC, A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, B.RECEIPT_DT;
--Find Receipts in Reporting Table which have rows in more than one accrual period
--Version 2
--Added more columns and changed WHERE criteria
SELECT 'RPT_RAC_DUP', A.PROCESS_INSTANCE, A.ACCRUAL_YEAR, A.ACCR_PERIOD, A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.DST_ACCT_TYPE,
       A.ORIGINAL_TRANS, A.DT_TIMESTAMP, A.BUSINESS_UNIT_GL, A.BUSINESS_UNIT_PO, A.PO_ID, A.SCHED_NBR, A.LINE_NBR, A.PO_DIST_LINE_NUM, A.ACCOUNTING_DT, A.MONETARY_AMOUNT,
       B.PROCESS_INSTANCE, B.ACCRUAL_YEAR, B.ACCR_PERIOD, B.BUSINESS_UNIT, B.RECEIVER_ID, B.RECV_LN_NBR, B.RECV_SHIP_SEQ_NBR, B.DISTRIB_LINE_NUM, B.DST_ACCT_TYPE,
       B.ORIGINAL_TRANS, B.DT_TIMESTAMP, B.BUSINESS_UNIT_GL, B.BUSINESS_UNIT_PO, B.PO_ID, B.SCHED_NBR, B.LINE_NBR, B.PO_DIST_LINE_NUM, B.ACCOUNTING_DT, B.MONETARY_AMOUNT
FROM PS_RECV_LN_RPT A, PS_RECV_LN_RPT B
WHERE A.PROCESS_INSTANCE <> B.PROCESS_INSTANCE
    AND A.ACCRUAL_YEAR = B.ACCRUAL_YEAR 
    AND A.ACCR_PERIOD <> B.ACCR_PERIOD 
    AND A.BUSINESS_UNIT = B.BUSINESS_UNIT
    AND A.RECEIVER_ID = B.RECEIVER_ID
    AND A.RECV_LN_NBR = B.RECV_LN_NBR
    AND A.RECV_SHIP_SEQ_NBR = B.RECV_SHIP_SEQ_NBR
    AND A.DISTRIB_LINE_NUM = B.DISTRIB_LINE_NUM
    AND A.DST_ACCT_TYPE = B.DST_ACCT_TYPE
    AND A.APPL_JRNL_ID = B.APPL_JRNL_ID
    AND A.ORIGINAL_TRANS = B.ORIGINAL_TRANS 
    AND A.DT_TIMESTAMP <> B.DT_TIMESTAMP
    AND A.DST_ACCT_TYPE = 'RAC'
    --AND A.BUSINESS_UNIT LIKE '6%'
    AND A.BUSINESS_UNIT_GL = 'UNUNI'
    --AND A.RECEIVER_ID = '0000001783'
ORDER BY A.ACCRUAL_YEAR, A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.ACCR_PERIOD;
--UNU_AM_RCVR_NOT_MOVED
--Version 2
--query now checks for Asset Items
SELECT 'UNU_AM_RCVR_NOT_MOVED_V2', A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.DISTRIB_SEQ_NUM, A.ACTUAL_COST,
            A.BUSINESS_UNIT_AM, A.COST, A.CURRENCY_CD, A.DESCR, TO_CHAR(CAST((A.DTTM_STAMP) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF') AS DTTM_STAMP, A.PROFILE_ID, A.QUANTITY, 
            A.SERIAL_ID, A.TAG_NUMBER, C.BUSINESS_UNIT_PO, C.PO_ID, C.LINE_NBR, C.SCHED_NBR, C.CATEGORY_ID, C.DESCR254_MIXED, C.DUE_DT, C.INV_ITEM_ID, 
            C.MERCH_AMT_BSE, C.OPRID, C.QTY_LN_ASSET_SUOM, C.QTY_SH_ACCPT_VUOM, C.QTY_SH_NETRCV_VUOM,
            A.RECV_AM_STATUS, X1.XLATLONGNAME AS RECV_AM_STATUS_DESCR, C.RECV_SHIP_STATUS, X2.XLATLONGNAME AS RECV_SHIP_STATUS_DESCR, 
            C.MOVE_STAT_AM, X3.XLATLONGNAME AS MOVE_STAT_AM_DESCR, A.FINANCIAL_ASSET_SW
FROM PS_RECV_LN_ASSET A, PS_RECV_LN_SHIP C, PSXLATITEM X1, PSXLATITEM X2, PSXLATITEM X3
WHERE A.BUSINESS_UNIT = C.BUSINESS_UNIT
    AND A.RECEIVER_ID = C.RECEIVER_ID
    AND A.RECV_LN_NBR = C.RECV_LN_NBR
    AND A.RECV_SHIP_SEQ_NBR = C.RECV_SHIP_SEQ_NBR
    --XLAT X1
    AND X1.FIELDNAME = 'RECV_AM_STATUS'
    AND X1.FIELDVALUE = A.RECV_AM_STATUS
    --XLAT X2
    AND X2.FIELDNAME = 'RECV_SHIP_STATUS'
    AND X2.FIELDVALUE = C.RECV_SHIP_STATUS
    --XLAT X3
    AND X3.FIELDNAME = 'MOVE_STAT_AM'
    AND X3.FIELDVALUE = C.MOVE_STAT_AM
    AND A.BUSINESS_UNIT LIKE '6%'
    AND A.RECV_AM_STATUS NOT IN ('X')
    AND C.RECV_SHIP_STATUS NOT IN ('X')
    AND C.MOVE_STAT_AM = 'P'
    AND SUBSTR(RTRIM(C.INV_ITEM_ID), -1, 1) = 'A'
ORDER BY 1, 2, 3, 4, 5, 6;
--Actual Receipt Accrual Version 2
--15SEPT2014
SELECT H.BUSINESS_UNIT AS BU_RECV, H.RECEIVER_ID, H.RECEIPT_DT, S.OPRID, H.MATCH_STATUS_RECV, S.RECV_LN_NBR, S.RECV_SHIP_SEQ_NBR, LD.DISTRIB_LINE_NUM, S.CURRENCY_CD, 
            S.MERCHANDISE_AMT, S.MERCH_AMT_BSE, S.MERCH_AMT_PO_BSE, S.BUSINESS_UNIT_PO AS BU_PO, S.PO_ID, L.LINE_NBR, D.SCHED_NBR, S.DISTRIB_MTHD_FLG,
            L.AMT_ONLY_FLG, D.DISTRIB_LINE_NUM AS PO_DISTRIB_LINE_NUM, G.CATEGORY_CD, G.DESCR, G.ACCOUNT AS CAT_ACCOUNT, L.INV_ITEM_ID, ITM.DESCR AS ITM_DESCR, L.DESCR254_MIXED, 
            D.QTY_PO AS POD_QTY_PO, D.MERCH_AMT_BSE AS PO_USD_AMT, D.MERCHANDISE_AMT AS PO_FOREIGN_AMT, D.CURRENCY_CD AS PO_DIST_CURR_CD,
            D.ACCOUNT AS PO_ACCT, D.OPERATING_UNIT AS PO_OP_UNIT, D.FUND_CODE AS PO_FUND, D.DEPTID AS PO_DEPT, D.PROJECT_ID AS PO_PRJ, D.ACTIVITY_ID AS PO_ACT, 
            D.CHARTFIELD2 AS PO_DONOR, 
            G.RECV_REQ, P.VENDOR_SETID, P.VENDOR_ID, V.NAME1, S.CONVERSION_RATE,
            LD.BUSINESS_UNIT_AM, LD.BUSINESS_UNIT_GL, LD.PROFILE_ID, LD.FINANCIAL_ASSET_SW, LD.RECV_DS_STATUS, LD.MERCHANDISE_AMT_PO, LD.LOCATION, LD.REQ_ID,
            D.QTY_PO "PO Quantity", S.QTY_LN_ASSET_SUOM "Quantity to be Asset Tracked", S.QTY_LN_INV_SUOM "Line Inv Qty", S.QTY_SH_ACCPT "Qty Accepted in Receipt UOM", 
            S.QTY_SH_ACCPT_SUOM "Accepted Quantity", S.QTY_SH_ACCPT_VUOM "Accept Quantity in Vendor UOM", S.QTY_SH_NETRCV_VUOM "Net Receipt Quantity", 
            S.QTY_SH_RECVD "Qty Received in Receipt UOM", S.QTY_SH_RECVD_SUOM "Receipt Quantity", S.QTY_SH_RECVD_VUOM "Receipt Quantity in Vendor UOM", 
            S.REJECT_ACTION, S.REJECT_REASON, S.RECEIPT_ALLOC_TYPE, S.RECEIPT_DTTM, S.RECEIPT_UM, S.RECEIVE_UOM, S.RECV_LN_MATCH_OPT, S.RECV_SHIP_STATUS, S.RECV_STOCK_UOM, 
            S.SERIAL_CONTROL, S.SERIAL_STATUS, S.SHIP_DATE_STATUS, S.SHIP_QTY_STATUS, S.UNIT_MEASURE_STD
FROM PS_RECV_HDR H, PS_PO_HDR P, PS_PO_LINE L, PS_RECV_LN_SHIP S, PS_PO_LINE_DISTRIB D, PS_SET_CNTRL_REC F, PS_ITM_CAT_TBL G, PS_RECV_LN_DISTRIB LD,
          PS_MASTER_ITEM_TBL ITM, PS_VENDOR V
WHERE H.BUSINESS_UNIT LIKE '6%'
   AND S.BUSINESS_UNIT = H.BUSINESS_UNIT
   AND S.RECEIVER_ID = H.RECEIVER_ID
   AND S.MATCH_LINE_FLG = 'Y' 
   AND S.RECV_LN_MATCH_OPT <> 'F' 
   AND S.PRODUCTION_ID = ' ' 
   AND S.BUSINESS_UNIT_PO = P.BUSINESS_UNIT 
   AND S.PO_ID = P.PO_ID 
   AND S.PO_ID <> ' ' 
   AND S.BUSINESS_UNIT_PO = L.BUSINESS_UNIT 
   AND S.PO_ID = L.PO_ID 
   AND S.LINE_NBR = L.LINE_NBR    
   AND S.BUSINESS_UNIT_PO = D.BUSINESS_UNIT 
   AND S.PO_ID = D.PO_ID 
   AND S.LINE_NBR = D.LINE_NBR
   --Added 10Mar2015
   AND S.SCHED_NBR = D.SCHED_NBR
   --End
   AND S.BUSINESS_UNIT = LD.BUSINESS_UNIT 
   AND S.RECEIVER_ID = LD.RECEIVER_ID 
   AND S.RECV_LN_NBR = LD.RECV_LN_NBR 
   AND S.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR
   --Added 10Mar2015
   AND LD.PO_DIST_LINE_NUM = D.DISTRIB_LINE_NUM
   --End
   AND F.SETCNTRLVALUE = S.BUSINESS_UNIT
   AND G.SETID = F.SETID
   AND G.CATEGORY_ID = S.CATEGORY_ID
   AND F.RECNAME = 'ITM_CAT_TBL'   
   AND G.EFFDT = (SELECT MAX(G_ED.EFFDT) FROM PS_ITM_CAT_TBL G_ED WHERE G.SETID = G_ED.SETID AND G.CATEGORY_TYPE = G_ED.CATEGORY_TYPE AND G.CATEGORY_CD = G_ED.CATEGORY_CD 
          AND G.CATEGORY_ID = G_ED.CATEGORY_ID AND G_ED.EFFDT <= SYSDATE)   
   AND L.ITM_SETID = ITM.SETID (+)
   AND L.INV_ITEM_ID = ITM.INV_ITEM_ID (+)
   AND P.VENDOR_SETID = V.SETID
   AND P.VENDOR_ID = V.VENDOR_ID     
   AND L.RECV_REQ = 'Y'
   AND S.MERCHANDISE_AMT <> 0 
   AND S.RECV_SHIP_STATUS IN ('O', 'R') 
   AND H.RECV_STATUS IN ('N', 'O', 'P','R','M') 
   AND P.MATCH_STATUS_PO NOT IN ('N')
   AND H.MATCH_STATUS_RECV <> 'M' 
   AND D.DST_ACCT_TYPE = 'DST'
   AND D.KK_CLOSE_FLAG <> 'Y'
   --AND NOT EXISTS (SELECT 'X' FROM PS_RECV_LN_ACCTG LN WHERE LN.BUSINESS_UNIT = LD.BUSINESS_UNIT AND LN.RECEIVER_ID = LD.RECEIVER_ID AND LN.RECV_LN_NBR = LD.RECV_LN_NBR AND LN.RECV_SHIP_SEQ_NBR = LD.RECV_SHIP_SEQ_NBR AND LN.DISTRIB_LINE_NUM = LD.DISTRIB_LINE_NUM)
   AND EXISTS (SELECT 'X' FROM PS_RECV_LN_SHP_MTH M WHERE S.BUSINESS_UNIT = M.BUSINESS_UNIT AND S.RECEIVER_ID  = M.RECEIVER_ID AND S.RECV_LN_NBR = M.RECV_LN_NBR AND S.RECV_SHIP_SEQ_NBR = M.RECV_SHIP_SEQ_NBR)
   AND NOT EXISTS (SELECT 'X' FROM PS_PO_LINE_SHIP LS WHERE LS.BUSINESS_UNIT = S.BUSINESS_UNIT_PO AND LS.PO_ID = S.PO_ID AND LS.LINE_NBR = S.LINE_NBR AND LS.SCHED_NBR = S.SCHED_NBR AND LS.MATCH_LINE_OPT = 'N')    
ORDER BY 1,2,3,4,5,D.LINE_NBR, D.SCHED_NBR, D.DISTRIB_LINE_NUM;
--PORC700
--Version 2
--Matches with online page "Accrual Accounting Entry"
SELECT C.BUSINESS_UNIT_GL, C.BUSINESS_UNIT, C.RECEIVER_ID, C.RECV_LN_NBR, C.RECV_SHIP_SEQ_NBR, C.DISTRIB_LINE_NUM, C.RECEIPT_DT, C.VENDOR_ID, D.NAME1, 
            C.ACCRUAL_YEAR, C.ACCR_PERIOD, 
            C.MERCHANDISE_AMT AS PURCHASE_AMT, NVL(ROUND((C.MERCHANDISE_AMT * C.RATE_MULT)/C.RATE_DIV, 2), 0) AS PURCH_AMT_BSE, 
            NVL(SUM(G.QTY_VCHR), 0) AS QTY_VCHR, NVL(SUM(G.MERCH_AMT_BSE), 0) AS AMOUNT_INVOICED, 
            --NVL(NVL(ROUND(SUM((C.MERCHANDISE_AMT * C.RATE_MULT)/C.RATE_DIV), 2), 0) - NVL(ROUND(SUM(G.MERCH_AMT_BSE), 2), 0), 0) AS AMT_NOT_INVOICED,            
            C.QTY_DS_ACCPT_VUOM, C.BUSINESS_UNIT_PO, C.PO_ID, C.LINE_NBR, C.SCHED_NBR, C.PO_DIST_LINE_NUM,
            C.ACCOUNT, C.OPERATING_UNIT, C.FUND_CODE, C.DEPTID, C.PROJECT_ID, C.CHARTFIELD2,
            C.MONETARY_AMOUNT, NVL(ROUND(C.FOREIGN_AMOUNT * E.CUR_EXCHNG_RT, 2), 0) AS MONETARY_AMT_LATEST, 
            C.CURRENCY_CD, C.FOREIGN_AMOUNT, C.FOREIGN_CURRENCY, C.QTY_PO, C.PRICE_PO, C.INV_ITEM_ID, C.RECEIPT_UM, C.DESCR254_MIXED, F.BASE_CURRENCY,
            C.RATE_MULT, C.RATE_DIV, DT_TIMESTAMP, C.CUR_EXCHNG_RT, C.EXCHNG_RT_INTR_BSE, NVL(ROUND(E.CUR_EXCHNG_RT, 4), 0) AS CURRENT_RATE
FROM PS_VENDOR D, PS_CUR_RT_TBL E, PS_BUS_UNIT_TBL_GL F, 
         ((PS_RECV_LN_RPT C LEFT OUTER JOIN PS_DISTRIB_LINE G ON G.BUSINESS_UNIT_RECV = C.BUSINESS_UNIT AND G.RECEIVER_ID = C.RECEIVER_ID 
                                                                                             AND G.RECV_LN_NBR = C.RECV_LN_NBR AND G.RECV_SHIP_SEQ_NBR = C.RECV_SHIP_SEQ_NBR 
                                                                                             AND G.DISTRIB_LINE_NUM  = C.DISTRIB_LINE_NUM AND G.BUSINESS_UNIT_PO = C.BUSINESS_UNIT_PO 
                                                                                             AND G.PO_ID = C.PO_ID AND G.LINE_NBR = C.LINE_NBR AND G.SCHED_NBR = C.SCHED_NBR 
                                                                                             AND G.PO_DIST_LINE_NUM = C.PO_DIST_LINE_NUM
                                                                                             AND NOT EXISTS (SELECT 'X' FROM PS_VOUCHER V WHERE V.BUSINESS_UNIT = G.BUSINESS_UNIT AND V.VOUCHER_ID = G.VOUCHER_ID 
                                                                                                                                                                               AND V.ENTRY_STATUS IN ('X','T')))
                                        LEFT OUTER JOIN PS_RECV_VCHR_MTCH J ON J.BUSINESS_UNIT = G.BUSINESS_UNIT_RECV AND J.RECEIVER_ID = G.RECEIVER_ID 
                                                                                                     AND J.RECV_LN_NBR = G.RECV_LN_NBR AND J.RECV_SHIP_SEQ_NBR = G.RECV_SHIP_SEQ_NBR 
                                                                                                     AND J.BUSINESS_UNIT_PO = G.BUSINESS_UNIT_PO AND J.PO_ID = G.PO_ID AND J.LINE_NBR = G.LINE_NBR 
                                                                                                     AND J.SCHED_NBR = G.SCHED_NBR AND J.BUSINESS_UNIT_AP = G.BUSINESS_UNIT 
                                                                                                     AND J.VOUCHER_ID = G.VOUCHER_ID AND J.VOUCHER_LINE_NUM = G.VOUCHER_LINE_NUM)
WHERE C.VENDOR_SETID = D.SETID
    AND C.VENDOR_ID = D.VENDOR_ID
    AND C.BUSINESS_UNIT_GL = F.BUSINESS_UNIT
    --AND E.FROM_CUR = C.CURRENCY_CD
    AND E.FROM_CUR = C.FOREIGN_CURRENCY
    AND E.TO_CUR = F.BASE_CURRENCY
    AND E.CUR_RT_TYPE = C.RT_TYPE
    AND E.EFFDT = (SELECT MAX(E1.EFFDT) FROM PS_CUR_RT_TBL E1 WHERE E.FROM_CUR = E1.FROM_CUR AND E.TO_CUR = E1.TO_CUR AND E.CUR_RT_TYPE = E1.CUR_RT_TYPE 
                                                                                                            --AND E1.EFFDT <= C.RECEIPT_DT
                                                                                                            AND E1.EFFDT <= SYSDATE)
    AND E.EFF_STATUS = 'A'
    AND C.DST_ACCT_TYPE = 'DST'
    AND D.SETID = 'UNUNI'
    --AND D.VENDOR_ID = '0000000736'
GROUP BY C.BUSINESS_UNIT_GL, C.BUSINESS_UNIT, C.RECEIVER_ID, C.RECV_LN_NBR, C.RECV_SHIP_SEQ_NBR, C.DISTRIB_LINE_NUM, C.RECEIPT_DT, C.VENDOR_ID, D.NAME1, 
               C.ACCRUAL_YEAR, C.ACCR_PERIOD, 
               C.MERCHANDISE_AMT, NVL(ROUND((C.MERCHANDISE_AMT * C.RATE_MULT)/C.RATE_DIV, 2), 0),
               C.QTY_DS_ACCPT_VUOM, C.BUSINESS_UNIT_PO, C.PO_ID, C.LINE_NBR, C.SCHED_NBR, C.PO_DIST_LINE_NUM,
               C.ACCOUNT, C.OPERATING_UNIT, C.FUND_CODE, C.DEPTID, C.PROJECT_ID, C.CHARTFIELD2,
               C.MONETARY_AMOUNT, C.CURRENCY_CD, C.FOREIGN_AMOUNT, C.FOREIGN_CURRENCY, C.MONETARY_AMT_VCHR,  
               C.BUSINESS_UNIT_AM, C.QTY_PO, C.PRICE_PO, C.INV_ITEM_ID, C.RECEIPT_UM, C.DESCR254_MIXED, F.BASE_CURRENCY,
               C.RATE_MULT, C.RATE_DIV, DT_TIMESTAMP, C.CUR_EXCHNG_RT, C.EXCHNG_RT_INTR_BSE, E.CUR_EXCHNG_RT
ORDER BY 2,3,4,5,6;
--PO/AM Reconciliation
--FSCM 9.2
--AM_PO_RCVR_RECONCILE
SELECT C.BUSINESS_UNIT_PO, C.PO_ID, C.LINE_NBR, C.SCHED_NBR, C.PO_DIST_LINE_NUM, B.BUSINESS_UNIT, B.RECEIVER_ID, B.RECV_LN_NBR, B.RECV_SHIP_SEQ_NBR, B.DISTRIB_LINE_NUM, 
            B.DISTRIB_SEQ_NUM, B.RECV_AM_STATUS, B.BUSINESS_UNIT_AM, B.ASSET_ID, A.RECEIPT_DT, D.DESCR254_MIXED 
FROM PS_RECV_HDR A, PS_RECV_LN_ASSET B, PS_RECV_LN_DISTRIB C, PS_RECV_LN_SHIP D 
WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT 
    AND A.RECEIVER_ID = B.RECEIVER_ID 
    AND C.BUSINESS_UNIT = B.BUSINESS_UNIT 
    AND C.RECEIVER_ID = B.RECEIVER_ID 
    AND C.RECV_LN_NBR = B.RECV_LN_NBR 
    AND C.RECV_SHIP_SEQ_NBR = B.RECV_SHIP_SEQ_NBR 
    AND C.DISTRIB_LINE_NUM = B.DISTRIB_LINE_NUM 
    AND D.BUSINESS_UNIT = C.BUSINESS_UNIT 
    AND D.RECEIVER_ID = C.RECEIVER_ID 
    AND D.RECV_LN_NBR = C.RECV_LN_NBR 
    AND D.RECV_SHIP_SEQ_NBR = C.RECV_SHIP_SEQ_NBR 
    AND B.BUSINESS_UNIT_AM <> ' ' 
    AND B.PROFILE_ID <> ' ' 
    AND B.RECV_AM_STATUS IN ('M', 'O', 'R')
    AND A.BUSINESS_UNIT LIKE '6%'
    AND A.RECEIPT_DT BETWEEN TO_DATE('2014-01-01','YYYY-MM-DD') AND TO_DATE('2015-12-31','YYYY-MM-DD')
    AND NOT EXISTS (SELECT 'X' FROM PS_ASSET_ACQ_DET D WHERE D.BUSINESS_UNIT_PO = C.BUSINESS_UNIT_PO AND D.PO_ID = C.PO_ID AND D.PO_LINE_NBR = C.LINE_NBR 
                                AND D.PO_DIST_LINE_NUM = C.PO_DIST_LINE_NUM AND D.SCHED_NBR = C.SCHED_NBR AND D.BUSINESS_UNIT_RECV = B.BUSINESS_UNIT AND D.RECEIVER_ID = B.RECEIVER_ID 
                                AND D.RECV_LN_NBR = B.RECV_LN_NBR AND D.RECV_SHIP_SEQ_NBR = B.RECV_SHIP_SEQ_NBR AND D.RECV_DIST_LINE_NUM = B.DISTRIB_LINE_NUM 
                                AND D.DISTRIB_SEQ_NUM = B.DISTRIB_SEQ_NUM AND D.SYSTEM_SOURCE = 'PPO')
ORDER BY C.BUSINESS_UNIT_PO, C.PO_ID, C.LINE_NBR, C.SCHED_NBR, C.PO_DIST_LINE_NUM, B.BUSINESS_UNIT, B.RECEIVER_ID, B.RECV_LN_NBR, B.RECV_SHIP_SEQ_NBR, B.DISTRIB_LINE_NUM, 
                B.DISTRIB_SEQ_NUM;
--Receipt Accounting Entries which are ready for Journal Generation
SELECT A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.DST_ACCT_TYPE, A.APPL_JRNL_ID, A.ACCOUNTING_PERIOD, A.FISCAL_YEAR, A.ORIGINAL_TRANS, A.DT_TIMESTAMP, 
       A.ACCOUNT, A.ALTACCT, A.DEPTID, A.BUSINESS_UNIT_GL, A.MERCHANDISE_AMT, A.QTY_DS_ACCPT_SUOM, A.QTY_DS_ACCPT_VUOM, A.QTY_PO, A.BUSINESS_UNIT_PO, A.PO_ID, A.PO_RELEASE_ID, A.SCHED_NBR, A.LINE_NBR, 
       A.PO_DIST_LINE_NUM, A.STATISTICS_CODE, A.STATISTIC_AMOUNT, A.LEDGER_GROUP, A.ACCOUNTING_DT, A.JOURNAL_ID, A.JOURNAL_DATE, A.UNPOST_SEQ, A.CURRENCY_CD, A.MONETARY_AMOUNT, A.FOREIGN_AMOUNT, 
       A.OPEN_ITEM_STATUS, A.JRNL_LINE_STATUS, A.RT_TYPE, A.RATE_MULT, A.RATE_DIV, A.FOREIGN_CURRENCY, A.JOURNAL_LINE_DATE, A.JRNL_LN_REF, A.LEDGER, A.MONETARY_AMT_VCHR, A.GL_DISTRIB_STATUS, A.BASE_CURRENCY, 
       A.PROCESS_INSTANCE , A.JOURNAL_LINE , A.PROJECT_ID , A.CANCEL_FLAG , A.ENTRY_EVENT , A.NEXT_PRD_REVERSAL , A.BUDGET_DT , A.BUDGET_LINE_STATUS , 
       A.EE_PROC_STATUS , A.BUSINESS_UNIT_PC , A.ACTIVITY_ID , A.ANALYSIS_TYPE , A.RESOURCE_TYPE , A.RESOURCE_CATEGORY , A.RESOURCE_SUB_CAT 
FROM PS_RECV_LN_ACCTG A 
WHERE NOT EXISTS (SELECT 'X' FROM PS_RECV_LN_ACCTG B WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT AND A.RECEIVER_ID = B.RECEIVER_ID AND A.RECV_LN_NBR = B.RECV_LN_NBR 
                    AND A.RECV_SHIP_SEQ_NBR = B.RECV_SHIP_SEQ_NBR AND A.DISTRIB_LINE_NUM = B.DISTRIB_LINE_NUM AND A.APPL_JRNL_ID = B.APPL_JRNL_ID 
                    AND A.ACCOUNTING_PERIOD = B.ACCOUNTING_PERIOD AND A.FISCAL_YEAR = B.FISCAL_YEAR AND B.BUDGET_LINE_STATUS <> 'V' AND B.BUDGET_LINE_STATUS <> 'W'
                    )
      AND A.BUSINESS_UNIT_GL = 'UNUNI'
ORDER BY A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.DST_ACCT_TYPE;
--UNU RA Journals
SELECT DESCR, A.* FROM PS_JRNL_HEADER A WHERE BUSINESS_UNIT = 'UNUNI' AND SOURCE = 'PO' ORDER BY BUSINESS_UNIT, DTTM_STAMP_SEC DESC, FISCAL_YEAR, ACCOUNTING_PERIOD;
--UNU RA Journal Account Details
SELECT DISTINCT HDR.JOURNAL_ID, HDR.DESCR, LN.ACCOUNT 
FROM PS_JRNL_HEADER HDR, PS_JRNL_LN LN 
WHERE LN.BUSINESS_UNIT = HDR.BUSINESS_UNIT
    AND LN.JOURNAL_ID = HDR.JOURNAL_ID
    AND LN.JOURNAL_DATE = HDR.JOURNAL_DATE
    AND LN.UNPOST_SEQ = HDR.UNPOST_SEQ
    AND HDR.BUSINESS_UNIT = 'UNUNI'
    AND HDR.SOURCE = 'PO' 
ORDER BY 1,3;
--RA Accounting Entries Status
SELECT BUSINESS_UNIT, BUDGET_LINE_STATUS, DST_ACCT_TYPE, FISCAL_YEAR, GL_DISTRIB_STATUS, COUNT(1) 
FROM PS_RECV_LN_ACCTG A 
WHERE BUSINESS_UNIT_GL = 'UNUNI' 
GROUP BY BUSINESS_UNIT, BUDGET_LINE_STATUS, DST_ACCT_TYPE, FISCAL_YEAR, GL_DISTRIB_STATUS
ORDER BY FISCAL_YEAR DESC, BUSINESS_UNIT, BUDGET_LINE_STATUS, DST_ACCT_TYPE;
--PO_RECVPUSH selection SQL
SELECT S.BUSINESS_UNIT, S.RECEIVER_ID, H.RECV_STATUS, H.RECEIPT_DT, H.LAST_DTTM_UPDATE, S.RECV_LN_NBR, S.RECV_SHIP_SEQ_NBR, S.INV_ITEM_ID, S.AMT_ONLY_FLG, S.RECV_SHIP_STATUS, S.SERIAL_STATUS
FROM PS_RECV_HDR H, PS_RECV_LN_SHIP S  
WHERE H.PROCESS_INSTANCE = 0  
  AND H.RECV_STATUS <> 'X'  
  AND H.BUSINESS_UNIT LIKE '6%'  
  AND H.BUSINESS_UNIT = S.BUSINESS_UNIT  
  AND H.RECEIVER_ID = S.RECEIVER_ID  
  AND S.PROCESS_COMPLETE = 'N'
  AND TO_CHAR(((H.LAST_DTTM_UPDATE ) + (0)),'YYYY-MM-DD') >= '2000-01-01' 
  AND TO_CHAR(((H.LAST_DTTM_UPDATE ) + (-1)),'YYYY-MM-DD') <= TO_CHAR(SYSDATE, 'YYYY-MM-DD')
ORDER BY H.RECEIPT_DT DESC, H.LAST_DTTM_UPDATE DESC, S.BUSINESS_UNIT, S.RECEIVER_ID, S.RECV_LN_NBR, S.RECV_SHIP_SEQ_NBR;
