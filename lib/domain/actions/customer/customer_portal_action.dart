import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateCustomerPortal_ishover_heder_home implements Action {
  final bool ishover_heder_home;

  UpdateCustomerPortal_ishover_heder_home(this.ishover_heder_home);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(ishover_heder_home: ishover_heder_home);
  }
}

class UpdateCustomerPortal_ishover_heder_listing implements Action {
  final bool ishover_heder_listing;

  UpdateCustomerPortal_ishover_heder_listing(this.ishover_heder_listing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(ishover_heder_listing: ishover_heder_listing);
  }
}

class UpdateCustomerPortal_ishover_footer_home implements Action {
  final bool ishover_footer_home;

  UpdateCustomerPortal_ishover_footer_home(this.ishover_footer_home);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(ishover_footer_home: ishover_footer_home);
  }
}

class UpdateCustomerPortal_ishover_footer_listing implements Action {
  final bool ishover_footer_listing;

  UpdateCustomerPortal_ishover_footer_listing(this.ishover_footer_listing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(ishover_footer_listing: ishover_footer_listing);
  }
}

class UpdateCustomerPortal_tw_header_home implements Action {
  final double tw_header_home;

  UpdateCustomerPortal_tw_header_home(this.tw_header_home);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(tw_header_home: tw_header_home);
  }
}

class UpdateCustomerPortal_tw_header_listing implements Action {
  final double tw_header_listing;

  UpdateCustomerPortal_tw_header_listing(this.tw_header_listing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(tw_header_listing: tw_header_listing);
  }
}

class UpdateCustomerPortal_tw_footer_home implements Action {
  final double tw_footer_home;

  UpdateCustomerPortal_tw_footer_home(this.tw_footer_home);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(tw_footer_home: tw_footer_home);
  }
}

class UpdateCustomerPortal_tw_footer_listing implements Action {
  final double tw_footer_listing;

  UpdateCustomerPortal_tw_footer_listing(this.tw_footer_listing);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(tw_footer_listing: tw_footer_listing);
  }
}

class UpdateCustomerPortal_pageindex implements Action {
  final int index;

  UpdateCustomerPortal_pageindex(this.index);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPortalState(index: index);
  }
}

class UpdateCustomerPortal_Homepagelink implements Action {
  final String homepagelink;

  UpdateCustomerPortal_Homepagelink(this.homepagelink);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPortalState(homepagelink: homepagelink);
  }
}

class UpdateCustomerPortal_Companyname implements Action {
  final String Companyname;

  UpdateCustomerPortal_Companyname(this.Companyname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPortalState(Companyname: Companyname);
  }
}

class UpdateCustomerPortal_landlordemail implements Action {
  final String landlordemail;

  UpdateCustomerPortal_landlordemail(this.landlordemail);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.customerPortalState(landlordemail: landlordemail);
  }
}

class UpdateCustomerPortal_Companynamelogo implements Action {
  final MediaInfo? Companynamelogo;

  UpdateCustomerPortal_Companynamelogo(this.Companynamelogo);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .customerPortalState(Companynamelogo: Companynamelogo);
  }
}
