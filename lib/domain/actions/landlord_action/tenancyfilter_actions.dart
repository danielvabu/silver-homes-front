import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTenacyfilterApply implements Action {
  UpdateTenacyfilterApply();

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call();
  }
}

class UpdateFilterProperty implements Action {
  List<FilterPropertyItem> properties;

  UpdateFilterProperty(this.properties);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(properties: properties);
  }
}

class UpdateFilterCity implements Action {
  List<FilterCityItem> cities;

  UpdateFilterCity(this.cities);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(cities: cities);
  }
}

class UpdateFilterRating implements Action {
  List<FilterRatingItem> ratinglist;

  UpdateFilterRating(this.ratinglist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(ratinglist: ratinglist);
  }
}

class UpdateFilterApplicationReceived implements Action {
  List<FilterApplicationReceived> applicationreceivelist;

  UpdateFilterApplicationReceived(this.applicationreceivelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(applicationreceivelist: applicationreceivelist);
  }
}

class UpdateFilterStatus implements Action {
  List<SystemEnumDetails> statuslist;

  UpdateFilterStatus(this.statuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(statuslist: statuslist);
  }
}

class UpdateFilterEmploymentStatus implements Action {
  List<SystemEnumDetails> employmentstatuslist;

  UpdateFilterEmploymentStatus(this.employmentstatuslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(employmentstatuslist: employmentstatuslist);
  }
}

class UpdateFilterAnnualIncome implements Action {
  List<SystemEnumDetails> annualincomelist;

  UpdateFilterAnnualIncome(this.annualincomelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(annualincomelist: annualincomelist);
  }
}

class UpdateFilterNumberOfOccupants implements Action {
  List<FilterNumberOfOccupants> numberoccupationlist;

  UpdateFilterNumberOfOccupants(this.numberoccupationlist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(numberoccupationlist: numberoccupationlist);
  }
}

class UpdateFilterPets implements Action {
  List<FilterPets> petslist;

  UpdateFilterPets(this.petslist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(petslist: petslist);
  }
}

class UpdateFilterSmoking implements Action {
  List<FilterSmoking> smokinglist;

  UpdateFilterSmoking(this.smokinglist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(smokinglist: smokinglist);
  }
}

class UpdateFilterVehical implements Action {
  List<FilterVehical> vehicallist;

  UpdateFilterVehical(this.vehicallist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(vehicallist: vehicallist);
  }
}

class UpdateFilterisExpandProperties implements Action {
  bool isExpandProperties;

  UpdateFilterisExpandProperties(this.isExpandProperties);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandProperties: isExpandProperties);
  }
}

class UpdateFilterisExpandCity implements Action {
  bool isExpandCity;

  UpdateFilterisExpandCity(this.isExpandCity);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(isExpandCity: isExpandCity);
  }
}

class UpdateFilterisExpandRating implements Action {
  bool isExpandRating;

  UpdateFilterisExpandRating(this.isExpandRating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandRating: isExpandRating);
  }
}

class UpdateFilterisExpandApplicationReceived implements Action {
  bool isExpandApplicationReceived;

  UpdateFilterisExpandApplicationReceived(this.isExpandApplicationReceived);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandApplicationReceived: isExpandApplicationReceived);
  }
}

class UpdateFilterisExpandStatus implements Action {
  bool isExpandStatus;

  UpdateFilterisExpandStatus(this.isExpandStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandStatus: isExpandStatus);
  }
}

class UpdateFilterisExpandEmploymentStatus implements Action {
  bool isExpandEmploymentStatus;

  UpdateFilterisExpandEmploymentStatus(this.isExpandEmploymentStatus);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandEmploymentStatus: isExpandEmploymentStatus);
  }
}

class UpdateFilterisExpandAnnualincome implements Action {
  bool isExpandAnnualincome;

  UpdateFilterisExpandAnnualincome(this.isExpandAnnualincome);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandAnnualincome: isExpandAnnualincome);
  }
}

class UpdateFilterisExpandNumberOfOccupation implements Action {
  bool isExpandNumberOfOccupation;

  UpdateFilterisExpandNumberOfOccupation(this.isExpandNumberOfOccupation);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandNumberOfOccupation: isExpandNumberOfOccupation);
  }
}

class UpdateFilterisExpandPets implements Action {
  bool isExpandPets;

  UpdateFilterisExpandPets(this.isExpandPets);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState.call(isExpandPets: isExpandPets);
  }
}

class UpdateFilterisExpandSmoking implements Action {
  bool isExpandSmoking;

  UpdateFilterisExpandSmoking(this.isExpandSmoking);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandSmoking: isExpandSmoking);
  }
}

class UpdateFilterisExpandVehical implements Action {
  bool isExpandVehical;

  UpdateFilterisExpandVehical(this.isExpandVehical);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(isExpandVehical: isExpandVehical);
  }
}

class UpdateFilterIsApplyFilter implements Action {
  bool IsApplyFilter;

  UpdateFilterIsApplyFilter(this.IsApplyFilter);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenantFilterState
        .call(IsApplyFilter: IsApplyFilter);
  }
}
