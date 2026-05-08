CLASS zcl_wo_crud_handler_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.



    METHODS check_customer_exists
      IMPORTING iv_customer_id   TYPE zde_customer_id_darc
      RETURNING VALUE(rv_exists) TYPE abap_bool.
    METHODS check_technician_exists
      IMPORTING iv_technician_id TYPE zde_technician_id
      RETURNING VALUE(rv_exists) TYPE abap_bool.
    METHODS check_order_exists
      IMPORTING iv_work_order_id   TYPE zde_work_order_id
      RETURNING VALUE(rv_exists) TYPE abap_bool.
    METHODS check_order_history
      IMPORTING iv_work_order_id   TYPE zde_work_order_id
      RETURNING VALUE(rv_exists) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS zcl_wo_crud_handler_darc IMPLEMENTATION.


  METHOD check_customer_exists.

    SELECT
    SINGLE @abap_true
    FROM ztcostumer_darc
    WHERE customer_id = @iv_customer_id
    INTO @rv_exists.

  ENDMETHOD.


  METHOD check_technician_exists.

    SELECT SINGLE @abap_true
    FROM zttechnician
    WHERE technician_id = @iv_technician_id
    INTO @rv_exists.

  ENDMETHOD.


  METHOD check_order_exists.

    SELECT SINGLE @abap_true
    FROM ztwork_ordr_darc
    WHERE work_order_id = @iv_work_order_id
    INTO @rv_exists.

  ENDMETHOD.


  METHOD check_order_history.

    SELECT SINGLE @abap_true
    FROM ztw_o_history_Da
    WHERE history_id = @iv_work_order_id
    INTO @rv_exists.

  ENDMETHOD.


ENDCLASS.
