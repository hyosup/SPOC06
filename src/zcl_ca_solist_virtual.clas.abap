CLASS zcl_ca_solist_virtual DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ca_solist_virtual IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<origin>).
        READ TABLE ct_calculated_data[] INDEX sy-tabix ASSIGNING FIELD-SYMBOL(<calculated>).
        ASSIGN COMPONENT 'SalesOrderNumber' OF STRUCTURE <origin> TO FIELD-SYMBOL(<sonum>).

        SELECT
            FROM ZSPOC06_SO_ITEM
            FIELDS sum( multiple )
            WHERE vbeln = @<sonum>
            GROUP BY vbeln
            INTO TABLE @DATA(lv_sum).

        ASSIGN COMPONENT 'VALUE' OF STRUCTURE <calculated> TO FIELD-SYMBOL(<val>).
        try.
            <val> = lv_sum[ 1 ].
          CATCH cx_sy_itab_line_not_found into data(test).
            data(test11) = '0'.
        ENDTRY.

        ASSIGN COMPONENT 'SOLDTOPARTY' OF STRUCTURE <origin> TO FIELD-SYMBOL(<bp>).
        ASSIGN COMPONENT 'CREDITAREA' OF STRUCTURE <origin> TO FIELD-SYMBOL(<seg>).
        IF <bp> IS ASSIGNED AND <seg> IS ASSIGNED.
            SELECT
                FROM ZSPOC06_CREDIT_AMOUNT
                FIELDS Credit_category, TotalAmt, DeliveryAmt, OrdersAmt
                WHERE BusinessPartner = @<bp>
                  AND Credit_sgmnt    = @<seg>
                INTO TABLE @DATA(lt_credit).

            READ TABLE lt_credit INTO DATA(ls_credit) WITH KEY credit_category = '400'.
            ASSIGN COMPONENT 'OPEN_DELIVERY' OF STRUCTURE <calculated> TO FIELD-SYMBOL(<val_1>).
            IF <val_1> IS ASSIGNED.
                <val_1> = ls_credit-DeliveryAmt.
            ENDIF.

            CLEAR: ls_credit.
            READ TABLE lt_credit INTO ls_credit WITH KEY credit_category = '100'.
            ASSIGN COMPONENT 'OPEN_ORDER' OF STRUCTURE <calculated> TO FIELD-SYMBOL(<val_2>).
            IF <val_2> IS ASSIGNED.
                <val_2> = ls_credit-OrdersAmt.
            ENDIF.

            CLEAR: ls_credit.
            READ TABLE lt_credit INTO ls_credit WITH KEY credit_category = '500'.
            ASSIGN COMPONENT 'TOT_RECEIVABLE' OF STRUCTURE <calculated> TO FIELD-SYMBOL(<val_3>).
            IF <val_3> IS ASSIGNED.
                <val_3> = ls_credit-TotalAmt.
            ENDIF.

            ASSIGN COMPONENT 'CREDIT_EXPOSURE' OF STRUCTURE <calculated> TO FIELD-SYMBOL(<val_4>).
            <val_4> = <val_1> + <val_2> + <val_3>.
          ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.
ENDCLASS.
