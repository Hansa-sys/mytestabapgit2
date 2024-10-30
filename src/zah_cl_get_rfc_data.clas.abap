CLASS zah_cl_get_rfc_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZAH_CL_GET_RFC_DATA IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    TYPES: BEGIN OF ty_rfcsi,
             rfcproto    TYPE c LENGTH 3,
             rfcchartyp  TYPE c LENGTH 4,
             rfcinttyp   TYPE c LENGTH 3,
             rfcflotyp   TYPE c LENGTH 3,
             rfcdest     TYPE c LENGTH 32,
             rfchost     TYPE c LENGTH 8,
             rfcsysid    TYPE c LENGTH 8,
             rfcdatabs   TYPE c LENGTH 8,
             rfcdbhost   TYPE c LENGTH 32,
             rfcdbsys    TYPE c LENGTH 10,
             rfcsaprl    TYPE c LENGTH 4,
             rfcmach     TYPE c LENGTH 5,
             rfcopsys    TYPE c LENGTH 10,
             rfctzone    TYPE c LENGTH 6,
             rfcdayst    TYPE c LENGTH 1,
             rfcipaddr   TYPE c LENGTH 15,
             rfckernrl   TYPE c LENGTH 4,
             rfchost2    TYPE c LENGTH 32,
             rfcsi_resv  TYPE c LENGTH 12,
             rfcipv6addr TYPE c LENGTH 45,
           END OF ty_rfcsi.

    DATA: ls_rfcsi TYPE ty_rfcsi,
          lt_rfcsi TYPE TABLE OF ty_rfcsi.

    TRY.
        DATA(lo_destination) = cl_rfc_destination_provider=>create_by_comm_arrangement(

                          comm_scenario          = 'ZAH_OUTBOUND_RFC_000_CSCEN'
*                                        service_id             = 'Z_OUTBOUND_RFC_000_SRFC'
*                                        comm_system_id         = 'ZAH_TED'
                          ).

        DATA(lv_destination) = lo_destination->get_destination_name( ).

        "Check if data is requested
        IF io_request->is_data_requested(  ).
          DATA(lv_skip) = io_request->get_paging( )->get_offset(  ).
          DATA(lv_top) = io_request->get_paging( )->get_page_size(  ).

          CALL FUNCTION 'RFC_SYSTEM_INFO'
            DESTINATION lv_destination
            IMPORTING
              rfcsi_export = ls_rfcsi.

          APPEND ls_rfcsi TO lt_rfcsi.

          "Set total no. of records
          io_response->set_total_number_of_records( lines( lt_rfcsi ) ).
          "Output data
          io_response->set_data( lt_rfcsi ).
        ENDIF.

      CATCH  cx_rfc_dest_provider_error INTO DATA(lx_dest).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
