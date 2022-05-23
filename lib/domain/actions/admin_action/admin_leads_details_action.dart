import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateAdminLeadDetailApplicantID implements Action {
  final String ApplicantID;

  UpdateAdminLeadDetailApplicantID(this.ApplicantID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ApplicantID: ApplicantID);
  }
}

class UpdateAdminLeadDetailApplicationID implements Action {
  final String ApplicationID;

  UpdateAdminLeadDetailApplicationID(this.ApplicationID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ApplicationID: ApplicationID);
  }
}

class UpdateAdminLeadDetailApplicationStatus implements Action {
  final SystemEnumDetails? ApplicationStatus;

  UpdateAdminLeadDetailApplicationStatus(this.ApplicationStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ApplicationStatus: ApplicationStatus);
  }
}

class UpdateAdminLeadDetailRating implements Action {
  final double Rating;

  UpdateAdminLeadDetailRating(this.Rating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(Rating: Rating);
  }
}

class UpdateAdminLeadDetailRatingReview implements Action {
  final String RatingReview;

  UpdateAdminLeadDetailRatingReview(this.RatingReview);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(RatingReview: RatingReview);
  }
}

/*=============================================================*/
/*Personal info*/
/*=============================================================*/

class UpdateAdminLeadDetailFirstname implements Action {
  final String Firstname;

  UpdateAdminLeadDetailFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(perFirstname: Firstname);
  }
}

class UpdateAdminLeadDetailLastname implements Action {
  final String Lastname;

  UpdateAdminLeadDetailLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(perLastname: Lastname);
  }
}

class UpdateAdminLeadDetailDateofBirth implements Action {
  final DateTime? dateofbirth;

  UpdateAdminLeadDetailDateofBirth(this.dateofbirth);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(dateofbirth: dateofbirth);
  }
}

class UpdateAdminLeadDetailAge implements Action {
  final String perAge;

  UpdateAdminLeadDetailAge(this.perAge);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(perAge: perAge);
  }
}

class UpdateAdminLeadDetailEmail implements Action {
  final String Email;

  UpdateAdminLeadDetailEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(perEmail: Email);
  }
}

class UpdateAdminLeadDetailPhoneNumber implements Action {
  final String PhoneNumber;

  UpdateAdminLeadDetailPhoneNumber(this.PhoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(perPhoneNumber: PhoneNumber);
  }
}

class UpdateAdminLeadDetailCountryCode implements Action {
  final String CountryCode;

  UpdateAdminLeadDetailCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(perCountryCode: CountryCode);
  }
}

class UpdateAdminLeadDetailDialCode implements Action {
  final String DialCode;

  UpdateAdminLeadDetailDialCode(this.DialCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(perDialCode: DialCode);
  }
}

class UpdateAdminLeadDetailStory implements Action {
  final String Story;

  UpdateAdminLeadDetailStory(this.Story);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(perStory: Story);
  }
}

class UpdateAdminLeadDetailPersonID implements Action {
  final String PersonID;

  UpdateAdminLeadDetailPersonID(this.PersonID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(Person_ID: PersonID);
  }
}

/*=============================================================*/
/*Employment info*/
/*=============================================================*/

class UpdateAdminLeadDetailothersourceincome implements Action {
  final String othersourceincome;

  UpdateAdminLeadDetailothersourceincome(this.othersourceincome);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(othersourceincome: othersourceincome);
  }
}

class UpdateAdminLeadDetaillinkedprofile implements Action {
  final String linkedprofile;

  UpdateAdminLeadDetaillinkedprofile(this.linkedprofile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(linkedprofile: linkedprofile);
  }
}

class UpdateAdminLeadDetailAnualincomestatus implements Action {
  final SystemEnumDetails? annualincomevalue;

  UpdateAdminLeadDetailAnualincomestatus(this.annualincomevalue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(anualincomestatus: annualincomevalue);
  }
}

class UpdateAdminLeadDetaillistoccupation implements Action {
  final List<TenancyEmploymentInformation> listoccupation1;

  UpdateAdminLeadDetaillistoccupation(this.listoccupation1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(listoccupation: listoccupation1);
  }
}

class UpdateAdminLeadDetailempstatus implements Action {
  final SystemEnumDetails? empstatus;

  UpdateAdminLeadDetailempstatus(this.empstatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(empstatus: empstatus);
  }
}

class UpdateAdminLeadDetailEmploymentID implements Action {
  final String EmploymentID;

  UpdateAdminLeadDetailEmploymentID(this.EmploymentID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(EmploymentID: EmploymentID);
  }
}

/*=============================================================*/
/*Current tenacy info*/
/*=============================================================*/

class UpdateAdminLeadDetailCurrenttenantStartDate implements Action {
  final DateTime? StartDate;

  UpdateAdminLeadDetailCurrenttenantStartDate(this.StartDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ct_startdate: StartDate);
  }
}

class UpdateAdminLeadDetailCurrenttenantEndDate implements Action {
  final DateTime? EndDate;

  UpdateAdminLeadDetailCurrenttenantEndDate(this.EndDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ct_enddate: EndDate);
  }
}

class UpdateAdminLeadDetailCurrenttenantSuiteUnit implements Action {
  final String SuiteUnit;

  UpdateAdminLeadDetailCurrenttenantSuiteUnit(this.SuiteUnit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(suiteunit: SuiteUnit);
  }
}

class UpdateAdminLeadDetailCurrenttenantAddress implements Action {
  final String Address;

  UpdateAdminLeadDetailCurrenttenantAddress(this.Address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ct_address: Address);
  }
}

class UpdateAdminLeadDetailCurrenttenantCity implements Action {
  final String City;

  UpdateAdminLeadDetailCurrenttenantCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(ct_city: City);
  }
}

class UpdateAdminLeadDetailCurrenttenantProvince implements Action {
  final String Province;

  UpdateAdminLeadDetailCurrenttenantProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ct_province: Province);
  }
}

class UpdateAdminLeadDetailCurrenttenantPostalcode implements Action {
  final String Postalcode;

  UpdateAdminLeadDetailCurrenttenantPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(ct_postalcode: Postalcode);
  }
}

class UpdateAdminLeadDetailCurrenttenantFirstname implements Action {
  final String Firstname;

  UpdateAdminLeadDetailCurrenttenantFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(cl_firstname: Firstname);
  }
}

class UpdateAdminLeadDetailCurrenttenantLastname implements Action {
  final String Lastname;

  UpdateAdminLeadDetailCurrenttenantLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(cl_lastname: Lastname);
  }
}

class UpdateAdminLeadDetailCurrenttenantEmail implements Action {
  final String Email;

  UpdateAdminLeadDetailCurrenttenantEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(cl_email: Email);
  }
}

class UpdateAdminLeadDetailCurrenttenantPhonenumber implements Action {
  final String Phonenumber;

  UpdateAdminLeadDetailCurrenttenantPhonenumber(this.Phonenumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(cl_phonenumber: Phonenumber);
  }
}

class UpdateAdminLeadDetailCurrenttenantCode implements Action {
  final String Code;

  UpdateAdminLeadDetailCurrenttenantCode(this.Code);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(cl_code: Code);
  }
}

class UpdateAdminLeadDetailCurrenttenantDailCode implements Action {
  final String DailCode;

  UpdateAdminLeadDetailCurrenttenantDailCode(this.DailCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(cl_dailcode: DailCode);
  }
}

class UpdateAdminLeadDetailCurrenttenantisReference implements Action {
  final bool isReference;

  UpdateAdminLeadDetailCurrenttenantisReference(this.isReference);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(cl_isReference: isReference);
  }
}

class UpdateAdminLeadDetailCurrenttenantCurrentTenancyID implements Action {
  final String CurrentTenancyID;

  UpdateAdminLeadDetailCurrenttenantCurrentTenancyID(this.CurrentTenancyID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(CurrentTenancyID: CurrentTenancyID);
  }
}

class UpdateAdminLeadDetailCurrenttenantCurrentLandLordID implements Action {
  final String CurrentLandLordID;

  UpdateAdminLeadDetailCurrenttenantCurrentLandLordID(this.CurrentLandLordID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(CurrentLandLordID: CurrentLandLordID);
  }
}

/*=============================================================*/
/*Tenancy Occupant info*/
/*=============================================================*/

class UpdateAdminLeadDetailAddOccupantlist implements Action {
  final List<TenancyAdditionalOccupant> occupantlist;

  UpdateAdminLeadDetailAddOccupantlist(this.occupantlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(occupantlist: occupantlist);
  }
}

class UpdateAdminLeadDetailAddOccupantNotApplicable implements Action {
  final bool notapplicable;

  UpdateAdminLeadDetailAddOccupantNotApplicable(this.notapplicable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(notapplicable: notapplicable);
  }
}

/*=============================================================*/
/*Additional info*/
/*=============================================================*/

class UpdateAdminLeadDetailAdditionalInfoPetslist implements Action {
  final List<Pets> petslist1;

  UpdateAdminLeadDetailAdditionalInfoPetslist(this.petslist1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(petslist: petslist1);
  }
}

class UpdateAdminLeadDetailAdditionalInfoIspets implements Action {
  final bool ispet;

  UpdateAdminLeadDetailAdditionalInfoIspets(this.ispet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(isPets: ispet);
  }
}

class UpdateAdminLeadDetailAdditionalInfoVehicallist implements Action {
  final List<Vehical> vehicallist;

  UpdateAdminLeadDetailAdditionalInfoVehicallist(this.vehicallist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(vehicallist: vehicallist);
  }
}

class UpdateAdminLeadDetailAdditionalInfoisVehical implements Action {
  final bool isVehical;

  UpdateAdminLeadDetailAdditionalInfoisVehical(this.isVehical);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(isVehical: isVehical);
  }
}

class UpdateAdminLeadDetailAdditionalInfoisSmoking implements Action {
  final bool isSmoking;

  UpdateAdminLeadDetailAdditionalInfoisSmoking(this.isSmoking);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(isSmoking: isSmoking);
  }
}

class UpdateAdminLeadDetailAdditionalInfoComment implements Action {
  final String Comment;

  UpdateAdminLeadDetailAdditionalInfoComment(this.Comment);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordLeadsDetailsState(Comment: Comment);
  }
}

class UpdateAdminLeadDetailAdditionalInfoTenancyStartDate implements Action {
  final DateTime? tenancystartdate;

  UpdateAdminLeadDetailAdditionalInfoTenancyStartDate(this.tenancystartdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(tenancystartdate: tenancystartdate);
  }
}

class UpdateAdminLeadDetailAdditionalInfoLenthOfTenancy implements Action {
  final SystemEnumDetails? lenthoftenancy;

  UpdateAdminLeadDetailAdditionalInfoLenthOfTenancy(this.lenthoftenancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(lenthoftenancy: lenthoftenancy);
  }
}

class UpdateAdminLeadDetailAdditionalInfoIntendedPeriod implements Action {
  final SystemEnumDetails? IntendedPeriod;

  UpdateAdminLeadDetailAdditionalInfoIntendedPeriod(this.IntendedPeriod);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(IntendedPeriod: IntendedPeriod);
  }
}

class UpdateAdminLeadDetailAdditionalInfoIntendedPeriodNo implements Action {
  final String IntendedPeriodNo;

  UpdateAdminLeadDetailAdditionalInfoIntendedPeriodNo(this.IntendedPeriodNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(IntendedPeriodNo: IntendedPeriodNo);
  }
}

/*=============================================================*/
/*Reference info*/
/*=============================================================*/

class UpdateAdminLeadDetailAdditionalReferencelist implements Action {
  final List<TenancyAdditionalReference> referencelist;

  UpdateAdminLeadDetailAdditionalReferencelist(this.referencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordLeadsDetailsState(referencelist: referencelist);
  }
}
