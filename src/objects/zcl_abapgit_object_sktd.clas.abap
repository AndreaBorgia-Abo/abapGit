CLASS zcl_abapgit_object_sktd DEFINITION
  PUBLIC
  INHERITING FROM zcl_abapgit_objects_super
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abapgit_object .

    METHODS constructor
      IMPORTING
        !is_item        TYPE zif_abapgit_definitions=>ty_item
        !iv_language    TYPE spras
        !io_files       TYPE REF TO zcl_abapgit_objects_files OPTIONAL
        !io_i18n_params TYPE REF TO zcl_abapgit_i18n_params OPTIONAL
      RAISING
        zcx_abapgit_type_not_supported.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mr_data TYPE REF TO data .
    DATA mv_object_key TYPE seu_objkey .
    DATA mi_persistence TYPE REF TO if_wb_object_persist .
    DATA mi_wb_object_operator TYPE REF TO object .

    METHODS clear_fields
      CHANGING
        !cs_data TYPE any .
    METHODS clear_field
      IMPORTING
        !iv_fieldname TYPE csequence
      CHANGING
        !cs_data      TYPE any .
    METHODS get_wb_object_operator
      RETURNING
        VALUE(ri_wb_object_operator) TYPE REF TO object
      RAISING
        zcx_abapgit_exception .
ENDCLASS.



CLASS zcl_abapgit_object_sktd IMPLEMENTATION.


  METHOD clear_field.

    FIELD-SYMBOLS <lv_value> TYPE data.

    ASSIGN COMPONENT iv_fieldname OF STRUCTURE cs_data TO <lv_value>.
    ASSERT sy-subrc = 0.

    CLEAR <lv_value>.

  ENDMETHOD.


  METHOD clear_fields.

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-NAME'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-TYPE'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-MASTER_SYSTEM'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-VERSION'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'REF_OBJECT-URI'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'REF_OBJECT-DESCRIPTION'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-CREATED_AT'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-CREATED_BY'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-CHANGED_AT'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-CHANGED_BY'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-MASTER_LANGUAGE'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-RESPONSIBLE'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-PACKAGE_REF'
      CHANGING
        cs_data = cs_data ).

    clear_field(
      EXPORTING
        iv_fieldname          = 'METADATA-LINKS'
      CHANGING
        cs_data = cs_data ).

  ENDMETHOD.


  METHOD constructor.

    super->constructor(
      is_item        = is_item
      iv_language    = iv_language
      io_files       = io_files
      io_i18n_params = io_i18n_params ).

    mv_object_key = ms_item-obj_name.

    TRY.
        CREATE DATA mr_data TYPE ('CL_KTD_OBJECT_DATA=>TY_KTD_DATA').
        CREATE OBJECT mi_persistence TYPE ('CL_KTD_OBJECT_PERSIST').

      CATCH cx_sy_create_error.
        RAISE EXCEPTION TYPE zcx_abapgit_type_not_supported EXPORTING obj_type = is_item-obj_type.
    ENDTRY.

  ENDMETHOD.


  METHOD get_wb_object_operator.

    DATA:
      ls_object_type TYPE wbobjtype,
      lx_error       TYPE REF TO cx_root.

    IF mi_wb_object_operator IS BOUND.
      ri_wb_object_operator = mi_wb_object_operator.
    ENDIF.

    ls_object_type-objtype_tr = 'SKTD'.
    ls_object_type-subtype_wb = 'TYP'.

    TRY.
        CALL METHOD ('CL_WB_OBJECT_OPERATOR')=>('CREATE_INSTANCE')
          EXPORTING
            object_type = ls_object_type
            object_key  = mv_object_key
          RECEIVING
            result      = mi_wb_object_operator.

      CATCH cx_root INTO lx_error.
        zcx_abapgit_exception=>raise_with_text( lx_error ).
    ENDTRY.

    ri_wb_object_operator = mi_wb_object_operator.

  ENDMETHOD.


  METHOD zif_abapgit_object~changed_by.

    DATA:
      li_wb_object_operator TYPE REF TO object,
      li_object_data_model  TYPE REF TO if_wb_object_data_model,
      lx_error              TYPE REF TO cx_root.

    TRY.
        li_wb_object_operator = get_wb_object_operator( ).

        CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~READ')
          IMPORTING
            eo_object_data = li_object_data_model.

        rv_user = li_object_data_model->get_changed_by( ).

      CATCH cx_root INTO lx_error.
        zcx_abapgit_exception=>raise_with_text( lx_error ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abapgit_object~delete.

    DATA:
      lx_error              TYPE REF TO cx_root,
      li_wb_object_operator TYPE REF TO object.

    li_wb_object_operator = get_wb_object_operator( ).

    TRY.
        CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~DELETE')
          EXPORTING
            transport_request = iv_transport.

      CATCH cx_root INTO lx_error.
        zcx_abapgit_exception=>raise_with_text( lx_error ).
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abapgit_object~deserialize.

    DATA li_wb_object_operator TYPE REF TO object.
    DATA li_object_data_model  TYPE REF TO if_wb_object_data_model.

    FIELD-SYMBOLS <ls_data> TYPE any.
    FIELD-SYMBOLS <ls_metadata> TYPE any.
    FIELD-SYMBOLS <lv_created_by> TYPE syuname.
    FIELD-SYMBOLS <lv_created_at> TYPE p.

    ASSIGN mr_data->* TO <ls_data>.
    ASSERT sy-subrc = 0.

    io_xml->read(
      EXPORTING
        iv_name = 'SKTD'
      CHANGING
        cg_data = <ls_data> ).

    " update( ) requires created_at and created_by to be set
    ASSIGN COMPONENT 'METADATA' OF STRUCTURE <ls_data> TO <ls_metadata>.
    IF sy-subrc = 0.
      ASSIGN COMPONENT 'CREATED_AT' OF STRUCTURE <ls_metadata> TO <lv_created_at>.
      IF sy-subrc = 0 AND <lv_created_at> IS INITIAL.
        GET TIME STAMP FIELD <lv_created_at>.
      ENDIF.
      ASSIGN COMPONENT 'CREATED_BY' OF STRUCTURE <ls_metadata> TO <lv_created_by>.
      IF sy-subrc = 0 AND <lv_created_by> IS INITIAL.
        <lv_created_by> = sy-uname.
      ENDIF.
    ENDIF.

    li_wb_object_operator = get_wb_object_operator( ).

    CREATE OBJECT li_object_data_model TYPE ('CL_KTD_OBJECT_DATA').
    li_object_data_model->set_data( <ls_data> ).

    tadir_insert( iv_package ).

    IF zif_abapgit_object~exists( ) = abap_true.

      CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~UPDATE')
        EXPORTING
          io_object_data    = li_object_data_model
          transport_request = iv_transport.

    ELSE.

      CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~CREATE')
        EXPORTING
          io_object_data    = li_object_data_model
          data_selection    = 'P' " if_wb_object_data_selection_co=>c_properties
          package           = iv_package
          transport_request = iv_transport.

      CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~UPDATE')
        EXPORTING
          io_object_data    = li_object_data_model
          data_selection    = 'D' " if_wb_object_data_selection_co=>c_data_content
          transport_request = iv_transport.
    ENDIF.

    CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~ACTIVATE').

    corr_insert( iv_package ).

  ENDMETHOD.


  METHOD zif_abapgit_object~exists.

    TRY.
        mi_persistence->get(
            p_object_key           = mv_object_key
            p_version              = 'A'
            p_existence_check_only = abap_true ).
        rv_bool = abap_true.

      CATCH cx_swb_exception.
        rv_bool = abap_false.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_abapgit_object~get_comparator.
    RETURN.
  ENDMETHOD.


  METHOD zif_abapgit_object~get_deserialize_order.
    RETURN.
  ENDMETHOD.


  METHOD zif_abapgit_object~get_deserialize_steps.
    APPEND zif_abapgit_object=>gc_step_id-late TO rt_steps.
    APPEND zif_abapgit_object=>gc_step_id-lxe TO rt_steps.
  ENDMETHOD.


  METHOD zif_abapgit_object~get_metadata.
    rs_metadata = get_metadata( ).
  ENDMETHOD.


  METHOD zif_abapgit_object~is_active.
    rv_active = is_active( ).
  ENDMETHOD.


  METHOD zif_abapgit_object~is_locked.

    rv_is_locked = exists_a_lock_entry_for(
      iv_lock_object = 'WBS_ENQUEUE_STRU'
      iv_argument    = |{ ms_item-obj_type }{ ms_item-obj_name }| ).

  ENDMETHOD.


  METHOD zif_abapgit_object~jump.
    " Covered by ZCL_ABAPGIT_OBJECTS=>JUMP
  ENDMETHOD.


  METHOD zif_abapgit_object~map_filename_to_object.
    RETURN.
  ENDMETHOD.


  METHOD zif_abapgit_object~map_object_to_filename.
    RETURN.
  ENDMETHOD.


  METHOD zif_abapgit_object~serialize.

    DATA:
      li_wb_object_operator TYPE REF TO object,
      li_object_data_model  TYPE REF TO if_wb_object_data_model,
      lx_error              TYPE REF TO cx_root.

    FIELD-SYMBOLS <ls_data> TYPE any.

    ASSIGN mr_data->* TO <ls_data>.
    ASSERT sy-subrc = 0.

    li_wb_object_operator = get_wb_object_operator( ).

    TRY.
        CALL METHOD li_wb_object_operator->('IF_WB_OBJECT_OPERATOR~READ')
          EXPORTING
            version        = 'A'
          IMPORTING
            data           = <ls_data>
            eo_object_data = li_object_data_model.

        clear_fields( CHANGING cs_data = <ls_data> ).

      CATCH cx_root INTO lx_error.
        zcx_abapgit_exception=>raise_with_text( lx_error ).
    ENDTRY.

    io_xml->add(
      iv_name = 'SKTD'
      ig_data = <ls_data> ).

  ENDMETHOD.
ENDCLASS.
