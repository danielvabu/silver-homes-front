import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_add_newmember_state.freezed.dart';

@freezed
abstract class AdminAddNewMemberState with _$AdminAddNewMemberState {
  factory AdminAddNewMemberState({
    required String OwnerId,
    required String Persionid,
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String phone,
    required String dialcode,
    required String countrycode,
    required bool error_firstname,
    required bool error_lastname,
    required bool error_email,
    required bool error_phone,
    required String error_message,
  }) = _AdminAddNewMemberState;

  factory AdminAddNewMemberState.initial() => AdminAddNewMemberState(
        OwnerId: "",
        Persionid: "",
        firstname: "",
        lastname: "",
        email: "",
        password: "Admin@123",
        phone: "",
        dialcode: "+1",
        countrycode: "CA",
        error_firstname: false,
        error_lastname: false,
        error_email: false,
        error_phone: false,
        error_message: "",
      );
}
