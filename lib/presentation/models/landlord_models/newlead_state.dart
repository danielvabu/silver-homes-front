import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/newlead.dart';
import 'package:silverhome/domain/entities/propertydata.dart';

part 'newlead_state.freezed.dart';

@freezed
abstract class NewLeadState with _$NewLeadState {
  const factory NewLeadState({
    PropertyData? propertyValue,
    required List<PropertyData> propertylist,
    required List<NewLead> newleadlist,
    required String isreferesh,
  }) = _NewLeadState;

  factory NewLeadState.initial() => NewLeadState(
        propertylist: List.empty(),
        newleadlist: List.empty(),
        propertyValue: null,
        isreferesh: "",
      );
}
