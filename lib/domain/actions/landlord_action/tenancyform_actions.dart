import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateTenacyFormIndex implements Action {
  final int index;

  UpdateTenacyFormIndex(
    this.index,
  );

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyFormState(selectView: index);
  }
}

class UpdateTenacyFormAddress implements Action {
  final String title;

  UpdateTenacyFormAddress(this.title);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyFormState(property_address: title);
  }
}

class UpdateTenacyFormCompanyName implements Action {
  final String CompanyName;

  UpdateTenacyFormCompanyName(this.CompanyName);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyFormState(CompanyName: CompanyName);
  }
}

class UpdateTenacyFormHomePagelink implements Action {
  final String HomePagelink;

  UpdateTenacyFormHomePagelink(this.HomePagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyFormState(HomePagelink: HomePagelink);
  }
}

class UpdateTenacyFormCustomerFeatureListingURL implements Action {
  final String CustomerFeatureListingURL;

  UpdateTenacyFormCustomerFeatureListingURL(this.CustomerFeatureListingURL);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .tenancyFormState(CustomerFeatureListingURL: CustomerFeatureListingURL);
  }
}

class UpdateTenacyFormCompanyLogo implements Action {
  final MediaInfo? CompanyLogo;

  UpdateTenacyFormCompanyLogo(this.CompanyLogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.tenancyFormState(CompanyLogo: CompanyLogo);
  }
}
