CLASS zcl_abapgit_repo DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_abapgit_repo .

    ALIASES ms_data
      FOR zif_abapgit_repo~ms_data .

    ALIASES get_key                       FOR zif_abapgit_repo~get_key.
    ALIASES get_name                      FOR zif_abapgit_repo~get_name.
    ALIASES is_offline                    FOR zif_abapgit_repo~is_offline.
    ALIASES get_package                   FOR zif_abapgit_repo~get_package.
    ALIASES get_local_settings            FOR zif_abapgit_repo~get_local_settings.
    ALIASES get_tadir_objects             FOR zif_abapgit_repo~get_tadir_objects.
    ALIASES get_files_local_filtered      FOR zif_abapgit_repo~get_files_local_filtered.
    ALIASES get_files_local               FOR zif_abapgit_repo~get_files_local.
    ALIASES get_files_remote              FOR zif_abapgit_repo~get_files_remote.
    ALIASES refresh                       FOR zif_abapgit_repo~refresh.
    ALIASES get_dot_abapgit               FOR zif_abapgit_repo~get_dot_abapgit.
    ALIASES set_dot_abapgit               FOR zif_abapgit_repo~set_dot_abapgit.
    ALIASES find_remote_dot_abapgit       FOR zif_abapgit_repo~find_remote_dot_abapgit.
    ALIASES deserialize                   FOR zif_abapgit_repo~deserialize.
    ALIASES deserialize_checks            FOR zif_abapgit_repo~deserialize_checks.
    ALIASES checksums                     FOR zif_abapgit_repo~checksums.
    ALIASES has_remote_source             FOR zif_abapgit_repo~has_remote_source.
    ALIASES get_log                       FOR zif_abapgit_repo~get_log.
    ALIASES create_new_log                FOR zif_abapgit_repo~create_new_log.
    ALIASES get_dot_apack                 FOR zif_abapgit_repo~get_dot_apack.
    ALIASES delete_checks                 FOR zif_abapgit_repo~delete_checks.
    ALIASES set_files_remote              FOR zif_abapgit_repo~set_files_remote.
    ALIASES get_unsupported_objects_local FOR zif_abapgit_repo~get_unsupported_objects_local.
    ALIASES set_local_settings            FOR zif_abapgit_repo~set_local_settings.
    ALIASES switch_repo_type              FOR zif_abapgit_repo~switch_repo_type.
    ALIASES refresh_local_object          FOR zif_abapgit_repo~refresh_local_object.
    ALIASES refresh_local_objects         FOR zif_abapgit_repo~refresh_local_objects.
    ALIASES get_data_config               FOR zif_abapgit_repo~get_data_config.
    ALIASES bind_listener                 FOR zif_abapgit_repo~bind_listener.
    ALIASES remove_ignored_files          FOR zif_abapgit_repo~remove_ignored_files.

    METHODS constructor
      IMPORTING
        !is_data TYPE zif_abapgit_persistence=>ty_repo .

  PROTECTED SECTION.

    DATA mt_local TYPE zif_abapgit_definitions=>ty_files_item_tt .
    DATA mt_remote TYPE zif_abapgit_git_definitions=>ty_files_tt .
    DATA mv_request_local_refresh TYPE abap_bool .
    DATA mv_request_remote_refresh TYPE abap_bool .
    DATA mi_log TYPE REF TO zif_abapgit_log .
    DATA mi_listener TYPE REF TO zif_abapgit_repo_listener .
    DATA mo_apack_reader TYPE REF TO zcl_abapgit_apack_reader .
    DATA mi_data_config TYPE REF TO zif_abapgit_data_config .

    METHODS find_remote_dot_apack
      RETURNING
        VALUE(ro_dot) TYPE REF TO zcl_abapgit_apack_reader
      RAISING
        zcx_abapgit_exception .
    METHODS reset_remote .
    METHODS set
      IMPORTING
        !iv_url             TYPE zif_abapgit_persistence=>ty_repo-url OPTIONAL
        !iv_branch_name     TYPE zif_abapgit_persistence=>ty_repo-branch_name OPTIONAL
        !iv_selected_commit TYPE zif_abapgit_persistence=>ty_repo-selected_commit OPTIONAL
        !iv_head_branch     TYPE zif_abapgit_persistence=>ty_repo-head_branch OPTIONAL
        !iv_offline         TYPE zif_abapgit_persistence=>ty_repo-offline OPTIONAL
        !is_dot_abapgit     TYPE zif_abapgit_persistence=>ty_repo-dot_abapgit OPTIONAL
        !is_local_settings  TYPE zif_abapgit_persistence=>ty_repo-local_settings OPTIONAL
        !iv_deserialized_at TYPE zif_abapgit_persistence=>ty_repo-deserialized_at OPTIONAL
        !iv_deserialized_by TYPE zif_abapgit_persistence=>ty_repo-deserialized_by OPTIONAL
        !iv_switched_origin TYPE zif_abapgit_persistence=>ty_repo-switched_origin OPTIONAL
      RAISING
        zcx_abapgit_exception .
    METHODS set_dot_apack
      IMPORTING
        !io_dot_apack TYPE REF TO zcl_abapgit_apack_reader
      RAISING
        zcx_abapgit_exception .
  PRIVATE SECTION.
    METHODS check_language
      RAISING
        zcx_abapgit_exception .
    METHODS check_write_protect
      RAISING
        zcx_abapgit_exception .
    METHODS deserialize_data
      IMPORTING
        !is_checks TYPE zif_abapgit_definitions=>ty_deserialize_checks
      CHANGING
        !ct_files  TYPE zif_abapgit_git_definitions=>ty_file_signatures_tt
      RAISING
        zcx_abapgit_exception .
    METHODS deserialize_dot_abapgit
      CHANGING
        !ct_files TYPE zif_abapgit_git_definitions=>ty_file_signatures_tt
      RAISING
        zcx_abapgit_exception .
    METHODS deserialize_objects
      IMPORTING
        !is_checks TYPE zif_abapgit_definitions=>ty_deserialize_checks
        !ii_log    TYPE REF TO zif_abapgit_log
      CHANGING
        !ct_files  TYPE zif_abapgit_git_definitions=>ty_file_signatures_tt
      RAISING
        zcx_abapgit_exception .
    METHODS normalize_local_settings
      CHANGING
        !cs_local_settings TYPE zif_abapgit_persistence=>ty_local_settings .
    METHODS notify_listener
      IMPORTING
        !is_change_mask TYPE zif_abapgit_persistence=>ty_repo_meta_mask
      RAISING
        zcx_abapgit_exception .
    METHODS update_last_deserialize
      RAISING
        zcx_abapgit_exception .
    METHODS check_abap_language_version
      RAISING
        zcx_abapgit_exception .
    METHODS remove_locally_excluded_files
      CHANGING
        !ct_rem_files TYPE zif_abapgit_git_definitions=>ty_files_tt OPTIONAL
        !ct_loc_files TYPE zif_abapgit_definitions=>ty_files_item_tt OPTIONAL
      RAISING
        zcx_abapgit_exception .

ENDCLASS.



CLASS ZCL_ABAPGIT_REPO IMPLEMENTATION.


  METHOD zif_abapgit_repo~bind_listener.
    mi_listener = ii_listener.
  ENDMETHOD.


  METHOD check_abap_language_version.

    DATA lo_abapgit_abap_language_vers TYPE REF TO zcl_abapgit_abap_language_vers.
    DATA lv_text TYPE string.

    CREATE OBJECT lo_abapgit_abap_language_vers
      EXPORTING
        io_dot_abapgit = get_dot_abapgit( ).

    IF lo_abapgit_abap_language_vers->is_import_allowed( ms_data-package ) = abap_false.
      lv_text = |Repository cannot be imported. | &&
                |ABAP Language Version of linked package is not compatible with repository settings.|.
      zcx_abapgit_exception=>raise( lv_text ).
    ENDIF.
  ENDMETHOD.


  METHOD check_language.

    DATA:
      lv_main_language  TYPE spras,
      lv_error_message  TYPE string,
      lv_error_longtext TYPE string.

    " for deserialize, assumes find_remote_dot_abapgit has been called before (or language won't be defined)
    lv_main_language = get_dot_abapgit( )->get_main_language( ).

    IF lv_main_language <> sy-langu.

      lv_error_message = |Current login language |
                      && |'{ zcl_abapgit_convert=>conversion_exit_isola_output( sy-langu ) }'|
                      && | does not match main language |
                      && |'{ zcl_abapgit_convert=>conversion_exit_isola_output( lv_main_language ) }'.|.

      " Feature open in main language only exists if abapGit tcode is present
      IF zcl_abapgit_services_abapgit=>get_abapgit_tcode( ) IS INITIAL.
        lv_error_message = lv_error_message && | Please logon in main language and retry.|.
        lv_error_longtext = |For the Advanced menu option 'Open in Main Language' to be available a transaction code| &&
                            | must be assigned to report { sy-cprog }.|.
      ELSE.
        lv_error_message = lv_error_message && | Select 'Advanced' > 'Open in Main Language'|.
      ENDIF.

      zcx_abapgit_exception=>raise( iv_text     = lv_error_message
                                    iv_longtext = lv_error_longtext ).

    ENDIF.

  ENDMETHOD.


  METHOD check_write_protect.

    IF get_local_settings( )-write_protected = abap_true.
      zcx_abapgit_exception=>raise( 'Cannot deserialize. Local code is write-protected by repo config' ).
    ENDIF.

  ENDMETHOD.


  METHOD constructor.

    ASSERT NOT is_data-key IS INITIAL.

    ms_data = is_data.
    mv_request_remote_refresh = abap_true.

  ENDMETHOD.


  METHOD zif_abapgit_repo~create_new_log.

    CREATE OBJECT mi_log TYPE zcl_abapgit_log.
    mi_log->set_title( iv_title ).

    ri_log = mi_log.

  ENDMETHOD.


  METHOD zif_abapgit_repo~delete_checks.

    DATA: li_package TYPE REF TO zif_abapgit_sap_package.

    check_write_protect( ).
    check_language( ).

    li_package = zcl_abapgit_factory=>get_sap_package( get_package( ) ).
    rs_checks-transport-required = li_package->are_changes_recorded_in_tr_req( ).

  ENDMETHOD.


  METHOD deserialize_data.

    DATA:
      lt_updated_files TYPE zif_abapgit_git_definitions=>ty_file_signatures_tt,
      lt_result        TYPE zif_abapgit_data_deserializer=>ty_results.

    "Deserialize data
    lt_result = zcl_abapgit_data_factory=>get_deserializer( )->deserialize(
      ii_config  = get_data_config( )
      it_files   = get_files_remote( ) ).

    "Save deserialized data to DB and add entries to transport requests
    lt_updated_files = zcl_abapgit_data_factory=>get_deserializer( )->actualize(
      it_result = lt_result
      is_checks = is_checks ).

    INSERT LINES OF lt_updated_files INTO TABLE ct_files.

  ENDMETHOD.


  METHOD deserialize_dot_abapgit.
    INSERT get_dot_abapgit( )->get_signature( ) INTO TABLE ct_files.
  ENDMETHOD.


  METHOD deserialize_objects.

    DATA:
      lt_updated_files TYPE zif_abapgit_git_definitions=>ty_file_signatures_tt,
      lx_error         TYPE REF TO zcx_abapgit_exception.

    TRY.
        lt_updated_files = zcl_abapgit_objects=>deserialize(
          ii_repo   = me
          is_checks = is_checks
          ii_log    = ii_log ).
      CATCH zcx_abapgit_exception INTO lx_error.
        " Ensure to reset default transport request task
        zcl_abapgit_factory=>get_default_transport( )->reset( ).
        refresh( iv_drop_log = abap_false ).
        RAISE EXCEPTION lx_error.
    ENDTRY.

    INSERT LINES OF lt_updated_files INTO TABLE ct_files.

  ENDMETHOD.


  METHOD find_remote_dot_apack.

    FIELD-SYMBOLS: <ls_remote> LIKE LINE OF mt_remote.

    get_files_remote( ).

    READ TABLE mt_remote ASSIGNING <ls_remote>
      WITH KEY file_path
      COMPONENTS path     = zif_abapgit_definitions=>c_root_dir
                 filename = zif_abapgit_apack_definitions=>c_dot_apack_manifest.
    IF sy-subrc = 0.
      ro_dot = zcl_abapgit_apack_reader=>deserialize( iv_package_name = ms_data-package
                                                      iv_xstr         = <ls_remote>-data ).
      set_dot_apack( ro_dot ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_data_config.

    FIELD-SYMBOLS: <ls_remote> LIKE LINE OF mt_remote.

    IF mi_data_config IS BOUND.
      ri_config = mi_data_config.
      RETURN.
    ENDIF.

    CREATE OBJECT ri_config TYPE zcl_abapgit_data_config.

    READ TABLE mt_remote ASSIGNING <ls_remote>
      WITH KEY file_path
      COMPONENTS path = zif_abapgit_data_config=>c_default_path.
    IF sy-subrc = 0.
      ri_config->from_json( mt_remote ).
    ENDIF.

* offline repos does not have the remote files before the zip is choosen
* so make sure the json is read after zip file is loaded
    IF lines( mt_remote ) > 0.
      mi_data_config = ri_config.
    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_dot_apack.
    IF mo_apack_reader IS NOT BOUND.
      mo_apack_reader = zcl_abapgit_apack_reader=>create_instance( ms_data-package ).
    ENDIF.

    ro_dot_apack = mo_apack_reader.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_log.
    ri_log = mi_log.
  ENDMETHOD.


  METHOD zif_abapgit_repo~get_unsupported_objects_local.

    DATA: lt_tadir           TYPE zif_abapgit_definitions=>ty_tadir_tt,
          lt_supported_types TYPE zif_abapgit_objects=>ty_types_tt.

    FIELD-SYMBOLS: <ls_tadir>  LIKE LINE OF lt_tadir,
                   <ls_object> LIKE LINE OF rt_objects.

    lt_tadir = get_tadir_objects( ).

    lt_supported_types = zcl_abapgit_objects=>supported_list( ).
    LOOP AT lt_tadir ASSIGNING <ls_tadir>.
      READ TABLE lt_supported_types WITH KEY table_line = <ls_tadir>-object TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO rt_objects ASSIGNING <ls_object>.
        MOVE-CORRESPONDING <ls_tadir> TO <ls_object>.
        <ls_object>-obj_type = <ls_tadir>-object.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD normalize_local_settings.

    cs_local_settings-labels = zcl_abapgit_repo_labels=>normalize( cs_local_settings-labels ).

    " TODO: more validation and normalization ?

  ENDMETHOD.


  METHOD notify_listener.

    DATA ls_meta_slug TYPE zif_abapgit_persistence=>ty_repo_xml.

    IF mi_listener IS BOUND.
      MOVE-CORRESPONDING ms_data TO ls_meta_slug.
      mi_listener->on_meta_change(
        iv_key         = ms_data-key
        is_meta        = ls_meta_slug
        is_change_mask = is_change_mask ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_repo~refresh_local_object.

    DATA:
      ls_tadir           TYPE zif_abapgit_definitions=>ty_tadir,
      lt_tadir           TYPE zif_abapgit_definitions=>ty_tadir_tt,
      lt_new_local_files TYPE zif_abapgit_definitions=>ty_files_item_tt,
      lo_serialize       TYPE REF TO zcl_abapgit_serialize.

    lt_tadir = get_tadir_objects( ).

    DELETE mt_local WHERE item-obj_type = iv_obj_type
                      AND item-obj_name = iv_obj_name.

    READ TABLE lt_tadir INTO ls_tadir
                        WITH KEY object   = iv_obj_type
                                 obj_name = iv_obj_name.
    IF sy-subrc <> 0 OR ls_tadir-delflag = abap_true.
      " object doesn't exist anymore, nothing todo here
      RETURN.
    ENDIF.

    CLEAR lt_tadir.
    INSERT ls_tadir INTO TABLE lt_tadir.

    CREATE OBJECT lo_serialize
      EXPORTING
        io_dot_abapgit    = get_dot_abapgit( )
        is_local_settings = get_local_settings( ).

    lt_new_local_files = lo_serialize->serialize(
      iv_package = ms_data-package
      it_tadir   = lt_tadir ).

    INSERT LINES OF lt_new_local_files INTO TABLE mt_local.

  ENDMETHOD.


  METHOD zif_abapgit_repo~refresh_local_objects.

    mv_request_local_refresh = abap_true.
    get_files_local( ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~remove_ignored_files.

    DATA lo_dot TYPE REF TO zcl_abapgit_dot_abapgit.
    DATA lv_index TYPE sy-index.

    FIELD-SYMBOLS <ls_files> LIKE LINE OF ct_files.

    lo_dot = get_dot_abapgit( ).

    " Skip ignored files
    LOOP AT ct_files ASSIGNING <ls_files>.
      lv_index = sy-tabix.
      IF lo_dot->is_ignored( iv_path     = <ls_files>-path
                             iv_filename = <ls_files>-filename ) = abap_true.
        DELETE ct_files INDEX lv_index.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD remove_locally_excluded_files.

    DATA ls_ls TYPE zif_abapgit_persistence=>ty_repo-local_settings.
    DATA lv_excl TYPE string.
    DATA lv_full_path TYPE string.

    FIELD-SYMBOLS <ls_rfile> LIKE LINE OF ct_rem_files.
    FIELD-SYMBOLS <ls_lfile> LIKE LINE OF ct_loc_files.

    ls_ls = get_local_settings( ).

    LOOP AT ls_ls-exclude_remote_paths INTO lv_excl.
      CHECK lv_excl IS NOT INITIAL.

      IF ct_rem_files IS SUPPLIED.
        LOOP AT ct_rem_files ASSIGNING <ls_rfile>.
          lv_full_path = <ls_rfile>-path && <ls_rfile>-filename.
          IF lv_full_path CP lv_excl.
            DELETE ct_rem_files INDEX sy-tabix.
          ENDIF.
        ENDLOOP.

      ELSEIF ct_loc_files IS SUPPLIED.
        LOOP AT ct_loc_files ASSIGNING <ls_lfile>.
          lv_full_path = <ls_lfile>-file-path && <ls_lfile>-file-filename.
          IF lv_full_path CP lv_excl.
            DELETE ct_loc_files INDEX sy-tabix.
          ENDIF.
        ENDLOOP.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD reset_remote.
    CLEAR mt_remote.
    mv_request_remote_refresh = abap_true.
  ENDMETHOD.


  METHOD set.

* TODO: refactor, maybe use zcl_abapgit_string_map ?

    DATA: ls_mask TYPE zif_abapgit_persistence=>ty_repo_meta_mask.


    ASSERT iv_url IS SUPPLIED
      OR iv_branch_name IS SUPPLIED
      OR iv_selected_commit IS SUPPLIED
      OR iv_head_branch IS SUPPLIED
      OR iv_offline IS SUPPLIED
      OR is_dot_abapgit IS SUPPLIED
      OR is_local_settings IS SUPPLIED
      OR iv_deserialized_by IS SUPPLIED
      OR iv_deserialized_at IS SUPPLIED
      OR iv_switched_origin IS SUPPLIED.


    IF iv_url IS SUPPLIED.
      ms_data-url = iv_url.
      ls_mask-url = abap_true.
    ENDIF.

    IF iv_branch_name IS SUPPLIED.
      ms_data-branch_name = iv_branch_name.
      ls_mask-branch_name = abap_true.
    ENDIF.

    IF iv_selected_commit IS SUPPLIED.
      ms_data-selected_commit = iv_selected_commit.
      ls_mask-selected_commit = abap_true.
    ENDIF.

    IF iv_head_branch IS SUPPLIED.
      ms_data-head_branch = iv_head_branch.
      ls_mask-head_branch = abap_true.
    ENDIF.

    IF iv_offline IS SUPPLIED.
      ms_data-offline = iv_offline.
      ls_mask-offline = abap_true.
    ENDIF.

    IF is_dot_abapgit IS SUPPLIED.
      ms_data-dot_abapgit = is_dot_abapgit.
      ls_mask-dot_abapgit = abap_true.
    ENDIF.

    IF is_local_settings IS SUPPLIED.
      ms_data-local_settings = is_local_settings.
      ls_mask-local_settings = abap_true.
      normalize_local_settings( CHANGING cs_local_settings = ms_data-local_settings ).
    ENDIF.

    IF iv_deserialized_at IS SUPPLIED OR iv_deserialized_by IS SUPPLIED.
      ms_data-deserialized_at = iv_deserialized_at.
      ms_data-deserialized_by = iv_deserialized_by.
      ls_mask-deserialized_at = abap_true.
      ls_mask-deserialized_by = abap_true.
    ENDIF.

    IF iv_switched_origin IS SUPPLIED.
      ms_data-switched_origin = iv_switched_origin.
      ls_mask-switched_origin = abap_true.
    ENDIF.

    notify_listener( ls_mask ).

  ENDMETHOD.


  METHOD set_dot_apack.
    get_dot_apack( ).
    mo_apack_reader->set_manifest_descriptor( io_dot_apack->get_manifest_descriptor( ) ).
  ENDMETHOD.


  METHOD zif_abapgit_repo~set_files_remote.

    mt_remote = it_files.
    mv_request_remote_refresh = abap_false.

  ENDMETHOD.


  METHOD zif_abapgit_repo~set_local_settings.

    set( is_local_settings = is_settings ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~switch_repo_type.

    IF iv_offline = ms_data-offline.
      zcx_abapgit_exception=>raise( |Cannot switch_repo_type, offline already = "{ ms_data-offline }"| ).
    ENDIF.

    IF iv_offline = abap_true. " On-line -> OFFline
      set( iv_url             = zcl_abapgit_url=>name( ms_data-url )
           iv_branch_name     = ''
           iv_selected_commit = ''
           iv_head_branch     = ''
           iv_offline         = abap_true ).
    ELSE. " OFFline -> On-line
      set( iv_offline = abap_false ).
    ENDIF.

  ENDMETHOD.


  METHOD update_last_deserialize.

    DATA: lv_deserialized_at TYPE zif_abapgit_persistence=>ty_repo-deserialized_at,
          lv_deserialized_by TYPE zif_abapgit_persistence=>ty_repo-deserialized_by.

    GET TIME STAMP FIELD lv_deserialized_at.
    lv_deserialized_by = sy-uname.

    set( iv_deserialized_at = lv_deserialized_at
         iv_deserialized_by = lv_deserialized_by ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~checksums.

    CREATE OBJECT ri_checksums TYPE zcl_abapgit_repo_checksums
      EXPORTING
        iv_repo_key = ms_data-key.

  ENDMETHOD.


  METHOD zif_abapgit_repo~deserialize.

    DATA lt_updated_files TYPE zif_abapgit_git_definitions=>ty_file_signatures_tt.

    find_remote_dot_abapgit( ).
    find_remote_dot_apack( ).

    check_write_protect( ).
    check_language( ).

    IF is_checks-requirements-met = zif_abapgit_definitions=>c_no AND is_checks-requirements-decision IS INITIAL.
      zcx_abapgit_exception=>raise( 'Requirements not met and undecided' ).
    ENDIF.

    IF is_checks-dependencies-met = zif_abapgit_definitions=>c_no AND is_checks-dependencies-decision IS INITIAL.
      zcx_abapgit_exception=>raise( 'APACK dependencies not met and undecided' ).
    ENDIF.

    IF is_checks-transport-required = abap_true AND is_checks-transport-transport IS INITIAL.
      zcx_abapgit_exception=>raise( |No transport request was supplied| ).
    ENDIF.

    deserialize_dot_abapgit( CHANGING ct_files = lt_updated_files ).

    deserialize_objects(
      EXPORTING
        is_checks = is_checks
        ii_log    = ii_log
      CHANGING
        ct_files  = lt_updated_files ).

    deserialize_data(
      EXPORTING
        is_checks = is_checks
      CHANGING
        ct_files  = lt_updated_files ).

    CLEAR mt_local. " Should be before CS update which uses NEW local

    checksums( )->update( lt_updated_files ).

    update_last_deserialize( ).

    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD zif_abapgit_repo~deserialize_checks.

    DATA: lt_requirements TYPE zif_abapgit_dot_abapgit=>ty_requirement_tt,
          lt_dependencies TYPE zif_abapgit_apack_definitions=>ty_dependencies.

    find_remote_dot_abapgit( ).
    find_remote_dot_apack( ).

    check_write_protect( ).
    check_language( ).
    check_abap_language_version( ).

    rs_checks = zcl_abapgit_objects=>deserialize_checks( me ).

    lt_requirements = get_dot_abapgit( )->get_data( )-requirements.
    rs_checks-requirements-met = zcl_abapgit_repo_requirements=>is_requirements_met( lt_requirements ).

    lt_dependencies = get_dot_apack( )->get_manifest_descriptor( )-dependencies.
    rs_checks-dependencies-met = zcl_abapgit_apack_helper=>are_dependencies_met( lt_dependencies ).

    rs_checks-customizing = zcl_abapgit_data_factory=>get_deserializer( )->deserialize_check(
      ii_repo   = me
      ii_config = get_data_config( ) ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~find_remote_dot_abapgit.

    FIELD-SYMBOLS: <ls_remote> LIKE LINE OF mt_remote.

    get_files_remote( ).

    READ TABLE mt_remote ASSIGNING <ls_remote>
      WITH KEY file_path
      COMPONENTS path     = zif_abapgit_definitions=>c_root_dir
                 filename = zif_abapgit_definitions=>c_dot_abapgit.
    IF sy-subrc = 0.
      ro_dot = zcl_abapgit_dot_abapgit=>deserialize( <ls_remote>-data ).
      set_dot_abapgit( ro_dot ).
      COMMIT WORK AND WAIT. " to release lock
    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_dot_abapgit.
    CREATE OBJECT ro_dot_abapgit
      EXPORTING
        is_data = ms_data-dot_abapgit.
  ENDMETHOD.


  METHOD zif_abapgit_repo~get_files_local.

    DATA lo_serialize TYPE REF TO zcl_abapgit_serialize.

    " Serialization happened before and no refresh request
    IF lines( mt_local ) > 0 AND mv_request_local_refresh = abap_false.
      rt_files = mt_local.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_serialize
      EXPORTING
        io_dot_abapgit    = get_dot_abapgit( )
        is_local_settings = get_local_settings( ).

    rt_files = lo_serialize->files_local(
      iv_package     = get_package( )
      ii_data_config = get_data_config( )
      ii_log         = ii_log ).

    remove_locally_excluded_files( CHANGING ct_loc_files = rt_files ).

    mt_local                 = rt_files.
    mv_request_local_refresh = abap_false. " Fulfill refresh

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_files_local_filtered.

    DATA lo_serialize TYPE REF TO zcl_abapgit_serialize.
    DATA lt_filter TYPE zif_abapgit_definitions=>ty_tadir_tt.


    CREATE OBJECT lo_serialize
      EXPORTING
        io_dot_abapgit    = get_dot_abapgit( )
        is_local_settings = get_local_settings( ).

    lt_filter = ii_obj_filter->get_filter( ).

    rt_files = lo_serialize->files_local(
      iv_package     = get_package( )
      ii_data_config = get_data_config( )
      ii_log         = ii_log
      it_filter      = lt_filter ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_files_remote.
    DATA lt_filter TYPE zif_abapgit_definitions=>ty_tadir_tt.
    DATA lr_filter TYPE REF TO zcl_abapgit_repo_filter.

    rt_files = mt_remote.

    "Filter Ignored Files prior to Applying a Filter
    IF iv_ignore_files = abap_true.
      remove_ignored_files( CHANGING ct_files = rt_files ).
    ENDIF.

    remove_locally_excluded_files( CHANGING ct_rem_files = rt_files ).

    IF ii_obj_filter IS NOT INITIAL.
      lt_filter = ii_obj_filter->get_filter( ).

      CREATE OBJECT lr_filter.
      lr_filter->apply_object_filter(
        EXPORTING
          it_filter   = lt_filter
          io_dot      = get_dot_abapgit( )
          iv_devclass = get_package( )
        CHANGING
          ct_files    = rt_files ).

    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_key.
    rv_key = ms_data-key.
  ENDMETHOD.


  METHOD zif_abapgit_repo~get_local_settings.

    rs_settings = ms_data-local_settings.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_name.

    " Local display name has priority over official name
    rv_name = ms_data-local_settings-display_name.
    IF rv_name IS INITIAL.
      rv_name = ms_data-dot_abapgit-name.
    ENDIF.

  ENDMETHOD.


  METHOD zif_abapgit_repo~get_package.
    rv_package = ms_data-package.
  ENDMETHOD.


  METHOD zif_abapgit_repo~get_tadir_objects.

    rt_tadir = zcl_abapgit_factory=>get_tadir( )->read(
      iv_package            = get_package( )
      iv_ignore_subpackages = get_local_settings( )-ignore_subpackages
      iv_only_local_objects = get_local_settings( )-only_local_objects
      io_dot                = get_dot_abapgit( ) ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~has_remote_source.
    rv_yes = boolc( lines( mt_remote ) > 0 ).
  ENDMETHOD.


  METHOD zif_abapgit_repo~is_offline.
    rv_offline = ms_data-offline.
  ENDMETHOD.


  METHOD zif_abapgit_repo~refresh.

    mv_request_local_refresh = abap_true.
    reset_remote( ).

    IF iv_drop_log = abap_true.
      CLEAR mi_log.
    ENDIF.

    IF iv_drop_cache = abap_true.
      CLEAR mt_local.
    ENDIF.

    get_dot_apack( )->refresh( ).

  ENDMETHOD.


  METHOD zif_abapgit_repo~set_dot_abapgit.
    set( is_dot_abapgit = io_dot_abapgit->get_data( ) ).
  ENDMETHOD.
ENDCLASS.
