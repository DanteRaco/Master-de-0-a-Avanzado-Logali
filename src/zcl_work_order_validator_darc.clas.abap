CLASS zcl_work_order_validator_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS validate_create_order
      IMPORTING
                iv_customer_id   TYPE zde_customer_id_darc
                iv_technician_id TYPE zde_technician_id
                iv_priority      TYPE zde_priority_darc
      RETURNING VALUE(rv_valid)  TYPE abap_bool.

    METHODS validate_update_order
      IMPORTING
                iv_work_order_id TYPE zde_work_order_id
                iv_status        TYPE zde_status_darc
      RETURNING VALUE(rv_valid)  TYPE abap_bool.

    METHODS validate_delete_order
      IMPORTING
                iv_work_order_id TYPE zde_work_order_id
                iv_status        TYPE zde_status_darc
      RETURNING VALUE(rv_valid)  TYPE abap_bool.

    METHODS validate_status_and_priority
      IMPORTING
                iv_status       TYPE zde_status_darc
                iv_priority     TYPE zde_priority_darc
      RETURNING VALUE(rv_valid) TYPE abap_bool.

  PRIVATE SECTION.

    CONSTANTS:
      c_status_pending   TYPE string VALUE 'PE',
      c_status_completed TYPE string VALUE 'CO',
      c_priority_a       TYPE string VALUE 'A',
      c_priority_b       TYPE string VALUE 'B'.

    METHODS check_customer_exists
      IMPORTING
                iv_customer_id  TYPE zde_customer_id_darc
      RETURNING VALUE(rv_valid) TYPE abap_bool.

    METHODS check_technician_exists
      IMPORTING
                iv_technician_id TYPE zde_technician_id
      RETURNING VALUE(rv_valid)  TYPE abap_bool.

    METHODS check_order_exists
      IMPORTING
                iv_work_order_id TYPE zde_work_order_id
      RETURNING VALUE(rv_valid)  TYPE abap_bool.

    METHODS check_order_history
      IMPORTING
                iv_work_order_id TYPE zde_work_order_id
      RETURNING VALUE(rv_valid)  TYPE abap_bool.

ENDCLASS.



CLASS zcl_work_order_validator_darc IMPLEMENTATION.

  METHOD validate_create_order.

    " Check if customer exists
    DATA(lv_customer_exists) = check_customer_exists( iv_customer_id ).
    IF lv_customer_exists IS INITIAL.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    "Check if technician exists
    DATA(lv_technician_exists) = check_technician_exists( iv_technician_id ).
    IF lv_technician_exists IS INITIAL.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " Check if priority is valid
    IF iv_priority <> c_priority_a AND
       iv_priority <> c_priority_b.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.



  METHOD validate_update_order.

    " Check if the work order exists
    DATA(lv_order_exists) = check_order_exists( iv_work_order_id ).
    IF lv_order_exists IS INITIAL.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    "Check if the order status is editable
    IF iv_status <> c_status_pending AND
       iv_status <> c_status_completed.

      rv_valid = abap_false.
      RETURN.
    ENDIF.

      rv_valid = abap_true.

  ENDMETHOD.



  METHOD validate_delete_order.

    " Check if the work order exists
    DATA(lv_order_exists) = check_order_exists( iv_work_order_id ).
    IF lv_order_exists IS INITIAL.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " Check if the order status is "PE"
    IF iv_status <> c_status_pending.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    " Check if the order has a history
    DATA(lv_has_history) = check_order_history( iv_work_order_id ).
    IF lv_has_history IS NOT INITIAL.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.



  METHOD validate_status_and_priority.

    "Validate the status value
    IF iv_status <> c_status_pending AND
       iv_status <> c_status_completed.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    "Validate the priority value
    IF iv_priority <> c_priority_a AND
       iv_priority <> c_priority_b.
      rv_valid = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD check_customer_exists.

    SELECT
    SINGLE @abap_true
    FROM ztcostumer_darc
    WHERE customer_id = @iv_customer_id
    INTO @rv_valid.

  ENDMETHOD.


  METHOD check_technician_exists.

    SELECT SINGLE @abap_true
    FROM zttechnician
    WHERE technician_id = @iv_technician_id
    INTO @rv_valid.

  ENDMETHOD.


  METHOD check_order_exists.

    SELECT SINGLE @abap_true
    FROM ztwork_ordr_darc
    WHERE work_order_id = @iv_work_order_id
    INTO @rv_valid.

  ENDMETHOD.


  METHOD check_order_history.

    SELECT SINGLE @abap_true
    FROM ztw_o_history_da
    WHERE work_order_id = @iv_work_order_id
    INTO @rv_valid.

  ENDMETHOD.

ENDCLASS.
