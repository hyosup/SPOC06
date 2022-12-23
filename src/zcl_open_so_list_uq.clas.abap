CLASS zcl_open_so_list_uq DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_open_so_list_uq IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lt_result TYPE TABLE OF zspoc06_open_so_list.
    SELECT
        FROM zspoc06_open_so_list
        FIELDS *
        INTO CORRESPONDING FIELDS OF TABLE @lt_result.

    io_response->set_data( lt_result ).
*    TRY.
*        CASE io_request->get_entity_id( ).
*            WHEN 'SOLIST'.
*                DATA lt_result TYPE TABLE OF zspoc06_open_so_list.
*                SELECT
*                    FROM zspoc06_open_so_list
*                    FIELDS *
*                    INTO CORRESPONDING FIELDS OF TABLE @lt_result.
*
*                io_response->set_data( lt_result ).
*
*        ENDCASE.
*    CATCH cx_rap_query_provider.
*    ENDTRY.
  ENDMETHOD.
ENDCLASS.
