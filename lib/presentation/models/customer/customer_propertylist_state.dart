import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/propertydata.dart';

part 'customer_propertylist_state.freezed.dart';

@freezed
abstract class CustomerPropertylistState with _$CustomerPropertylistState {
  factory CustomerPropertylistState({
    required List<PropertyData> propertylist,
  }) = _CustomerPropertylistState;

  factory CustomerPropertylistState.initial() => CustomerPropertylistState(
        propertylist: List.empty(),
      );
}
