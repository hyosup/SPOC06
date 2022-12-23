CLASS lhc_items DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE items.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE items.

    METHODS read FOR READ
      IMPORTING keys FOR READ items RESULT result.

    METHODS rba_Parent FOR READ
      IMPORTING keys_rba FOR READ items\_Parent FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_items IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Parent.
  ENDMETHOD.

ENDCLASS.
