import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateLLVDToggle implements Action {
  final int index;

  UpdateLLVDToggle(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(selecttoggle: index);
  }
}

class UpdateLLVDisNameSort implements Action {
  final bool isSort;

  UpdateLLVDisNameSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(isNameSort: isSort);
  }
}

class UpdateLLVDisDateReceiveSort implements Action {
  final bool isSort;

  UpdateLLVDisDateReceiveSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .varificationDocumentState(isDateReceiveSort: isSort);
  }
}

class UpdateLLVDisDateSentSort implements Action {
  final bool isSort;

  UpdateLLVDisDateSentSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(isDateSentSort: isSort);
  }
}

class UpdateLLVDisPropertySort implements Action {
  final bool isSort;

  UpdateLLVDisPropertySort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(isPropertySort: isSort);
  }
}

class UpdateLLVDisAppStatusSort implements Action {
  final bool isSort;

  UpdateLLVDisAppStatusSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(isAppStatusSort: isSort);
  }
}

class UpdateLLVDisRatingSort implements Action {
  final bool isSort;

  UpdateLLVDisRatingSort(this.isSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(isRatingSort: isSort);
  }
}

class UpdateLLVDisDocStatusSort implements Action {
  final bool isDocStatusSort;

  UpdateLLVDisDocStatusSort(this.isDocStatusSort);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .varificationDocumentState(isDocStatusSort: isDocStatusSort);
  }
}

class UpdateLLVDvarificationdoclist implements Action {
  final List<TenancyApplication> varificationdoclist;

  UpdateLLVDvarificationdoclist(this.varificationdoclist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .varificationDocumentState(varificationdoclist: varificationdoclist);
  }
}

class UpdateLLVDfiltervarificationdoclist implements Action {
  final List<TenancyApplication> filtervarificationdoclist;

  UpdateLLVDfiltervarificationdoclist(this.filtervarificationdoclist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(
        filtervarificationdoclist: filtervarificationdoclist);
  }
}

class UpdateLLVDapplicationPropertyList implements Action {
  final List<PropertyData> propertylist;

  UpdateLLVDapplicationPropertyList(this.propertylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .varificationDocumentState(propertylist: propertylist);
  }
}

class UpdateLLVDapplicationPropertyItem implements Action {
  final PropertyData? propertyitem;

  UpdateLLVDapplicationPropertyItem(this.propertyitem);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .varificationDocumentState(propertyValue: propertyitem);
  }
}

class UpdateLLVDapplicationisloding implements Action {
  final bool isloding;

  UpdateLLVDapplicationisloding(this.isloding);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.varificationDocumentState(isloding: isloding);
  }
}
