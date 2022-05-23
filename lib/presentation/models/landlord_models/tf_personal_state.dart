import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tf_personal_state.freezed.dart';

@freezed
abstract class TFPersonalState with _$TFPersonalState {
  const factory TFPersonalState({
    required String perFirstname,
    required String perLastname,
    DateTime? dateofbirth,
    required String perEmail,
    required String perPhoneNumber,
    required String perCountryCode,
    required String perDialCode,
    required String perStory,
    required bool isUpdate,
    required String Person_ID,

    //finalValue
    required String FNLperFirstname,
    required String FNLperLastname,
    DateTime? FNLdateofbirth,
    required String FNLperEmail,
    required String FNLperPhoneNumber,
    required String FNLperCountryCode,
    required String FNLperDialCode,
    required String FNLperStory,

    /*Error falg*/
    required bool error_perFirstname,
    required bool error_perLastname,
    required bool error_dateofbirth,
    required bool error_perEmail,
    required bool error_perPhoneNumber,
  }) = _TFPersonalState;

  factory TFPersonalState.initial() => TFPersonalState(
        perFirstname: "",
        perLastname: "",
        dateofbirth: null,
        perEmail: "",
        perPhoneNumber: "",
        perCountryCode: "CA",
        perDialCode: "+1",
        perStory: "",
        FNLperFirstname: "",
        FNLperLastname: "",
        FNLdateofbirth: null,
        FNLperEmail: "",
        FNLperPhoneNumber: "",
        FNLperCountryCode: "CA",
        FNLperDialCode: "+1",
        FNLperStory: "",
        isUpdate: false,
        Person_ID: "",
        error_perFirstname: false,
        error_perLastname: false,
        error_dateofbirth: false,
        error_perEmail: false,
        error_perPhoneNumber: false,
      );
}
