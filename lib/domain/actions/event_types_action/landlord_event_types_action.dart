import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/event_typesdata.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLEventTypes_status_TotalEventTypes implements Action {
  final int count;

  UpdateLLEventTypes_status_TotalEventTypes(this.count);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(status_TotalEventTypes: count);
  }
}

class UpdateLL_event_typesdatalist implements Action {
  final List<EventTypesData> eventtypesdatalist;

  UpdateLL_event_typesdatalist(this.eventtypesdatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(eventtypesdatalist: eventtypesdatalist);
  }
}

class UpdateLLEventTypes_isloding implements Action {
  final bool isloding;

  UpdateLLEventTypes_isloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isloding: isloding);
  }
}

class UpdateLLEventTypes_pageNo implements Action {
  final int pageNo;

  UpdateLLEventTypes_pageNo(this.pageNo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(pageNo: pageNo);
  }
}

class UpdateLLEventTypes_totalpage implements Action {
  final int totalpage;

  UpdateLLEventTypes_totalpage(this.totalpage);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(totalpage: totalpage);
  }
}

class UpdateLLEventTypes_totalRecord implements Action {
  final int totalRecord;

  UpdateLLEventTypes_totalRecord(this.totalRecord);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(totalRecord: totalRecord);
  }
}

class UpdateLLEventTypes_isCompanyNameSort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isCompanyNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isCompanyNameSort: isSort);
  }
}

class UpdateLLEventTypes_CompanyNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_CompanyNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(CompanyNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_isCitySort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isCitySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isCitySort: isSort);
  }
}

class UpdateLLEventTypes_CitySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_CitySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(CitySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_isContactNameSort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isContactNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isContactNameSort: isSort);
  }
}

class UpdateLLEventTypes_ContactNameSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_ContactNameSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(ContactNameSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_isEmaiSort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isEmaiSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isEmaiSort: isSort);
  }
}

class UpdateLLEventTypes_EmailSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_EmailSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(EmailSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_isPhoneSort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isPhoneSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isPhoneSort: isSort);
  }
}

class UpdateLLEventTypes_PhoneSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_PhoneSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(PhoneSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_isCategorySort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isCategorySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isCategorySort: isSort);
  }
}

class UpdateLLEventTypes_CategorySortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_CategorySortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(CategorySortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_isRatingSort implements Action {
  final bool isSort;

  UpdateLLEventTypes_isRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(isRatingSort: isSort);
  }
}

class UpdateLLEventTypes_RatingSortAcsDes implements Action {
  final int NameSortAcsDes;

  UpdateLLEventTypes_RatingSortAcsDes(this.NameSortAcsDes);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .landlordEventTypesState(RatingSortAcsDes: NameSortAcsDes);
  }
}

class UpdateLLEventTypes_SearchText implements Action {
  final String SearchText;

  UpdateLLEventTypes_SearchText(this.SearchText);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.landlordEventTypesState(SearchText: SearchText);
  }
}
