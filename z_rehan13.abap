*&---------------------------------------------------------------------*
*& Report Z_REHAN12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REHAN12.

SELECTION-SCREEN BEGIN OF BLOCK B2 WITH FRAME TITLE TITLE02 .
PARAMETERS : p_name TYPE Char30,
             P_Cont TYPE Char10.
SELECTION-SCREEN END OF BLOCK B2.

SELECTION-SCREEN BEGIN OF BLOCK B3 WITH FRAME TITLE TITLE03.
  PARAMETERS : P_DATE TYPE D DEFAULT sy-datum.
    PARAMETERS : P_time TYPE t DEFAULT sy-uzeit.
SELECTION-SCREEN END OF BLOCK B3.

SELECTION-SCREEN BEGIN OF BLOCK B4 WITH FRAME TITLE TITLE04.
  PARAMETERS : P_PDT1 TYPE C AS LISTBOX VISIBLE LENGTH 20 DEFAULT 1.
    PARAMETERS : P_PDT2 TYPE I DEFAULT 1.
SELECTION-SCREEN END OF BLOCK B4.

* # INITIALIZE TITLES OF BLOCKS
INITIALIZATION.
TITLE02 = 'Personal Details'.
TITLE03 = 'Date and Time'.
TITLE04 = 'Product Selection'.

* # INITIALIZE LIST ITEMS
INITIALIZATION.
  " Fill the dropdown list with values
  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = 'P_PDT1'   " Parameter name
      values = VALUE vrm_values(
                  ( key = '1' text = '18K gold' )
                  ( key = '2' text = '22K gold' )
                  ( key = '3' text = '24K gold' )
               ).

*---------------- Show Output ----------------*

START-OF-SELECTION.

  DATA: lv_date TYPE string,
        lv_time TYPE string.
  DATA RESULT_name  TYPE Char20.
  DATA RESULT_cost  TYPE I.

  " Convert date and time format
  lv_date = p_date+6(2) && '-' && p_date+4(2) && '-' && p_date+0(4).
  lv_time = p_time+0(2) && ':' && p_time+2(2) && ':' && p_time+4(2).

  CASE P_PDT1.
    WHEN '1'.
      RESULT_cost = 9028 * P_PDT2.
      RESULT_name = 'Gold 18K'.
    WHEN '2'.
      RESULT_cost = 11051 * P_PDT2.
      RESULT_name = 'Gold 22K'.
    WHEN '3'.
      RESULT_cost = 12038 * P_PDT2.
      RESULT_name = 'Gold 24K'.
  ENDCASE.

  WRITE: / 'Your Order Details:',
         / '_________________________________________________',
         / 'Customer Name: ', p_name,
         / 'Customer Number: ', p_cont,
         / 'Order Date: ', lv_date,
         / 'Order Time: ', lv_time,
         / '_________________________________________________',
         / 'Items:',
         / '_________________________________________________'.

  WRITE : / 'Item Name' , 15
            'Item Quantity' , 40
            'Item Cost',
          / '--------------------------------------------------',
          / RESULT_name, 15
            '(Gram)' , P_PDT2 , 40
            RESULT_cost,
          / '--------------------------------------------------'.