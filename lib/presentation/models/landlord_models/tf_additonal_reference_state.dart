import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';

part 'tf_additonal_reference_state.freezed.dart';

@freezed
abstract class TFAdditionalReferenceState with _$TFAdditionalReferenceState {
  const factory TFAdditionalReferenceState({
    required List<TenancyAdditionalReference> referencelist,
    required List<TenancyAdditionalReference> LiveServerreferencelist,
    required bool isAutherize,
    required bool isTermsCondition,

    //final value
    required List<TenancyAdditionalReference> FNLreferencelist,
    required List<TenancyAdditionalReference> FNLLiveServerreferencelist,
    required bool FNLisAutherize,
    required bool FNLisTermsCondition,
    required bool isUpdate,
  }) = _TFAdditionalReferenceState;

  factory TFAdditionalReferenceState.initial() => TFAdditionalReferenceState(
        referencelist: List.empty(),
        LiveServerreferencelist: List.empty(),
        isAutherize: false,
        isTermsCondition: false,
        FNLreferencelist: List.empty(),
        FNLLiveServerreferencelist: List.empty(),
        FNLisAutherize: false,
        FNLisTermsCondition: false,
        isUpdate: false,
      );
}
