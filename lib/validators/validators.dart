import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError("Email invalido");
    }
  });

  final validateBool =
      StreamTransformer<bool, bool>.fromHandlers(handleData: (boole, sink) {
    if (boole == true) {
      sink.add(boole);
    } else {
      sink.addError("No se puedo agregara la lista");
    }
  });

  final validateSerch = StreamTransformer<String, String>.fromHandlers(
      handleData: (search, sink) {
    if (search != null) {
      sink.add(search);
    } else {
      sink.addError("Email invalido");
    }
  });
  final addBool =
      StreamTransformer<bool, bool>.fromHandlers(handleData: (search, sink) {
    if (search != null) {
      sink.add(search);
    } else {
      sink.addError("not bool");
    }
  });
}
