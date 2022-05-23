import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenants_application_details_state.freezed.dart';

@freezed
abstract class TenantsApplicationDetailsState
    with _$TenantsApplicationDetailsState {
  factory TenantsApplicationDetailsState({
    required String ApplicantID,
    required String ApplicationID,
    SystemEnumDetails? ApplicationStatus,
    required double Rating,
    required String RatingReview,

    /*Personal info*/
    required String perFirstname,
    required String perLastname,
    DateTime? dateofbirth,
    required String perAge,
    required String perEmail,
    required String perPhoneNumber,
    required String perCountryCode,
    required String perDialCode,
    required String perStory,
    required String Person_ID,
    required String Note,

    /*Employment info*/
    required String othersourceincome,
    required String linkedprofile,
    required List<TenancyEmploymentInformation> listoccupation,
    SystemEnumDetails? empstatus,
    SystemEnumDetails? anualincomestatus,
    required String EmploymentID,

    /*Current tenacy info*/
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
    required String CurrentTenancyID,
    required String CurrentLandLordID,

    /*Tenancy Occupant info*/
    required List<TenancyAdditionalOccupant> occupantlist,
    required bool notapplicable,

    /*Additional info*/
    required List<Pets> petslist,
    required bool isPets,
    required List<Vehical> vehicallist,
    required bool isVehical,
    required bool isSmoking,
    required String Comment,
    DateTime? tenancystartdate,
    SystemEnumDetails? lenthoftenancy,
    SystemEnumDetails? IntendedPeriod,
    required String IntendedPeriodNo,

    /*Reference info*/
    required List<TenancyAdditionalReference> referencelist,
  }) = _TenantsApplicationDetailsState;

  factory TenantsApplicationDetailsState.initial() =>
      TenantsApplicationDetailsState(
        ApplicantID: "",
        ApplicationID: "",
        ApplicationStatus: null,
        Rating: 0,
        RatingReview: "",

        /*Personal info*/
        perFirstname: "",
        perLastname: "",
        dateofbirth: null,
        perAge: "",
        perEmail: "",
        perPhoneNumber: "",
        perCountryCode: "CA",
        perDialCode: "+1",
        perStory: "",
        Person_ID: "",
        Note: "",

        /*Employment info*/
        othersourceincome: "",
        linkedprofile: "",
        listoccupation: List.empty(),
        empstatus: null,
        anualincomestatus: null,
        EmploymentID: "",

        /*Current tenacy info*/
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
        CurrentTenancyID: "",
        CurrentLandLordID: "",

        /*Tenancy Occupant info*/
        occupantlist: List.empty(),
        notapplicable: false,

        /*Additional info*/
        petslist: List.empty(),
        isPets: false,
        vehicallist: List.empty(),
        isVehical: false,
        isSmoking: false,
        Comment: "",
        tenancystartdate: null,
        lenthoftenancy: null,
        IntendedPeriod: null,
        IntendedPeriodNo: "",

        /*Reference info*/
        referencelist: List.empty(),
      );
}
