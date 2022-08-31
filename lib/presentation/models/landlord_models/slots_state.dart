import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/event_typesdata.dart';

import 'package:silverhome/domain/entities/property_drop_data.dart';
//import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'slots_state.freezed.dart';

@freezed
abstract class SlotsState with _$SlotsState {
  const factory SlotsState(
      {required int eventTypesDataId,
      required String date_start,
      required String date_end,
      required String name,
      required String email,
      required int state,
      required EventTypesData? eventTypesData}) = _SlotsState;

  // ignore: prefer_const_constructors
  factory SlotsState.initial() => SlotsState(
      eventTypesData: null,
      eventTypesDataId: 0,
      date_start: "",
      date_end: "",
      name: "",
      email: "",
      state: 0);
}
