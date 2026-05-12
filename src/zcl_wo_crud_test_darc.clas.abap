CLASS zcl_wo_crud_test_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PRIVATE SECTION.

    METHODS test_create_work_order IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_read_work_order IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_update_work_order IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS test_delete_work_order IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS data_for_wo_table.

ENDCLASS.

CLASS zcl_wo_crud_test_darc IMPLEMENTATION.

  METHOD data_for_wo_table.
    INSERT ztcostumer_darc FROM @( VALUE #( customer_id = '123'
                                            name        = 'David'
                                            address     = '22 Barnes way'
                                            phone       = '8567161377'  ) ).

    INSERT zttechnician FROM @( VALUE #( technician_id  = 'A01'
                                         name           = 'Arturo'
                                         specialty      = 'Mechanic'  ) ).
  ENDMETHOD.



  METHOD if_oo_adt_classrun~main.

    data_for_wo_table(  ).
    test_create_work_order( out ).
    test_read_work_order( out ).
    test_update_work_order( out ).
    test_delete_work_order( out ).

  ENDMETHOD.

  METHOD test_create_work_order.

    DATA(lo_handler) = NEW zcl_wo_crud_handler_darc(  ).
    DATA(ls_new_wo) = VALUE ztwork_ordr_darc(
                work_order_id   = '0001'
                customer_id     = '123'
                technician_id   = 'A01'
                creation_date   = cl_abap_context_info=>get_system_date(  )
                status          = 'PE'
                priority        = 'A'
                description     = 'First work order created' ).

    IF lo_handler->create_work_order( is_work_order = ls_new_wo ) = abap_true.
      out->write( |A new work order has been created : { ls_new_wo-work_order_id }| ).
    ELSE.
      out->write( 'Could not create a new Work Order' ).
    ENDIF.

  ENDMETHOD.

  METHOD test_read_work_order.

    DATA(lo_handler) = NEW zcl_wo_crud_handler_darc( ).

    DATA lv_valid TYPE abap_bool.

    DATA(lt_orders) = lo_handler->read_work_order(
      IMPORTING
        rv_valid = lv_valid ).

    IF lv_valid = abap_true AND lt_orders IS NOT INITIAL.

      out->write( 'Work Orders Found:' ).
      out->write( lt_orders ).

    ELSE.

      out->write( 'No Work Orders Found' ).

    ENDIF.


  ENDMETHOD.


  METHOD test_update_work_order.

    DATA(lo_handler) = NEW zcl_wo_crud_handler_darc(  ).

    DATA(ls_order) = VALUE ztwork_ordr_darc( work_order_id = '0001'
                                             customer_id   = '456'
                                             technician_id = 'A01'
                                             creation_date = '20270101'
                                             status        = 'CO'
                                             priority      = 'B'
                                             description   = 'The work order was modified'
                                                     ).

    IF lo_handler->update_work_order( is_work_order = ls_order ) = abap_true.
      out->write( 'The Work Order was updated :' ).
      out->write( ls_order ).
    ELSE.
      out->write( 'No Work Orders updated' ).
    ENDIF.

  ENDMETHOD.


  METHOD test_delete_work_order.

    DATA(lo_handler) = NEW zcl_wo_crud_handler_darc(  ).

    DATA(ls_delete_wo) = VALUE ztwork_ordr_darc( work_order_id = '0001'
                                                 status        = 'PE'    ).

    IF lo_handler->delete_work_order( is_work_order = ls_delete_wo ) = abap_true.
      out->write( |The Work Order was deleted | ).
    ELSE.
      out->write( 'No Work Orders deleted' ).
    ENDIF.

  ENDMETHOD.



ENDCLASS.
