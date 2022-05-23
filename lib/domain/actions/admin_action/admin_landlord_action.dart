import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/landlorddata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateAdminLandlord_isIDSort implements Action {
  final bool isIDSort;

  UpdateAdminLandlord_isIDSort(this.isIDSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isIDSort: isIDSort);
  }
}

class UpdateAdminLandlord_isNameSort implements Action {
  final bool isNameSort;

  UpdateAdminLandlord_isNameSort(this.isNameSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isNameSort: isNameSort);
  }
}

class UpdateAdminLandlord_isEmailSort implements Action {
  final bool isEmailSort;

  UpdateAdminLandlord_isEmailSort(this.isEmailSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isEmailSort: isEmailSort);
  }
}

class UpdateAdminLandlord_isPhoneSort implements Action {
  final bool isPhoneSort;

  UpdateAdminLandlord_isPhoneSort(this.isPhoneSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isPhoneSort: isPhoneSort);
  }
}

class UpdateAdminLandlord_isPropertySort implements Action {
  final bool isPropertySort;

  UpdateAdminLandlord_isPropertySort(this.isPropertySort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isPropertySort: isPropertySort);
  }
}

class UpdateAdminLandlord_isActiveSort implements Action {
  final bool isActiveSort;

  UpdateAdminLandlord_isActiveSort(this.isActiveSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isActiveSort: isActiveSort);
  }
}

class UpdateAdminLandlord_datalist implements Action {
  final List<LandLordData> landlorddatalist;

  UpdateAdminLandlord_datalist(this.landlorddatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordState(landlorddatalist: landlorddatalist);
  }
}

class UpdateAdminLandlord_isloding implements Action {
  final bool isloding;

  UpdateAdminLandlord_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(isloding: isloding);
  }
}

class UpdateAdminLandlord_pageNo implements Action {
  final int pageNo;

  UpdateAdminLandlord_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(pageNo: pageNo);
  }
}

class UpdateAdminLandlord_totalpage implements Action {
  final int totalpage;

  UpdateAdminLandlord_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(totalpage: totalpage);
  }
}

class UpdateAdminLandlord_totalRecord implements Action {
  final int totalRecord;

  UpdateAdminLandlord_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(totalRecord: totalRecord);
  }
}

class UpdateAdminLandlord_IDSortAcsDes implements Action {
  final int IDSortAcsDes;

  UpdateAdminLandlord_IDSortAcsDes(this.IDSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(IDSortAcsDes: IDSortAcsDes);
  }
}

class UpdateAdminLandlord_NameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateAdminLandlord_NameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.adminLandlordState(NameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateAdminLandlord_EmailSortAcsDes implements Action {
  final int EmailSortAcsDes;

  UpdateAdminLandlord_EmailSortAcsDes(this.EmailSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordState(EmailSortAcsDes: EmailSortAcsDes);
  }
}

class UpdateAdminLandlord_PhoneSortAcsDes implements Action {
  final int PhoneSortAcsDes;

  UpdateAdminLandlord_PhoneSortAcsDes(this.PhoneSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordState(PhoneSortAcsDes: PhoneSortAcsDes);
  }
}

class UpdateAdminLandlord_PropertySortAcsDes implements Action {
  final int PropertySortAcsDes;

  UpdateAdminLandlord_PropertySortAcsDes(this.PropertySortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordState(PropertySortAcsDes: PropertySortAcsDes);
  }
}

class UpdateAdminLandlord_ActiveSortAcsDes implements Action {
  final int ActiveSortAcsDes;

  UpdateAdminLandlord_ActiveSortAcsDes(this.ActiveSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordState(ActiveSortAcsDes: ActiveSortAcsDes);
  }
}

class UpdateAdminLandlord_LandlordSearchText implements Action {
  final String LandlordSearchText;

  UpdateAdminLandlord_LandlordSearchText(this.LandlordSearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .adminLandlordState(LandlordSearchText: LandlordSearchText);
  }
}
