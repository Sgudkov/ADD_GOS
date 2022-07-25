TYPE-POOLS: abap.
 
*----------------------------------------------------------------------*
*       CLASS lcl_gos DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_gos DEFINITION CREATE PRIVATE FINAL.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF mc_s_obj,
          fmbu TYPE sibftypeid VALUE 'FMBU',
          bo   TYPE sibfcatid  VALUE 'BO',
        END OF   mc_s_obj .
    CLASS-DATA mo_gos TYPE REF TO lcl_gos READ-ONLY .

    CLASS-METHODS:
      get_instance
        IMPORTING
          is_object            TYPE borident OPTIONAL
          is_bc_object         TYPE sibflpor OPTIONAL
          iv_no_commit         TYPE sgs_cmode DEFAULT 'X'
          it_service_selection TYPE tgos_sels OPTIONAL
          iv_mode              TYPE sgs_rwmod DEFAULT 'E'
         EXPORTING
           ev_instance         TYPE REF TO lcl_gos.

    METHODS:
      copy_gos_link
        IMPORTING
          iv_objkey TYPE any OPTIONAL
          iv_commit TYPE boolean OPTIONAL.


  PRIVATE SECTION.
    DATA: mo_gos_manager TYPE REF TO cl_gos_manager,
          ms_source      TYPE sibflporb .

    METHODS:
      constructor
        IMPORTING
          is_object            TYPE borident
          is_bc_object         TYPE sibflpor
          iv_no_commit         TYPE sgs_cmode  DEFAULT 'X'
          it_service_selection TYPE tgos_sels
          iv_mode              TYPE sgs_rwmod.

ENDCLASS.                    "lcl_gos DEFINITION


*----------------------------------------------------------------------*
*       CLASS lcl_gos IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_gos IMPLEMENTATION.

  METHOD get_instance.
    IF mo_gos IS NOT BOUND.
      CREATE OBJECT mo_gos
        EXPORTING
          is_object            = is_object
          is_bc_object         = is_bc_object
          iv_no_commit         = iv_no_commit
          iv_mode              = iv_mode
          it_service_selection = it_service_selection.
    ENDIF.

    ev_instance = mo_gos.
  ENDMETHOD.                    "get_instance

  METHOD copy_gos_link.
    DATA: ls_target TYPE sibflporb.

    ls_target-typeid = mc_s_obj-fmbu.
    ls_target-catid  = mc_s_obj-bo.
    ls_target-instid = iv_objkey.

    cl_gos_service_tools=>move_linked_objects(
                            is_source = ms_source
                            is_target = ls_target ).

    IF iv_commit = abap_true.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.                    "copy_gos_link

  METHOD constructor.

    IF is_object IS NOT INITIAL.
      ms_source-typeid = is_object-objtype.
      ms_source-catid  = mc_s_obj-bo.
      ms_source-instid = is_object-objkey.
    ELSEIF is_bc_object IS NOT INITIAL.
      MOVE-CORRESPONDING is_bc_object TO ms_source.
    ENDIF.

    CREATE OBJECT mo_gos_manager
      EXPORTING
        is_object            = is_object
        is_bc_object         = is_bc_object
        ip_start_direct      = space
        ip_no_commit         = iv_no_commit
        ip_mode              = iv_mode
        it_service_selection = it_service_selection.

  ENDMETHOD.                    "constructor

ENDCLASS.                    "lcl_gos IMPLEMENTATION