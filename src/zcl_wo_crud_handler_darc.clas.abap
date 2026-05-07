CLASS zcl_wo_crud_handler_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS create_work_order
      IMPORTING
                iv_work_order_id  TYPE string
                iv_customer_id    TYPE string
                iv_technician_id  TYPE string
                iv_priority       TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

    METHODS read_work_order
      IMPORTING
        iv_work_order_id TYPE string
      EXPORTING
        es_order         TYPE ztwork_ordr_darc.

    METHODS update_work_order
      IMPORTING
                iv_work_order_id  TYPE string
                iv_status         TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

    METHODS delete_work_order
      IMPORTING
                iv_work_order_id  TYPE string
                iv_status         TYPE string
      RETURNING VALUE(rv_success) TYPE abap_bool.

  PRIVATE SECTION.

    DATA mo_validator TYPE REF TO zcl_work_order_validator_darc.

ENDCLASS.

CLASS zcl_wo_crud_handler_darc IMPLEMENTATION.

  METHOD create_work_order.

    rv_success = abap_false.

    mo_validator = NEW zcl_work_order_validator_darc( ).

    IF mo_validator->validate_create_order(
         iv_customer_id   = iv_customer_id
         iv_technician_id = iv_technician_id
         iv_priority      = iv_priority ) = abap_false.
      RETURN.
    ENDIF.

    IF sy-subrc = 0.
      rv_success = abap_true.
    ENDIF.

  ENDMETHOD.



  METHOD read_work_order.

    SELECT SINGLE *
      FROM ztwork_ordr_darc
      WHERE work_order_id = @iv_work_order_id
      INTO @es_order.

  ENDMETHOD.



  METHOD update_work_order.

    rv_success = abap_false.

    mo_validator = NEW zcl_work_order_validator_darc( ).

    IF mo_validator->validate_update_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = iv_status ) = abap_false.
      RETURN.
    ENDIF.

    UPDATE ztwork_ordr_darc
      SET status = @iv_status
      WHERE work_order_id = @iv_work_order_id.

    IF sy-subrc = 0.
      rv_success = abap_true.
    ENDIF.

  ENDMETHOD.



  METHOD delete_work_order.

    rv_success = abap_false.

    mo_validator = NEW zcl_work_order_validator_darc( ).

    IF mo_validator->validate_delete_order(
         iv_work_order_id = iv_work_order_id
         iv_status        = iv_status ) = abap_false.
      RETURN.
    ENDIF.

    DELETE FROM ztwork_ordr_darc
      WHERE work_order_id = @iv_work_order_id.

    IF sy-subrc = 0.
      rv_success = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
