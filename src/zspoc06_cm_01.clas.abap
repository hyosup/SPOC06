CLASS zspoc06_cm_01 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF msg_param,
        msgid TYPE symsgid VALUE 'ZSPOC06_MSG',
        msgno TYPE symsgno VALUE '000',
        attr1 TYPE scx_attrname VALUE 'MV_ATTR1',
        attr2 TYPE scx_attrname VALUE 'MV_ATTR2',
        attr3 TYPE scx_attrname VALUE 'MV_ATTR3',
        attr4 TYPE scx_attrname VALUE 'MV_ATTR4',
      END OF msg_param .

    DATA:
      mv_attr1                 TYPE string,
      mv_attr2                 TYPE string,
      mv_attr3                 TYPE string,
      mv_attr4                 TYPE string.

    METHODS constructor
      IMPORTING
        !msg TYPE STRING OPTIONAL
        !bapi TYPE BAPIRET2 OPTIONAL
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        !severity TYPE if_abap_behv_message~t_severity OPTIONAL
        !attr1 TYPE STRING OPTIONAL
        !attr2 TYPE STRING OPTIONAL
        !attr3 TYPE STRING OPTIONAL
        !attr4 TYPE STRING OPTIONAL.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zspoc06_cm_01 IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    DATA : lv_string1 TYPE C LENGTH 50,
           lv_string2 TYPE C LENGTH 50,
           lv_string3 TYPE C LENGTH 50,
           lv_string4 TYPE C LENGTH 50.

*    IF !msg IS NOT INITIAL.
*
*        DATA(input_msg) = CONV char200( !msg ).
*
*        lv_string1 = input_msg(50).
*        lv_string2 = input_msg+50(50).
*        lv_string3 = input_msg+100(50).
*        lv_string4 = input_msg+150(50).
*
**        DATA(lv_msg) = VALUE SCX_T100KEY(
**                          msgid = 'ZSPOC06_MSG'
**                          msgno = '000'
**                          attr1 = CONV #( lv_string1 )
**                          attr2 = CONV #( lv_string2 )
**                          attr3 = CONV #( lv_string3 )
**                          attr4 = CONV #( lv_string4 )
**                        ).
*
**      TRANSLATE lv_msg-attr1 USING '& '.
**      TRANSLATE lv_msg-attr2 USING '& '.
**      TRANSLATE lv_msg-attr3 USING '& '.
**      TRANSLATE lv_msg-attr4 USING '& '.
*
*    ENDIF.

    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.


*    mv_attr1 = attr1.
*    mv_attr2 = attr2.
*    mv_attr3 = attr3.
*    mv_attr4 = attr4.
*
*    IF !textid IS INITIAL.
*      if_t100_message~t100key = if_t100_message=>default_textid.
*    ELSE.
*      if_t100_message~t100key = textid.
*    ENDIF.


    DATA(lo_textid) = VALUE SCX_T100KEY(
                    msgid = bapi-id
                    msgno = bapi-number
                    attr1 = 'MV_ATTR1'
                    attr2 = 'MV_ATTR2'
                    attr3 = 'MV_ATTR3'
                    attr4 = 'MV_ATTR4'
                   ).

    mv_attr1 = bapi-message_v1.
    mv_attr2 = bapi-message_v2.
    mv_attr3 = bapi-message_v3.
    mv_attr4 = bapi-message_v4.

    if_t100_message~t100key = lo_textid.

  ENDMETHOD.

ENDCLASS.
