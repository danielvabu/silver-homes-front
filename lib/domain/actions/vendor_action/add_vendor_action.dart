import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
import 'package:silverhome/presentation/models/app_state.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class UpdateADV_countrydatalist implements Action {
  final List<CountryData> countrydatalist;

  UpdateADV_countrydatalist(this.countrydatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(countrydatalist: countrydatalist);
  }
}

class UpdateADV_statedatalist implements Action {
  final List<StateData> statedatalist;

  UpdateADV_statedatalist(this.statedatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(statedatalist: statedatalist);
  }
}

class UpdateADV_citydatalist implements Action {
  final List<CityData> citydatalist;

  UpdateADV_citydatalist(this.citydatalist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(citydatalist: citydatalist);
  }
}

class UpdateADV_Categorylist implements Action {
  final List<SystemEnumDetails> Categorylist;

  UpdateADV_Categorylist(this.Categorylist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(Categorylist: Categorylist);
  }
}

class UpdateADV_selectedCountry implements Action {
  final CountryData? selectedCountry;

  UpdateADV_selectedCountry(this.selectedCountry);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(selectedCountry: selectedCountry);
  }
}

class UpdateADV_selectedState implements Action {
  final StateData? selectedState;

  UpdateADV_selectedState(this.selectedState);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(selectedState: selectedState);
  }
}

class UpdateADV_selectedCity implements Action {
  final CityData? selectedCity;

  UpdateADV_selectedCity(this.selectedCity);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(selectedCity: selectedCity);
  }
}

class UpdateADV_selectCategory implements Action {
  final SystemEnumDetails? selectCategory;

  UpdateADV_selectCategory(this.selectCategory);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(selectCategory: selectCategory);
  }
}

class UpdateADV_vid implements Action {
  final int vid;

  UpdateADV_vid(this.vid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(vid: vid);
  }
}

class UpdateADV_personid implements Action {
  final int personid;

  UpdateADV_personid(this.personid);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(personid: personid);
  }
}

class UpdateADV_rating implements Action {
  final double rating;

  UpdateADV_rating(this.rating);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(rating: rating);
  }
}

class UpdateADV_companyname implements Action {
  final String companyname;

  UpdateADV_companyname(this.companyname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(companyname: companyname);
  }
}

class UpdateADV_cfirstname implements Action {
  final String cfirstname;

  UpdateADV_cfirstname(this.cfirstname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(cfirstname: cfirstname);
  }
}

class UpdateADV_clastname implements Action {
  final String clastname;

  UpdateADV_clastname(this.clastname);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(clastname: clastname);
  }
}

class UpdateADV_cemail implements Action {
  final String cemail;

  UpdateADV_cemail(this.cemail);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(cemail: cemail);
  }
}

class UpdateADV_cphone implements Action {
  final String cphone;

  UpdateADV_cphone(this.cphone);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(cphone: cphone);
  }
}

class UpdateADV_cdialcode implements Action {
  final String cdialcode;

  UpdateADV_cdialcode(this.cdialcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(cdialcode: cdialcode);
  }
}

class UpdateADV_ccountrycode implements Action {
  final String ccountrycode;

  UpdateADV_ccountrycode(this.ccountrycode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(ccountrycode: ccountrycode);
  }
}

class UpdateADV_address implements Action {
  final String address;

  UpdateADV_address(this.address);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(address: address);
  }
}

class UpdateADV_suit implements Action {
  final String suit;

  UpdateADV_suit(this.suit);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(suit: suit);
  }
}

class UpdateADV_postalcode implements Action {
  final String postalcode;

  UpdateADV_postalcode(this.postalcode);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(postalcode: postalcode);
  }
}

class UpdateADV_Note implements Action {
  final String Note;

  UpdateADV_Note(this.Note);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.addVendorState(Note: Note);
  }
}
