--COMBO Edit Checks
--Budgets CC Combo Edit Template
SELECT 'BUDGETS_CC_COMBO', A.* FROM PS_TSE_BD_KK_FLD A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY TSE_PROC_INSTANCE DESC;
--Combo Template for Journals
SELECT 'JOURNALS_COMBO', A.* FROM PS_TSE_JLNE_FLD A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY TSE_PROC_INSTANCE DESC;
--Voucher Edit Template
SELECT 'VCHR_EDIT_COMBO', A.* FROM PS_TSE_ACCTLN_FLD A WHERE BUSINESS_UNIT LIKE '6%' ORDER BY TSE_PROC_INSTANCE DESC;
--AR Combo Edit Template
SELECT 'AR_EDIT_COMBO', A.* FROM PS_TSE_AR_LN_FLD A WHERE (GROUP_BU LIKE '6%' OR BUSINESS_UNIT LIKE '6%') ORDER BY TSE_PROC_INSTANCE DESC;
--Combo Template for Billing
SELECT 'BILLING_COMBO', A.* FROM PS_TSE_BICOMBO_FLD A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY TSE_PROC_INSTANCE DESC;
--Template for F&A Accounting
SELECT 'FnA_ACCTG_COMBO', A.* FROM PS_TSE_GM_LINE_FLD A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY TSE_PROC_INSTANCE DESC;
--Purchase Order Batch Creation
SELECT 'PO_BATCH_CREATION', A.* FROM PS_TSE_PO_LN_FLD A WHERE BUSINESS_UNIT LIKE '6%' ORDER BY TSE_PROC_INSTANCE DESC;
--Template for Projects Acctg
SELECT 'PROJECT_ACCTG', A.* FROM PS_TSE_PC_LINE_FLD A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY TSE_PROC_INSTANCE DESC;
--Projects Interface Template
SELECT 'PROJECT_INTFC', A.* FROM PS_TSE_PC_LINE_FLD A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY TSE_PROC_INSTANCE DESC;
--Contract Transactions
SELECT 'CONTRACTS', A.* FROM PS_TSE_CA_LINE_FLD A ORDER BY TSE_PROC_INSTANCE DESC;
--Requisition Batch Creation
SELECT 'REQ_BATCH_CREATION', A.* FROM PS_TSE_REQ_LN_FLD A ORDER BY TSE_PROC_INSTANCE DESC;
