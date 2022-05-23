import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLVendor_status_TotalVendor implements Action {
  final int count;

  UpdateLLVendor_status_TotalVendor(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(status_TotalVendor: count);
  }
}

class UpdateLL_vendordatalist implements Action {
  final List<VendorData> vendordatalist;

  UpdateLL_vendordatalist(this.vendordatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(vendordatalist: vendordatalist);
  }
}

class UpdateLLVendor_isloding implements Action {
  final bool isloding;

  UpdateLLVendor_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isloding: isloding);
  }
}

class UpdateLLVendor_pageNo implements Action {
  final int pageNo;

  UpdateLLVendor_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(pageNo: pageNo);
  }
}

class UpdateLLVendor_totalpage implements Action {
  final int totalpage;

  UpdateLLVendor_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(totalpage: totalpage);
  }
}

class UpdateLLVendor_totalRecord implements Action {
  final int totalRecord;

  UpdateLLVendor_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(totalRecord: totalRecord);
  }
}

class UpdateLLVendor_isCompanyNameSort implements Action {
  final bool isSort;

  UpdateLLVendor_isCompanyNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isCompanyNameSort: isSort);
  }
}

class UpdateLLVendor_CompanyNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_CompanyNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(CompanyNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_isCitySort implements Action {
  final bool isSort;

  UpdateLLVendor_isCitySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isCitySort: isSort);
  }
}

class UpdateLLVendor_CitySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_CitySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(CitySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_isContactNameSort implements Action {
  final bool isSort;

  UpdateLLVendor_isContactNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isContactNameSort: isSort);
  }
}

class UpdateLLVendor_ContactNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_ContactNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(ContactNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_isEmaiSort implements Action {
  final bool isSort;

  UpdateLLVendor_isEmaiSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isEmaiSort: isSort);
  }
}

class UpdateLLVendor_EmailSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_EmailSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(EmailSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_isPhoneSort implements Action {
  final bool isSort;

  UpdateLLVendor_isPhoneSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isPhoneSort: isSort);
  }
}

class UpdateLLVendor_PhoneSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_PhoneSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(PhoneSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_isCategorySort implements Action {
  final bool isSort;

  UpdateLLVendor_isCategorySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isCategorySort: isSort);
  }
}

class UpdateLLVendor_CategorySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_CategorySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(CategorySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_isRatingSort implements Action {
  final bool isSort;

  UpdateLLVendor_isRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(isRatingSort: isSort);
  }
}

class UpdateLLVendor_RatingSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLVendor_RatingSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordVendorState(RatingSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLVendor_SearchText implements Action {
  final String SearchText;

  UpdateLLVendor_SearchText(this.SearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordVendorState(SearchText: SearchText);
  }
}
