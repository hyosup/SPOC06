FUNCTION zspoc06_so_change.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_GUBUN) TYPE  CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(E_TYPE) TYPE  CHAR1
*"     VALUE(E_MSG) TYPE  CHAR100
*"  TABLES
*"      IT_HEADER STRUCTURE  ZPOC06_SO_HEADER OPTIONAL
*"      IT_ITEM STRUCTURE  ZPOC06_SO_ITEM OPTIONAL
*"      ET_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------

  DATA: ls_header_in TYPE bapisdh1,
        ls_headerinx TYPE bapisdh1x.

  DATA: lt_item_in LIKE TABLE OF bapisditm WITH HEADER LINE,
        lt_iteminx LIKE TABLE OF bapisditmx WITH HEADER LINE.

  DATA : lt_return   TYPE TABLE OF bapiret2 WITH HEADER LINE.

  IF i_gubun IS INITIAL.
    e_type = TEXT-m02.
    e_msg  = TEXT-m03.
    EXIT.

  ELSE.
    IF it_header[] IS INITIAL.
      e_type = TEXT-m02.
      e_msg  = TEXT-m04.
      EXIT.
    ENDIF.

    IF i_gubun = '2'.
      IF it_item[] IS INITIAL.
        e_type = TEXT-m02.
        e_msg  = TEXT-m04.
        EXIT.
      ENDIF.

      READ TABLE it_item INTO DATA(ls_item)
        WITH KEY reason = ''.
      IF sy-subrc EQ 0.

        e_type = TEXT-m02.
        e_msg = '거절사유는 필수값입니다.'.
        EXIT.

      ENDIF.

    ENDIF.
  ENDIF.


  CLEAR: ls_header_in, ls_headerinx.
  ls_headerinx-updateflag = 'U'.
  ls_headerinx-price_date = 'X'.

  CASE i_gubun.
    WHEN '1'. "가격 재결정

      LOOP AT it_header.

        ls_header_in-price_date = it_header-prsdt.

        CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
          EXPORTING
            salesdocument    = it_header-vbeln
            order_header_in  = ls_header_in
            order_header_inx = ls_headerinx
          TABLES
            return           = lt_return.

      ENDLOOP.

      IF lt_return[] IS not INITIAL.
        LOOP AT lt_return.
          MOVE : lt_return-type    TO et_return-type,
                 lt_return-ID      to et_return-ID,
                 lt_return-number  to et_return-number,
                 lt_return-message to et_return-message.

          APPEND et_return.
          clear : lt_return.
        ENDLOOP.

      ENDIF.


    WHEN '2'. "거절 사유 입력
      CLEAR : lt_item_in, lt_iteminx,
              lt_item_in[], lt_iteminx[].
      LOOP AT it_header.

          LOOP AT it_item WHERE vbeln = it_header-vbeln.

            ls_header_in-price_date = it_header-prsdt.
            lt_item_in-itm_number  = it_item-posnr.
            lt_item_in-reason_rej  = it_item-reason.
            lt_iteminx-itm_number = it_item-posnr.
            lt_iteminx-updateflag = 'U'.
            lt_iteminx-reason_rej = 'X'.
            APPEND : lt_item_in, lt_iteminx.
            clear : lt_item_in, lt_iteminx.
         ENDLOOP.

          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument             = it_header-vbeln
              order_header_in           = ls_header_in
              order_header_inx          = ls_headerinx

            TABLES
              order_item_in  = lt_item_in[]
              order_item_inx  = lt_iteminx[]
              return         = lt_return.

          IF lt_return[] IS not INITIAL.
            LOOP AT lt_return.
*              MOVE : lt_return-type    TO et_return-type,
*                     lt_return-ID      to et_return-ID,
*                     lt_return-number  to et_return-number,
*                     lt_return-message to et_return-message.
*
*              APPEND et_return.
*              clear : lt_return.

               et_return[] = VALUE #(
                               FOR wa IN lt_return
                               ( wa )
                             ).

            ENDLOOP.
          ENDIF.

      ENDLOOP.

    WHEN OTHERS.

  ENDCASE.

  CLEAR : et_return.
  READ TABLE et_return WITH KEY TYPE = 'S'
                                ID   = 'V1'
                                NUMBER = '311'.

  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    delete et_return[] where TYPE   <> 'S'
                         or ID      <> 'V1'
                         or NUMBER  <> '311'.

    e_type = TEXT-m01.
    e_msg  = et_return-message.
    EXIT.

  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    e_type = TEXT-m02.

    clear : et_return.
*    READ TABLE et_return WITH KEY type = 'E'.
    READ TABLE et_return INDEX 1.
    e_msg  = et_return-message.
    EXIT.
  ENDIF.


ENDFUNCTION.
