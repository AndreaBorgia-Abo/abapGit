CLASS zcl_abapgit_injector DEFINITION
  PUBLIC
  FOR TESTING
  CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS set_tadir
      IMPORTING
        !ii_tadir TYPE REF TO zif_abapgit_tadir .
    CLASS-METHODS set_sap_package
      IMPORTING
        !iv_package     TYPE devclass
        !ii_sap_package TYPE REF TO zif_abapgit_sap_package .
    CLASS-METHODS set_cts_api
      IMPORTING
        !ii_cts_api TYPE REF TO zif_abapgit_cts_api .
    CLASS-METHODS set_environment
      IMPORTING
        !ii_environment TYPE REF TO zif_abapgit_environment .
    CLASS-METHODS set_longtexts
      IMPORTING
        !ii_longtexts TYPE REF TO zif_abapgit_longtexts .
    CLASS-METHODS set_lxe_texts
      IMPORTING
        !ii_lxe_texts TYPE REF TO zif_abapgit_lxe_texts .
    CLASS-METHODS set_sap_namespace
      IMPORTING
        !ii_namespace TYPE REF TO zif_abapgit_sap_namespace .
    CLASS-METHODS set_sap_report
      IMPORTING
        !ii_report TYPE REF TO zif_abapgit_sap_report.
    CLASS-METHODS set_function_module
      IMPORTING
        ii_function_module TYPE REF TO zif_abapgit_function_module.
    CLASS-METHODS set_exit
      IMPORTING
        ii_exit TYPE REF TO zif_abapgit_exit.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_abapgit_injector IMPLEMENTATION.


  METHOD set_cts_api.
    zcl_abapgit_factory=>gi_cts_api = ii_cts_api.
  ENDMETHOD.


  METHOD set_environment.
    zcl_abapgit_factory=>gi_environment = ii_environment.
  ENDMETHOD.


  METHOD set_exit.
    zcl_abapgit_exit=>gi_global_exit = ii_exit.
  ENDMETHOD.


  METHOD set_function_module.
    zcl_abapgit_factory=>gi_function_module = ii_function_module.
  ENDMETHOD.


  METHOD set_longtexts.
    zcl_abapgit_factory=>gi_longtext = ii_longtexts.
  ENDMETHOD.


  METHOD set_lxe_texts.
    zcl_abapgit_factory=>gi_lxe_texts = ii_lxe_texts.
  ENDMETHOD.


  METHOD set_sap_namespace.
    zcl_abapgit_factory=>gi_sap_namespace = ii_namespace.
  ENDMETHOD.


  METHOD set_sap_package.

    DATA: ls_sap_package TYPE zcl_abapgit_factory=>ty_sap_package.
    FIELD-SYMBOLS: <ls_sap_package> TYPE zcl_abapgit_factory=>ty_sap_package.

    READ TABLE zcl_abapgit_factory=>gt_sap_package
         ASSIGNING <ls_sap_package>
         WITH TABLE KEY package = iv_package.

    IF sy-subrc <> 0.

      ls_sap_package-package = iv_package.
      INSERT ls_sap_package
             INTO TABLE zcl_abapgit_factory=>gt_sap_package
             ASSIGNING <ls_sap_package>.

    ENDIF.

    <ls_sap_package>-instance = ii_sap_package.

  ENDMETHOD.


  METHOD set_sap_report.
    zcl_abapgit_factory=>gi_sap_report = ii_report.
  ENDMETHOD.


  METHOD set_tadir.
    zcl_abapgit_factory=>gi_tadir = ii_tadir.
  ENDMETHOD.
ENDCLASS.
