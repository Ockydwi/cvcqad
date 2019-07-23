/************Program Information************************
     Copyright : (C) 2019 PT. QAD ASIA INDONESIA
   Description : RM & PM consumption report(--FULL CUSTOM--)
                Used by: PT. Widatra Bhakti
          Type : Main program
        Subprogram : 
           include : 
Files Struktur :                
       Purpose : 
  Version & UI : .Net UI (REPORTING FRAMEWORK)
    Created BY : 06/19/19 BY LGH
      Modified : 


***************************************************************/ 

{mfdeclre.i}
{gplabel.i}
{com/qad/shell/report/dsReportRequest.i}
{com/qad/shell/report/ReportConstants.i}

/*======temp-table========*/
DEFINE TEMP-TABLE tt_headerwo
FIELD wo_nbr LIKE wo_mstr.wo_nbr
FIELD wo_lot LIKE wo_mstr.wo_lot
FIELD nodoc  AS CHARACTER FORMAT "x(20)"
FIELD tglber AS DATE      FORMAT "99/99/99"
FIELD refer  AS CHARACTER FORMAT "x(20)"
FIELD prodname LIKE pt_desc1
FIELD prodcode LIKE wo_part
FIELD qtyrcpt  LIKE wo_qty_comp
FIELD qtyOrd     LIKE wo_qty_ord
FIELD  wormks    LIKE wo_rmks
.

DEFINE TEMP-TABLE tt_detailwo1
FIELD wodnbr LIKE wod_nbr
FIELD wodlot LIKE wod_lot
FIELD matName LIKE pt_desc1
FIELD matCode LIKE wod_part
FIELD um            LIKE pt_um
FIELD ctrlNo    LIKE tr_serial
FIELD qtyReq    LIKE wod_qty_req
FIELD qtyReal LIKE wod_qty_iss
.

DEFINE TEMP-TABLE tt_detailwo2
FIELD wodnbr LIKE wod_nbr
FIELD wodlot LIKE wod_lot
FIELD matName LIKE pt_desc1
FIELD matCode LIKE wod_part
FIELD um            LIKE pt_um
FIELD ctrlNo    LIKE tr_serial
FIELD qtyReq    LIKE wod_qty_req
FIELD qtyReal LIKE wod_qty_iss
.
/*=end temp-table===*/

/*todo report table definition*/
DEFINE DATASET dsReportResults FOR tt_headerwo, tt_detailwo1, tt_detailwo2.

/*main block*/
 DEFINE INPUT PARAMETER runReport AS LOGICAL.
 DEFINE INPUT PARAMETER reportHandle AS HANDLE.
 DEFINE INPUT PARAMETER DATASET FOR dsReportRequest.
 DEFINE OUTPUT PARAMETER DATASET-HANDLE phReportResults.

 {com/qad/shell/report/reporting.i}

DEFINE VARIABLE bufferName AS CHARACTER NO-UNDO.
DEFINE VARIABLE vhDS AS HANDLE NO-UNDO .

/*todo empty temp-table*/
EMPTY TEMP-TABLE tt_headerwo NO-ERROR.
EMPTY TEMP-TABLE tt_detailwo1 NO-ERROR.
EMPTY TEMP-TABLE tt_detailwo2 NO-ERROR.

FOR FIRST ttReportRequest NO-LOCK:
/*run procedure to create temp table and appear on Report Resource Designer 
"Select Data Source"*/
   RUN FillMetaData.

   RUN MetaDataOverride.
   if runReport then do:
      /*run procedure for main logic and query from table system*/
      RUN RunReport
         (OUTPUT DATASET-HANDLE phReportResults).
   END.
END.

/*if table or field not appear on Report Resource Designer "Select Data Source",
 need to check procedure FillMetaData*/
PROCEDURE FillMetaData:

   bufferName = "tt_headerwo".
   run CreateBufferHeader in reportHandle 
   (bufferName, "Header WO").
   
   run CreateFieldForDBField in reportHandle (bufferName, "wo_mstr", "wo_nbr",
       TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE,
       "", "Between", "Constant", "", "Constant").  
       
   run CreateFieldForDBField in reportHandle (bufferName, "wo_mstr", "wo_lot",
       TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, 
       "", "Between", "Constant", "", "Constant").            
   
   {com/qad/shell/report/reports/createfield.i &aa = '"nodoc"'     &bb = '"NO. Document"' 
                  &cc = '"CHARACTER"' &dd = '"x(20)"'}
   {com/qad/shell/report/reports/createfield.i &aa = '"tglber"'    &bb = '"Tgl. Berlaku"' 
                  &cc = '"date"'      &dd = '"99/99/99"'}                 
   {com/qad/shell/report/reports/createfield.i &aa = '"refer"'     &bb = '"Referensi"' 
                  &cc = '"CHARACTER"' &dd = '"x(20)"'}
                  
   {com/qad/shell/report/reports/likefield.i &aa = '"prodName"' &bb = '"pt_mstr"' &cc = '"pt_desc1"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"prodCode"' &bb = '"wo_mstr"' &cc = '"wo_part"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"qtyRcpt"'  &bb = '"wo_mstr"' &cc = '"wo_qty_comp"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"qtyOrd"'   &bb = '"wo_mstr"' &cc = '"wo_qty_ord"'}
   {com/qad/shell/report/reports/likefield.i &aa = '"woRmks"'   &bb = '"wo_mstr"' &cc = '"wo_rmks"'}
   
   bufferName = "tt_detailwo1".
   run CreateBufferHeader in reportHandle 
   (bufferName, "Detail WO 1").
   
   {com/qad/shell/report/reports/likefield.i &aa = '"wodnbr"'  &bb = '"wod_det"' &cc = '"wod_nbr"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"wodlot"'  &bb = '"wod_det"' &cc = '"wod_lot"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"matName"' &bb = '"pt_mstr"' &cc = '"pt_desc1"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"matCode"' &bb = '"wod_det"' &cc = '"wod_part"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"um"'      &bb = '"pt_mstr"' &cc = '"pt_um"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"ctrlNo"'  &bb = '"tr_hist"' &cc = '"tr_serial"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"qtyReq"'  &bb = '"wod_det"' &cc = '"wod_qty_req"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"qtyReal"' &bb = '"wod_det"' &cc = '"wod_qty_iss"'} 
   
   bufferName = "tt_detailwo2".
   run CreateBufferHeader in reportHandle 
   (bufferName, "Detail WO 2").
   
   {com/qad/shell/report/reports/likefield.i &aa = '"wodnbr"'  &bb = '"wod_det"' &cc = '"wod_nbr"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"wodlot"'  &bb = '"wod_det"' &cc = '"wod_lot"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"matName"' &bb = '"pt_mstr"' &cc = '"pt_desc1"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"matCode"' &bb = '"wod_det"' &cc = '"wod_part"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"um"'      &bb = '"pt_mstr"' &cc = '"pt_um"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"ctrlNo"'  &bb = '"tr_hist"' &cc = '"tr_serial"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"qtyReq"'  &bb = '"wod_det"' &cc = '"wod_qty_req"'} 
   {com/qad/shell/report/reports/likefield.i &aa = '"qtyReal"' &bb = '"wod_det"' &cc = '"wod_qty_iss"'}    
   
END PROCEDURE.

PROCEDURE RunReport:
   DEFINE OUTPUT PARAMETER DATASET-HANDLE phReportResults.
   DEFINE VARIABLE queryString AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hWOQuery AS HANDLE NO-UNDO.
   DEFINE QUERY woQuery FOR wo_mstr /*, in_mstr, si_mstr*/.
   
   hWOQuery = QUERY woQuery:HANDLE.
   
   queryString = "For each wo_mstr no-lock where true and wo_domain = " 
               + QUOTER(global_domain).
   
   RUN FillQueryStringVariable IN reportHandle 
       (INPUT "tt_headerwo", INPUT "wo_nbr", INPUT-OUTPUT queryString).
       
   RUN FillQueryStringVariable IN reportHandle 
       (INPUT "tt_headerwo", INPUT "wo_lot", INPUT-OUTPUT queryString). 
       
   queryString = queryString + ":".
   
   hWOQuery:QUERY-PREPARE(queryString).
   hWOQuery:QUERY-OPEN().
   hWOQuery:GET-NEXT().
   REPEAT WHILE NOT hWOQuery:QUERY-OFF-END:   
   
   END.   
   hWOQuery:query-close(). /*wo_mstr*/
   
   phReportResults = dataset dsReportResults:handle.
   
END PROCEDURE.
