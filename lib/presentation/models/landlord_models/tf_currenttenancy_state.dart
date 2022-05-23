import 'package:freezed_annotation/freezed_annotation.dart';

part 'tf_currenttenancy_state.freezed.dart';

@freezed
abstract class TFCurrentTenancyState with _$TFCurrentTenancyState {
  const factory TFCurrentTenancyState({
    DateTime? ct_startdate,
    DateTime? ct_enddate,
    required String suiteunit,
    required String ct_address,
    required String ct_city,
    required String ct_province,
    required String ct_postalcode,
    required String cl_firstname,
    required String cl_lastname,
    required String cl_email,
    required String cl_phonenumber,
    required String cl_code,
    required String cl_dailcode,
    required bool cl_isReference,
    required bool isUpdate,
    required String CurrentTenancyID,
    required String CurrentLandLordID,

    //Final value
    DateTime? FNLct_startdate,
    DateTime? FNLct_enddate,
    required String FNLsuiteunit,
    required String FNLct_address,
    required String FNLct_city,
    required String FNLct_province,
    required String FNLct_postalcode,
    required String FNLcl_firstname,
    required String FNLcl_lastname,
    required String FNLcl_email,
    required String FNLcl_phonenumber,
    required String FNLcl_code,
    required String FNLcl_dailcode,
    required bool FNLcl_isReference,

    /*Error Flag*/
    required bool error_startdate,
    required bool error_enddate,
    required bool error_address,
    required bool error_city,
    required bool error_province,
    required bool error_postalcode,
    required bool error_firstname,
    required bool error_lastname,
    required bool error_email,
    required bool error_phonenumber,
  }) = _TFCurrentTenancyState;

  factory TFCurrentTenancyState.initial() => TFCurrentTenancyState(
        ct_startdate: null,
        ct_enddate: null,
        suiteunit: "",
        ct_address: "",
        ct_city: "",
        ct_province: "",
        ct_postalcode: "",
        cl_firstname: "",
        cl_lastname: "",
        cl_email: "",
        cl_phonenumber: "",
        cl_code: "CA",
        cl_dailcode: "+1",
        cl_isReference: false,
        FNLct_startdate: null,
        FNLct_enddate: null,
        FNLsuiteunit: "",
        FNLct_address: "",
        FNLct_city: "",
        FNLct_province: "",
        FNLct_postalcode: "",
        FNLcl_firstname: "",
        FNLcl_lastname: "",
        FNLcl_email: "",
        FNLcl_phonenumber: "",
        FNLcl_code: "CA",
        FNLcl_dailcode: "+1",
        FNLcl_isReference: false,
        isUpdate: false,
        CurrentTenancyID: "",
        CurrentLandLordID: "",

        /*Error Flag*/
        error_startdate: false,
        error_enddate: false,
        error_address: false,
        error_city: false,
        error_province: false,
        error_postalcode: false,
        error_firstname: false,
        error_lastname: false,
        error_email: false,
        error_phonenumber: false,
      );
}