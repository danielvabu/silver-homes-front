import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenancyform_state.freezed.dart';

@freezed
abstract class TenancyFormState with _$TenancyFormState {
  const factory TenancyFormState({
    required String property_address,
    required int selectView,
    required String CompanyName,
    required String HomePagelink,
    required String CustomerFeatureListingURL,
    MediaInfo? CompanyLogo,
  }) = _TenancyFormState;

  factory TenancyFormState.initial() => TenancyFormState(
        property_address: "",
        selectView: 11,
        CompanyName: "",
        HomePagelink: "",
        CustomerFeatureListingURL: "",
        CompanyLogo: null,
      );
}
