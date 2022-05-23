import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTADetailApplicantID implements Action {
  final String ApplicantID;

  UpdateTADetailApplicantID(this.ApplicantID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ApplicantID: ApplicantID);
  }
}

class UpdateTADetailApplicationID implements Action {
  final String ApplicationID;

  UpdateTADetailApplicationID(this.ApplicationID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ApplicationID: ApplicationID);
  }
}

class UpdateTADetailApplicationStatus implements Action {
  final SystemEnumDetails? ApplicationStatus;

  UpdateTADetailApplicationStatus(this.ApplicationStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ApplicationStatus: ApplicationStatus);
  }
}

class UpdateTADetailRating implements Action {
  final double Rating;

  UpdateTADetailRating(this.Rating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(Rating: Rating);
  }
}

class UpdateTADetailRatingReview implements Action {
  final String RatingReview;

  UpdateTADetailRatingReview(this.RatingReview);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(RatingReview: RatingReview);
  }
}

/*=============================================================*/
/*Personal info*/
/*=============================================================*/

class UpdateTADetailFirstname implements Action {
  final String Firstname;

  UpdateTADetailFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(perFirstname: Firstname);
  }
}

class UpdateTADetailLastname implements Action {
  final String Lastname;

  UpdateTADetailLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(perLastname: Lastname);
  }
}

class UpdateTADetailDateofBirth implements Action {
  final DateTime? dateofbirth;

  UpdateTADetailDateofBirth(this.dateofbirth);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(dateofbirth: dateofbirth);
  }
}

class UpdateTADetailAge implements Action {
  final String perAge;

  UpdateTADetailAge(this.perAge);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(perAge: perAge);
  }
}

class UpdateTADetailEmail implements Action {
  final String Email;

  UpdateTADetailEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(perEmail: Email);
  }
}

class UpdateTADetailPhoneNumber implements Action {
  final String PhoneNumber;

  UpdateTADetailPhoneNumber(this.PhoneNumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(perPhoneNumber: PhoneNumber);
  }
}

class UpdateTADetailCountryCode implements Action {
  final String CountryCode;

  UpdateTADetailCountryCode(this.CountryCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(perCountryCode: CountryCode);
  }
}

class UpdateTADetailDialCode implements Action {
  final String DialCode;

  UpdateTADetailDialCode(this.DialCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(perDialCode: DialCode);
  }
}

class UpdateTADetailStory implements Action {
  final String Story;

  UpdateTADetailStory(this.Story);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(perStory: Story);
  }
}

class UpdateTADetailNote implements Action {
  final String Note;

  UpdateTADetailNote(this.Note);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(Note: Note);
  }
}

class UpdateTADetailPersonID implements Action {
  final String PersonID;

  UpdateTADetailPersonID(this.PersonID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(Person_ID: PersonID);
  }
}

/*=============================================================*/
/*Employment info*/
/*=============================================================*/

class UpdateTADetailothersourceincome implements Action {
  final String othersourceincome;

  UpdateTADetailothersourceincome(this.othersourceincome);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(othersourceincome: othersourceincome);
  }
}

class UpdateTADetaillinkedprofile implements Action {
  final String linkedprofile;

  UpdateTADetaillinkedprofile(this.linkedprofile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(linkedprofile: linkedprofile);
  }
}

class UpdateTADetailAnualincomestatus implements Action {
  final SystemEnumDetails? annualincomevalue;

  UpdateTADetailAnualincomestatus(this.annualincomevalue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(anualincomestatus: annualincomevalue);
  }
}

class UpdateTADetaillistoccupation implements Action {
  final List<TenancyEmploymentInformation> listoccupation1;

  UpdateTADetaillistoccupation(this.listoccupation1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(listoccupation: listoccupation1);
  }
}

class UpdateTADetailempstatus implements Action {
  final SystemEnumDetails? empstatus;

  UpdateTADetailempstatus(this.empstatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(empstatus: empstatus);
  }
}

class UpdateTADetailEmploymentID implements Action {
  final String EmploymentID;

  UpdateTADetailEmploymentID(this.EmploymentID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(EmploymentID: EmploymentID);
  }
}

/*=============================================================*/
/*Current tenacy info*/
/*=============================================================*/

class UpdateTADetailCurrenttenantStartDate implements Action {
  final DateTime? StartDate;

  UpdateTADetailCurrenttenantStartDate(this.StartDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ct_startdate: StartDate);
  }
}

class UpdateTADetailCurrenttenantEndDate implements Action {
  final DateTime? EndDate;

  UpdateTADetailCurrenttenantEndDate(this.EndDate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ct_enddate: EndDate);
  }
}

class UpdateTADetailCurrenttenantSuiteUnit implements Action {
  final String SuiteUnit;

  UpdateTADetailCurrenttenantSuiteUnit(this.SuiteUnit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(suiteunit: SuiteUnit);
  }
}

class UpdateTADetailCurrenttenantAddress implements Action {
  final String Address;

  UpdateTADetailCurrenttenantAddress(this.Address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ct_address: Address);
  }
}

class UpdateTADetailCurrenttenantCity implements Action {
  final String City;

  UpdateTADetailCurrenttenantCity(this.City);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(ct_city: City);
  }
}

class UpdateTADetailCurrenttenantProvince implements Action {
  final String Province;

  UpdateTADetailCurrenttenantProvince(this.Province);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ct_province: Province);
  }
}

class UpdateTADetailCurrenttenantPostalcode implements Action {
  final String Postalcode;

  UpdateTADetailCurrenttenantPostalcode(this.Postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(ct_postalcode: Postalcode);
  }
}

class UpdateTADetailCurrenttenantFirstname implements Action {
  final String Firstname;

  UpdateTADetailCurrenttenantFirstname(this.Firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(cl_firstname: Firstname);
  }
}

class UpdateTADetailCurrenttenantLastname implements Action {
  final String Lastname;

  UpdateTADetailCurrenttenantLastname(this.Lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(cl_lastname: Lastname);
  }
}

class UpdateTADetailCurrenttenantEmail implements Action {
  final String Email;

  UpdateTADetailCurrenttenantEmail(this.Email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(cl_email: Email);
  }
}

class UpdateTADetailCurrenttenantPhonenumber implements Action {
  final String Phonenumber;

  UpdateTADetailCurrenttenantPhonenumber(this.Phonenumber);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(cl_phonenumber: Phonenumber);
  }
}

class UpdateTADetailCurrenttenantCode implements Action {
  final String Code;

  UpdateTADetailCurrenttenantCode(this.Code);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(cl_code: Code);
  }
}

class UpdateTADetailCurrenttenantDailCode implements Action {
  final String DailCode;

  UpdateTADetailCurrenttenantDailCode(this.DailCode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(cl_dailcode: DailCode);
  }
}

class UpdateTADetailCurrenttenantisReference implements Action {
  final bool isReference;

  UpdateTADetailCurrenttenantisReference(this.isReference);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(cl_isReference: isReference);
  }
}

class UpdateTADetailCurrenttenantCurrentTenancyID implements Action {
  final String CurrentTenancyID;

  UpdateTADetailCurrenttenantCurrentTenancyID(this.CurrentTenancyID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(CurrentTenancyID: CurrentTenancyID);
  }
}

class UpdateTADetailCurrenttenantCurrentLandLordID implements Action {
  final String CurrentLandLordID;

  UpdateTADetailCurrenttenantCurrentLandLordID(this.CurrentLandLordID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(CurrentLandLordID: CurrentLandLordID);
  }
}

/*=============================================================*/
/*Tenancy Occupant info*/
/*=============================================================*/

class UpdateTADetailAddOccupantlist implements Action {
  final List<TenancyAdditionalOccupant> occupantlist;

  UpdateTADetailAddOccupantlist(this.occupantlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(occupantlist: occupantlist);
  }
}

class UpdateTADetailAddOccupantNotApplicable implements Action {
  final bool notapplicable;

  UpdateTADetailAddOccupantNotApplicable(this.notapplicable);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(notapplicable: notapplicable);
  }
}

/*=============================================================*/
/*Additional info*/
/*=============================================================*/

class UpdateTADetailAdditionalInfoPetslist implements Action {
  final List<Pets> petslist1;

  UpdateTADetailAdditionalInfoPetslist(this.petslist1);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(petslist: petslist1);
  }
}

class UpdateTADetailAdditionalInfoIspets implements Action {
  final bool ispet;

  UpdateTADetailAdditionalInfoIspets(this.ispet);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(isPets: ispet);
  }
}

class UpdateTADetailAdditionalInfoVehicallist implements Action {
  final List<Vehical> vehicallist;

  UpdateTADetailAdditionalInfoVehicallist(this.vehicallist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(vehicallist: vehicallist);
  }
}

class UpdateTADetailAdditionalInfoisVehical implements Action {
  final bool isVehical;

  UpdateTADetailAdditionalInfoisVehical(this.isVehical);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(isVehical: isVehical);
  }
}

class UpdateTADetailAdditionalInfoisSmoking implements Action {
  final bool isSmoking;

  UpdateTADetailAdditionalInfoisSmoking(this.isSmoking);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(isSmoking: isSmoking);
  }
}

class UpdateTADetailAdditionalInfoComment implements Action {
  final String Comment;

  UpdateTADetailAdditionalInfoComment(this.Comment);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantsApplicationDetailsState(Comment: Comment);
  }
}

class UpdateTADetailAdditionalInfoTenancyStartDate implements Action {
  final DateTime? tenancystartdate;

  UpdateTADetailAdditionalInfoTenancyStartDate(this.tenancystartdate);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(tenancystartdate: tenancystartdate);
  }
}

class UpdateTADetailAdditionalInfoLenthOfTenancy implements Action {
  final SystemEnumDetails? lenthoftenancy;

  UpdateTADetailAdditionalInfoLenthOfTenancy(this.lenthoftenancy);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(lenthoftenancy: lenthoftenancy);
  }
}

class UpdateTADetailAdditionalInfoIntendedPeriod implements Action {
  final SystemEnumDetails? IntendedPeriod;

  UpdateTADetailAdditionalInfoIntendedPeriod(this.IntendedPeriod);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(IntendedPeriod: IntendedPeriod);
  }
}

class UpdateTADetailAdditionalInfoIntendedPeriodNo implements Action {
  final String IntendedPeriodNo;

  UpdateTADetailAdditionalInfoIntendedPeriodNo(this.IntendedPeriodNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(IntendedPeriodNo: IntendedPeriodNo);
  }
}

/*=============================================================*/
/*Reference info*/
/*=============================================================*/

class UpdateTADetailAdditionalReferencelist implements Action {
  final List<TenancyAdditionalReference> referencelist;

  UpdateTADetailAdditionalReferencelist(this.referencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenantsApplicationDetailsState(referencelist: referencelist);
  }
}
