import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/maintenance_vendor.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateMDA_mID implements Action {
  final String mID;

  UpdateMDA_mID(this.mID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(mID: mID);
  }
}

class UpdateMDA_IsLock implements Action {
  final bool IsLock;

  UpdateMDA_IsLock(this.IsLock);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(IsLock: IsLock);
  }
}

class UpdateMDA_Describe_Issue implements Action {
  final String Describe_Issue;

  UpdateMDA_Describe_Issue(this.Describe_Issue);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Describe_Issue: Describe_Issue);
  }
}

class UpdateMDA_Date_Created implements Action {
  final String Date_Created;

  UpdateMDA_Date_Created(this.Date_Created);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Date_Created: Date_Created);
  }
}

class UpdateMDA_Type_User implements Action {
  final int Type_User;

  UpdateMDA_Type_User(this.Type_User);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Type_User: Type_User);
  }
}

class UpdateMDA_RequestName implements Action {
  final String RequestName;

  UpdateMDA_RequestName(this.RequestName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(RequestName: RequestName);
  }
}

class UpdateMDA_Category implements Action {
  final SystemEnumDetails? Category;

  UpdateMDA_Category(this.Category);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Category: Category);
  }
}

class UpdateMDA_Status implements Action {
  final SystemEnumDetails? Status;

  UpdateMDA_Status(this.Status);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Status: Status);
  }
}

class UpdateMDA_Priority implements Action {
  final SystemEnumDetails? Priority;

  UpdateMDA_Priority(this.Priority);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Priority: Priority);
  }
}

class UpdateMDA_Applicant_ID implements Action {
  final String Applicant_ID;

  UpdateMDA_Applicant_ID(this.Applicant_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_ID: Applicant_ID);
  }
}

class UpdateMDA_Applicant_UserID implements Action {
  final String Applicant_UserID;

  UpdateMDA_Applicant_UserID(this.Applicant_UserID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_UserID: Applicant_UserID);
  }
}

class UpdateMDA_Applicant_firstname implements Action {
  final String Applicant_firstname;

  UpdateMDA_Applicant_firstname(this.Applicant_firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_firstname: Applicant_firstname);
  }
}

class UpdateMDA_Applicant_lastname implements Action {
  final String Applicant_lastname;

  UpdateMDA_Applicant_lastname(this.Applicant_lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_lastname: Applicant_lastname);
  }
}

class UpdateMDA_Applicant_email implements Action {
  final String Applicant_email;

  UpdateMDA_Applicant_email(this.Applicant_email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_email: Applicant_email);
  }
}

class UpdateMDA_Applicant_mobile implements Action {
  final String Applicant_mobile;

  UpdateMDA_Applicant_mobile(this.Applicant_mobile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_mobile: Applicant_mobile);
  }
}

class UpdateMDA_Applicant_dialcode implements Action {
  final String Applicant_dialcode;

  UpdateMDA_Applicant_dialcode(this.Applicant_dialcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Applicant_dialcode: Applicant_dialcode);
  }
}

class UpdateMDA_Owner_ID implements Action {
  final String Owner_ID;

  UpdateMDA_Owner_ID(this.Owner_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Owner_ID: Owner_ID);
  }
}

class UpdateMDA_Owner_firstname implements Action {
  final String Owner_firstname;

  UpdateMDA_Owner_firstname(this.Owner_firstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Owner_firstname: Owner_firstname);
  }
}

class UpdateMDA_Owner_lastname implements Action {
  final String Owner_lastname;

  UpdateMDA_Owner_lastname(this.Owner_lastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Owner_lastname: Owner_lastname);
  }
}

class UpdateMDA_Owner_email implements Action {
  final String Owner_email;

  UpdateMDA_Owner_email(this.Owner_email);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Owner_email: Owner_email);
  }
}

class UpdateMDA_Owner_mobile implements Action {
  final String Owner_mobile;

  UpdateMDA_Owner_mobile(this.Owner_mobile);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Owner_mobile: Owner_mobile);
  }
}

class UpdateMDA_Owner_dialcode implements Action {
  final String Owner_dialcode;

  UpdateMDA_Owner_dialcode(this.Owner_dialcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Owner_dialcode: Owner_dialcode);
  }
}

class UpdateMDA_CompanyName implements Action {
  final String CompanyName;

  UpdateMDA_CompanyName(this.CompanyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(CompanyName: CompanyName);
  }
}

class UpdateMDA_HomePageLink implements Action {
  final String HomePageLink;

  UpdateMDA_HomePageLink(this.HomePageLink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(HomePageLink: HomePageLink);
  }
}

class UpdateMDA_Company_logo implements Action {
  final MediaInfo? Company_logo;

  UpdateMDA_Company_logo(this.Company_logo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Company_logo: Company_logo);
  }
}

class UpdateMDA_Prop_ID implements Action {
  final String Prop_ID;

  UpdateMDA_Prop_ID(this.Prop_ID);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Prop_ID: Prop_ID);
  }
}

class UpdateMDA_Property_Address implements Action {
  final String Property_Address;

  UpdateMDA_Property_Address(this.Property_Address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(Property_Address: Property_Address);
  }
}

class UpdateMDA_PropertyName implements Action {
  final String PropertyName;

  UpdateMDA_PropertyName(this.PropertyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(PropertyName: PropertyName);
  }
}

class UpdateMDA_Suite_Unit implements Action {
  final String Suite_Unit;

  UpdateMDA_Suite_Unit(this.Suite_Unit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.maintenanceDetailsState(Suite_Unit: Suite_Unit);
  }
}

class UpdateMDA_maintenanceImageslist implements Action {
  final List<PropertyMaintenanceImages> maintenanceImageslist;

  UpdateMDA_maintenanceImageslist(this.maintenanceImageslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(maintenanceImageslist: maintenanceImageslist);
  }
}

class UpdateMDA_maintenanceVendorlist implements Action {
  final List<MaintenanceVendor> maintenanceVendorlist;

  UpdateMDA_maintenanceVendorlist(this.maintenanceVendorlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .maintenanceDetailsState(maintenanceVendorlist: maintenanceVendorlist);
  }
}
