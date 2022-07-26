# ADD_GOS
## Add GOS on screen

### This example allow you to add standard button GOS with full functionality.

> Method LCL_GOS=>GET_INSTANCE(Singleton) return self-example with already created instance of class CL_GOS_MANAGER.
This standard class used to work with GOS functionality, and also adding button ![alt text](https://github.com/Sgudkov/ADD_GOS/blob/main/GOS_button.jpg) to your screen.

> Method LCL_GOS->COPY_GOS_LINK can use for copy already created data to new object.

### Propose usage.

For example you need to add this functionality to transaction FR58. In standard t-code this button doesn't available, because we don't have yet document number.
In this example document number using like a object key.

This example which we mentioned above.
 
*Added in PBO in end of form 'va_funds_init_1_pbo'*
```abap
IF go_myobject IS INITIAL AND g_con_info-belnr IS INITIAL.

  ls_object-objkey  = g_con_info-belnr.
  ls_object-objtype = 'FMBU'.

  ls_service-SIGN   = 'E'.
  ls_service-option = 'EQ'.
  ls_service-low = 'WF_START'.
  APPEND ls_service TO lt_services.
  ls_service-low = 'BARCODE'.
  APPEND ls_service TO lt_services.

  lcl_gos=>get_instance(
    EXPORTING
      is_object            = ls_object
      iv_mode              = lip_mode
      iv_no_commit         = abap_true
      it_service_selection = lt_services
    IMPORTING
      ev_instance = go_gos_additional
    EXCEPTIONS
      OTHERS = 1
    ).

ENDIF.
```


> Internal table *lt_services* use for exclude some services. See all available services in table 'SGOSATTR'. 

> Set parameter 'iv_no_commit' to X doesn't create raw in DB. It's usfull for our example.


*Added after post data in begining of form 'control_terminate_main'*
```abap
 IF go_gos_additional IS NOT INITIAL AND g_con_info-bpdk_belnr IS NOT INITIAL.
   go_gos_additional->copy_gos_link( EXPORTING iv_objkey = g_con_info-bpdk_belnr ).
 ENDIF.
```	
