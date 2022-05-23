import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'customer_portal_state.freezed.dart';

@freezed
abstract class CustomerPortalState with _$CustomerPortalState {
  factory CustomerPortalState({
    required bool ishover_heder_home,
    required bool ishover_heder_listing,
    required bool ishover_footer_home,
    required bool ishover_footer_listing,
    required double tw_header_home,
    required double tw_header_listing,
    required double tw_footer_home,
    required double tw_footer_listing,
    required String homepagelink,
    required String Companyname,
    required String landlordemail,
    MediaInfo? Companynamelogo,
    required int index,
  }) = _CustomerPortalState;

  factory CustomerPortalState.initial() => CustomerPortalState(
        ishover_heder_home: false,
        ishover_heder_listing: false,
        ishover_footer_home: false,
        ishover_footer_listing: false,
        tw_header_home: 0,
        tw_header_listing: 0,
        tw_footer_home: 0,
        tw_footer_listing: 0,
        homepagelink: "",
        Companyname: "",
        landlordemail: "",
        Companynamelogo: null,
        index: 0,
      );
}
