import 'package:silverhome/bloc/documents/document_bloc.dart';
import 'package:silverhome/bloc/messagin/messagin_bloc.dart';
import 'package:silverhome/bloc/test/testBloc.dart';
import 'package:silverhome/validators/validators.dart';

class Bloc with Validators {
  PropertyBloc propertyBloc = PropertyBloc();
  DocumentBloc documentBloc = DocumentBloc();
  MessaginBloc messaginBloc = MessaginBloc();

  dispose() {
    propertyBloc.dispose();
    documentBloc.dispose();
  }
}
