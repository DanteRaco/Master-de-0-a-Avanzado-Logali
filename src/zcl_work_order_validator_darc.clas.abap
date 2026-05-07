CLASS zcl_work_order_validator_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS validate_create_order
      IMPORTING
        iv_customer_id   TYPE string
        iv_technician_id TYPE string
        iv_priority      TYPE string
      RETURNING VALUE(rv_valid) TYPE abap_bool.

    METHODS validate_update_order
      IMPORTING
        iv_work_order_id TYPE string
        iv_status        TYPE string
      RETURNING VALUE(rv_valid) TYPE abap_bool.

    METHODS validate_delete_order
      IMPORTING
        iv_work_order_id TYPE string
        iv_status        TYPE string
      RETURNING VALUE(rv_valid) TYPE abap_bool.

    METHODS validate_status_and_priority
      IMPORTING
        iv_status   TYPE string
        iv_priority TYPE string
      RETURNING VALUE(rv_valid) TYPE abap_bool.

  PRIVATE SECTION.

    CONSTANTS:
      c_status_pending   TYPE string VALUE 'PE',
      c_status_completed TYPE string VALUE 'CO',
      c_priority_a       TYPE string VALUE 'A',
      c_priority_b       TYPE string VALUE 'B'.

    METHODS check_customer_exists
      IMPORTING
        iv_customer_id TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS check_technician_exists
      IMPORTING
        iv_technician_id TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS check_order_exists
      IMPORTING
        iv_work_order_id TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

    METHODS check_order_history
      IMPORTING
        iv_work_order_id TYPE string
      RETURNING VALUE(rv_exists) TYPE abap_bool.

ENDCLASS.



CLASS zcl_work_order_validator_darc IMPLEMENTATION.

  METHOD validate_create_order.

    rv_valid = abap_false.

    IF check_customer_exists( iv_customer_id ) = abap_false.
      RETURN.
    ENDIF.

    IF check_technician_exists( iv_technician_id ) = abap_false.
      RETURN.
    ENDIF.

    IF iv_priority <> c_priority_a AND
       iv_priority <> c_priority_b.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.



  METHOD validate_update_order.

    rv_valid = abap_false.

    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    IF iv_status <> c_status_pending AND
       iv_status <> c_status_completed.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.



  METHOD validate_delete_order.

    rv_valid = abap_false.

    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    IF iv_status <> c_status_pending.
      RETURN.
    ENDIF.

    IF check_order_history( iv_work_order_id ) = abap_true.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.



  METHOD validate_status_and_priority.

    rv_valid = abap_false.

    IF iv_status <> c_status_pending AND
       iv_status <> c_status_completed.
      RETURN.
    ENDIF.

    IF iv_priority <> c_priority_a AND
       iv_priority <> c_priority_b.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.



  METHOD check_customer_exists.
    rv_exists = abap_true.

  ENDMETHOD.



  METHOD check_technician_exists.
    rv_exists = abap_true.

  ENDMETHOD.



  METHOD check_order_exists.
    rv_exists = abap_true.

  ENDMETHOD.



  METHOD check_order_history.
    rv_exists = abap_false.

  ENDMETHOD.

ENDCLASS.
