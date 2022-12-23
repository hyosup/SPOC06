CLASS lhc_SOLIST DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR solist RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE solist.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE solist.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE solist.

    METHODS read FOR READ
      IMPORTING keys FOR READ solist RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK solist.

    METHODS rba_Items FOR READ
      IMPORTING keys_rba FOR READ solist\_Items FULL result_requested RESULT result LINK association_links.

    METHODS rba_Status FOR READ
      IMPORTING keys_rba FOR READ solist\_Status FULL result_requested RESULT result LINK association_links.

    METHODS rejectAll FOR MODIFY
      IMPORTING keys FOR ACTION solist~rejectAll. " RESULT et_result.

    METHODS rePricing FOR MODIFY
      IMPORTING keys FOR ACTION solist~rePricing. " RESULT et_result.

ENDCLASS.


CLASS lhc_SOLIST IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.

*    BREAK-POINT.

    SELECT FROM zspoc06_open_so_list
      FIELDS *
      FOR ALL ENTRIES IN @keys
      WHERE SalesOrderNumber = @keys-SalesOrderNumber
      INTO CORRESPONDING FIELDS OF TABLE @result.


  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Items.

    data: header type table for READ RESULT zspoc06_open_so_list\\solist.



    me->read(
      EXPORTING
        keys     = conv #( keys_rba )
      CHANGING
        result   = header
    ).

    SELECT FROM zspoc06_so_item
      FIELDS *
      FOR ALL ENTRIES IN @HEADER
      WHERE vbeln = @HEADER-SalesOrderNumber
      INTO CORRESPONDING FIELDS OF TABLE @result.


  ENDMETHOD.

  METHOD rba_Status.
  ENDMETHOD.

  METHOD rejectAll.

    READ ENTITIES OF zspoc06_open_so_list IN LOCAL MODE
      ENTITY solist
      ALL FIELDS WITH CORRESPONDING #(  keys  )
      RESULT DATA(HEADER).

    READ ENTITIES OF zspoc06_open_so_list IN LOCAL MODE
      ENTITY solist BY \_Items
      ALL FIELDS WITH CORRESPONDING #(  keys  )
      RESULT DATA(ITEM).


    DATA : lv_msg TYPE char100,
           lv_type TYPE c.

    DATA : lt_header TYPE TABLE OF zpoc06_so_header,
           lt_item TYPE TABLE OF zpoc06_so_item,
           lt_return TYPE TABLE OF BAPIRET2.

    DATA: lv_sddoc TYPE bapivbeln-vbeln,
          lv_prcdt TYPE bapisdh1-price_date,
          lv_abgru TYPE abgru.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>) INDEX 1.

    lv_prcdt = <key>-%param-pricingdate.
    lv_abgru = <key>-%param-rejectreason.

    CLEAR: lt_header.

    LOOP AT header INTO DATA(ls_header).
      lt_header = VALUE #(
                    BASE lt_header (
                      vbeln = ls_header-SalesOrderNumber
                      prsdt = lv_prcdt
                    )
                  ).
    ENDLOOP.

    CLEAR: lt_item.

    LOOP AT item INTO DATA(ls_item).
      lt_item = VALUE #(
                BASE lt_item (
                  vbeln = ls_header-SalesOrderNumber
                  posnr = ls_item-posnr
                  reason = lv_abgru
                )
              ).
    ENDLOOP.

    CALL FUNCTION 'ZSPOC06_SO_CHANGE' DESTINATION 'NONE' " DESTINATION 'NONE'이 없으면 UPDATE TASK덤프가 떨어짐
      EXPORTING
        i_gubun = '2'
      IMPORTING
        e_msg = lv_msg
        e_type = lv_type
      TABLES
        it_header = lt_header
        it_item = lt_item
        et_return = lt_return
        .

      APPEND INITIAL LINE TO reported-solist ASSIGNING FIELD-SYMBOL(<fs_reported>).

*      DATA(lo_msg02) = NEW zspoc06_cm_01(
*                            msg      = CONV #( lv_msg )
*                            severity = if_abap_behv_message=>severity-success
*                          ).
       DATA(input_msg) = CONV char200( lv_msg ).

        DATA(lv_string1) = input_msg(50).
        DATA(lv_string2) = input_msg+50(50).
        DATA(lv_string3) = input_msg+100(50).
        DATA(lv_string4) = input_msg+150(50).

      IF lt_return[] IS NOT INITIAL.

" cbo message
*        DATA(ls_return) = VALUE BAPIRET2(
*                            id = 'ZSPOC06_MSG'
*                            number = '000'
*                            message_v1 = '테스트'
*                            message_v2 = '메시지입니다.'
*                          ).


" bapi standard message
        DATA(ls_return) = lt_return[ 1 ].

        DATA(lo_msg02) = NEW zspoc06_cm_01(
                            bapi = ls_return
                            severity = if_abap_behv_message=>severity-success
*                            attr1    = CONV #( lv_string1 )
*                            attr2    = CONV #( lv_string2 )
*                            attr3    = CONV #( lv_string3 )
*                            attr4    = CONV #( lv_string4 )
                          ).

      ENDIF.

*      DATA(lo_msg02) = NEW zspoc06_cm_01(
*                            textid   = lv_textid
*                            severity = if_abap_behv_message=>severity-success
**                            attr1    = CONV #( lv_string1 )
**                            attr2    = CONV #( lv_string2 )
**                            attr3    = CONV #( lv_string3 )
**                            attr4    = CONV #( lv_string4 )
*                          ).

      <fs_reported>-%msg = lo_msg02.
*      <fs_reported>-%element- = if_abap_behv=>mk-on.
      <fs_reported>-%action-rejectall = if_abap_behv=>mk-on.

*    break-point.

  ENDMETHOD.

  METHOD rePricing.

    DATA: lv_sddoc TYPE bapivbeln-vbeln,
          lv_prcdt TYPE bapisdh1-price_date.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<key>) INDEX 1.

    lv_sddoc = <key>-%key-SalesOrderNumber.
    lv_prcdt = <key>-%param-pricingdate.

*& CALL BAPI with RFC
    DATA : lv_msg TYPE char100,
           lv_type TYPE c.

    DATA : lt_header TYPE TABLE OF zpoc06_so_header,
           lt_item TYPE TABLE OF zpoc06_so_item,
           lt_return TYPE TABLE OF bapiret2.

    lt_header = VALUE #(
                  BASE lt_header (
                    vbeln = lv_sddoc
                    prsdt = lv_prcdt
                  )
                ).

    CALL FUNCTION 'ZSPOC06_SO_CHANGE' DESTINATION 'NONE' " DESTINATION 'NONE'이 없으면 UPDATE TASK덤프가 떨어짐
      EXPORTING
        i_gubun = '1'
      IMPORTING
        e_msg = lv_msg
        e_type = lv_type
      TABLES
        it_header = lt_header
        it_item = lt_item
        et_return = lt_return
        .

      APPEND INITIAL LINE TO reported-solist ASSIGNING FIELD-SYMBOL(<fs_reported>).

      DATA(input_msg) = CONV char200( lv_msg ).

        DATA(lv_string1) = input_msg(50).
        DATA(lv_string2) = input_msg+50(50).
        DATA(lv_string3) = input_msg+100(50).
        DATA(lv_string4) = input_msg+150(50).

*          DATA(lo_msg02) = NEW zspoc06_cm_01(
*                            textid   = zspoc06_cm_01=>msg_param
*                            severity = if_abap_behv_message=>severity-success
*                            attr1    = CONV #( lv_string1 )
*                            attr2    = CONV #( lv_string2 )
*                            attr3    = CONV #( lv_string3 )
*                            attr4    = CONV #( lv_string4 )
*                          ).

      IF lt_return[] IS NOT INITIAL.

" cbo message
        DATA(ls_return) = VALUE BAPIRET2(
                            id = 'ZSPOC06_MSG'
                            number = '000'
                            message_v1 = 'Success Process.'
                          ).

" bapi standard message
*        DATA(ls_return) = lt_return[ 1 ].

        DATA(lo_msg02) = NEW zspoc06_cm_01(
                            bapi = ls_return
                            severity = if_abap_behv_message=>severity-success
                          ).

      ENDIF.


          <fs_reported>-%msg = lo_msg02.
*          <fs_reported>-%element- = if_abap_behv=>mk-on.
          <fs_reported>-%action-rePricing = if_abap_behv=>mk-on.

  ENDMETHOD.
ENDCLASS.
