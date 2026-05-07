CLASS zcl_wo_crud_test_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS test_create_work_order.
*    METHODS test_read_work_order.
*    METHODS test_update_work_order.
*    METHODS test_delete_work_order.

  PRIVATE SECTION.

    DATA mo_crud TYPE REF TO zcl_wo_crud_handler_darc.

ENDCLASS.

CLASS zcl_wo_crud_test_darc IMPLEMENTATION.


  METHOD test_create_work_order.

    mo_crud = NEW zcl_wo_crud_handler_darc( ).

    DATA(lv_success) = mo_crud->create_work_order(
      iv_work_order_id = 'WO1001'
      iv_customer_id   = 'C001'
      iv_technician_id = 'T001'
      iv_priority      = 'A'
    ).


  ENDMETHOD.

ENDCLASS.
