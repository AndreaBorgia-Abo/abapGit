FUNCTION z_abapgit_serialize_parallel.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_OBJ_TYPE) TYPE  TADIR-OBJECT
*"     VALUE(IV_OBJ_NAME) TYPE  TADIR-OBJ_NAME
*"     VALUE(IV_DEVCLASS) TYPE  TADIR-DEVCLASS
*"     VALUE(IV_SRCSYSTEM) TYPE  TADIR-SRCSYSTEM
*"     VALUE(IV_ABAP_LANGUAGE_VERS) TYPE  UCCHECK
*"     VALUE(IV_LANGUAGE) TYPE  SY-LANGU
*"     VALUE(IV_PATH) TYPE  STRING
*"     VALUE(IV_MAIN_LANGUAGE_ONLY) TYPE  CHAR1
*"     VALUE(IV_SUPPRESS_PO_COMMENTS) TYPE  CHAR1
*"     VALUE(IT_TRANSLATION_LANGS) TYPE  TFPLAISO
*"     VALUE(IV_USE_LXE) TYPE  CHAR1
*"  EXPORTING
*"     VALUE(EV_RESULT) TYPE  XSTRING
*"     VALUE(EV_PATH) TYPE  STRING
*"  EXCEPTIONS
*"      ERROR
*"----------------------------------------------------------------------

  DATA: ls_item  TYPE zif_abapgit_definitions=>ty_item,
        lx_error TYPE REF TO zcx_abapgit_exception,
        lv_text  TYPE c LENGTH 200,
        ls_i18n_params TYPE zif_abapgit_definitions=>ty_i18n_params,
        ls_files TYPE zif_abapgit_objects=>ty_serialization.

  TRY.
      ls_item-obj_type  = iv_obj_type.
      ls_item-obj_name  = iv_obj_name.
      ls_item-devclass  = iv_devclass.
      ls_item-srcsystem = iv_srcsystem.
      ls_item-abap_language_version = iv_abap_language_vers.

      ls_i18n_params-main_language         = iv_language.
      ls_i18n_params-main_language_only    = iv_main_language_only.
      ls_i18n_params-suppress_po_comments  = iv_suppress_po_comments.
      ls_i18n_params-use_lxe               = iv_use_lxe.
      ls_i18n_params-translation_languages = it_translation_langs.

      ls_files = zcl_abapgit_objects=>serialize(
        is_item        = ls_item
        io_i18n_params = zcl_abapgit_i18n_params=>new( is_params = ls_i18n_params ) ).

      EXPORT data = ls_files TO DATA BUFFER ev_result.
      ev_path = iv_path.

    CATCH zcx_abapgit_exception INTO lx_error.
      lv_text = lx_error->get_text( ).
      MESSAGE s000(oo) RAISING error WITH
        lv_text+0(50)
        lv_text+50(50)
        lv_text+100(50)
        lv_text+150(50).
  ENDTRY.

ENDFUNCTION.
