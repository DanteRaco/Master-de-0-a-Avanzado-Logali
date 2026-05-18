CLASS zcl_wo_crud_handler_darc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES tty_work_order TYPE STANDARD TABLE OF ztwork_ordr_darc WITH EMPTY KEY.

    TYPES: BEGIN OF ty_work_order_report,
             work_order_id TYPE ztwork_ordr_darc-work_order_id,
             customer_id   TYPE ztwork_ordr_darc-customer_id,
             technician_id TYPE ztwork_ordr_darc-technician_id,
             creation_date TYPE ztwork_ordr_darc-creation_date,
             status        TYPE ztwork_ordr_darc-status,
             priority      TYPE ztwork_ordr_darc-priority,
             description   TYPE ztwork_ordr_darc-description,
           END OF ty_work_order_report.


    TYPES tty_work_order_report TYPE STANDARD TABLE OF ty_work_order_report WITH EMPTY KEY.

    METHODS: constructor,

      create_work_order IMPORTING is_work_order   TYPE ztwork_ordr_darc
                        RETURNING VALUE(rv_valid) TYPE abap_bool,

      read_work_order   EXPORTING rv_valid         TYPE abap_bool
                        RETURNING VALUE(rt_orders) TYPE tty_work_order_report,

      update_work_order IMPORTING is_work_order   TYPE ztwork_ordr_darc
                        RETURNING VALUE(rv_valid) TYPE abap_bool,

      delete_work_order IMPORTING is_work_order   TYPE ztwork_ordr_darc
                        RETURNING VALUE(rv_valid) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_validator TYPE REF TO zcl_work_order_validator_darc.
    METHODS authority_check IMPORTING iv_role         TYPE activ_auth
                            RETURNING VALUE(rv_permitted) TYPE abap_bool.
ENDCLASS.



CLASS zcl_wo_crud_handler_darc IMPLEMENTATION.

  METHOD constructor.
    mo_validator = NEW zcl_work_order_validator_darc( ).
  ENDMETHOD.


  METHOD create_work_order.

    rv_valid = abap_false.

    " Validacion de existencia de Customer_ID, Technician_ID y priority valid (A, B)
    DATA(lv_validation) = mo_validator->validate_create_order( iv_customer_id   = is_work_order-customer_id
                                                               iv_priority      = is_work_order-priority
                                                               iv_technician_id = is_work_order-technician_id ).
    " Validacion status (PE, CO) y priority (A, B)
    DATA(lv_status_valid) = mo_validator->validate_status_and_priority( iv_status   = is_work_order-status
                                                                        iv_priority = is_work_order-priority ).

    IF lv_validation = abap_true AND lv_status_valid = abap_true.

      INSERT ztwork_ordr_darc FROM @is_work_order.

      IF sy-subrc = 0.

        rv_valid = abap_true.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD read_work_order.

    CLEAR rt_orders.

    SELECT
    FROM ztwork_ordr_darc
    FIELDS work_order_id,
           customer_id,
           technician_id,
           creation_date,
           status,
           priority,
           description
    INTO CORRESPONDING FIELDS OF TABLE @rt_orders.

    rv_valid = xsdbool( lines( rt_orders ) > 0 ).

  ENDMETHOD.


  METHOD update_work_order.

    rv_valid = abap_false.

    "Validacion status (PE, CO) / Work_Order_ID existente
    DATA(lv_validation) = mo_validator->validate_update_order( iv_status = is_work_order-status
                                                               iv_work_order_id = is_work_order-work_order_id ).

    "Validacion status (PE, CO) y priority (A, B)
    DATA(lv_status_valid) = mo_validator->validate_status_and_priority( iv_status   = is_work_order-status
                                                                        iv_priority = is_work_order-priority ).

    IF lv_validation = abap_true AND lv_status_valid = abap_true.

      "Actualizacion de status y priority
      UPDATE ztwork_ordr_darc
           SET status      = @is_work_order-status,
               priority    = @is_work_order-priority,
               description = @is_work_order-description
         WHERE work_order_id = @is_work_order-work_order_id.

      IF sy-subrc = 0.

        rv_valid = abap_true.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD delete_work_order.

    rv_valid = abap_false.

    "Validacion Status (Solo estado Pendiente) y sin historial de modificaciones
    DATA(lv_validation) = mo_validator->validate_delete_order( iv_status = is_work_order-status
                                                               iv_work_order_id = is_work_order-work_order_id ).

    IF lv_validation = abap_true.

      DELETE FROM ztw_o_history_da
        WHERE work_order_id = @is_work_order-work_order_id.

      DELETE FROM ztwork_ordr_darc
        WHERE work_order_id = @is_work_order-work_order_id.

      IF sy-subrc = 0.
        rv_valid = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD authority_check.

    AUTHORITY-CHECK OBJECT 'ZAO_WO_AU'
      ID 'ZAF_WO_AUT' FIELD iv_role.

    data(lv_create_granted) = cond #( when sy-subrc = 0  then abap_true
                                                         else abap_false ).

    IF lv_create_granted = abap_true.
      rv_permitted = abap_true.
    ELSE.
      rv_permitted = abap_false.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
