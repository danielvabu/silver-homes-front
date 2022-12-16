// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(_current != null,
        'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Hello mundo`
  String get helloWord {
    return Intl.message(
      'Hello mundo',
      name: 'helloWord',
      desc: '',
      args: [],
    );
  }

  /// `Registrarse`
  String get signUp {
    return Intl.message(
      'Registrarse',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Campo requerido *`
  String get complete {
    return Intl.message(
      'Campo requerido *',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Celular`
  String get phone {
    return Intl.message(
      'Celular',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Formato incorrecto`
  String get errorFormat {
    return Intl.message(
      'Formato incorrecto',
      name: 'errorFormat',
      desc: '',
      args: [],
    );
  }

  /// `Correo electrónico`
  String get email {
    return Intl.message(
      'Correo electrónico',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña`
  String get password {
    return Intl.message(
      'Contraseña',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `La contraseña debe tener los siguientes criterios: mínimo 8 caracteres, mínimo 15 caracteres, contener al menos una letra mayúscula, una letra minúscula, un carácter de espacio.`
  String get errorFormatPassword1 {
    return Intl.message(
      'La contraseña debe tener los siguientes criterios: mínimo 8 caracteres, mínimo 15 caracteres, contener al menos una letra mayúscula, una letra minúscula, un carácter de espacio.',
      name: 'errorFormatPassword1',
      desc: '',
      args: [],
    );
  }

  /// `Las contraseñas no coinciden`
  String get errorFormatPassword2 {
    return Intl.message(
      'Las contraseñas no coinciden',
      name: 'errorFormatPassword2',
      desc: '',
      args: [],
    );
  }

  /// `La contraseña debe tener más de 7 dígitos y menos de 15`
  String get errorFormatPassword3 {
    return Intl.message(
      'La contraseña debe tener más de 7 dígitos y menos de 15',
      name: 'errorFormatPassword3',
      desc: '',
      args: [],
    );
  }

  /// `Repite la contraseña`
  String get repeatPassword {
    return Intl.message(
      'Repite la contraseña',
      name: 'repeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Iniciar sesión`
  String get login {
    return Intl.message(
      'Iniciar sesión',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `calculator`
  String get calculator {
    return Intl.message(
      'calculator',
      name: 'calculator',
      desc: '',
      args: [],
    );
  }

  /// `¿Se te olvidó tu contraseña?`
  String get forgotPassword {
    return Intl.message(
      '¿Se te olvidó tu contraseña?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Hogar`
  String get home {
    return Intl.message(
      'Hogar',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Perfil`
  String get profile {
    return Intl.message(
      'Perfil',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Usuario`
  String get user {
    return Intl.message(
      'Usuario',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Ajustes`
  String get settings {
    return Intl.message(
      'Ajustes',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Cerrar sesión`
  String get logout {
    return Intl.message(
      'Cerrar sesión',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Recuperar contraseña`
  String get recoverPassword {
    return Intl.message(
      'Recuperar contraseña',
      name: 'recoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `ingrese su correo electrónico`
  String get inputyouremail {
    return Intl.message(
      'ingrese su correo electrónico',
      name: 'inputyouremail',
      desc: '',
      args: [],
    );
  }

  /// `recibirá un correo electrónico con un código para restablecer su contraseña.`
  String get recoverPasswordMessage {
    return Intl.message(
      'recibirá un correo electrónico con un código para restablecer su contraseña.',
      name: 'recoverPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Last login`
  String get lastlogin {
    return Intl.message(
      'Last login',
      name: 'lastlogin',
      desc: '',
      args: [],
    );
  }

  /// `Favor completar información`
  String get pleasecompleteinformation {
    return Intl.message(
      'Favor completar información',
      name: 'pleasecompleteinformation',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa tu contraseña`
  String get enteryourpassword {
    return Intl.message(
      'Ingresa tu contraseña',
      name: 'enteryourpassword',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Validate code`
  String get validateCode {
    return Intl.message(
      'Validate code',
      name: 'validateCode',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar lenguaje`
  String get changeLanguage {
    return Intl.message(
      'Cambiar lenguaje',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Aplicar`
  String get apply {
    return Intl.message(
      'Aplicar',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa nueva contraseña`
  String get inputyournewpassword {
    return Intl.message(
      'Ingresa nueva contraseña',
      name: 'inputyournewpassword',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa nuevamente la nueva contraseña`
  String get inputyournewpasswordagain {
    return Intl.message(
      'Ingresa nuevamente la nueva contraseña',
      name: 'inputyournewpasswordagain',
      desc: '',
      args: [],
    );
  }

  /// `Input your new password`
  String get yourpasswordformat {
    return Intl.message(
      'Input your new password',
      name: 'yourpasswordformat',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar contraseña`
  String get changePassword {
    return Intl.message(
      'Cambiar contraseña',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Guaranteed rate`
  String get guaranteedrate {
    return Intl.message(
      'Guaranteed rate',
      name: 'guaranteedrate',
      desc: '',
      args: [],
    );
  }

  /// `Saturday, October`
  String get date {
    return Intl.message(
      'Saturday, October',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Finalizar`
  String get finished {
    return Intl.message(
      'Finalizar',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Statements report`
  String get statementsreport {
    return Intl.message(
      'Statements report',
      name: 'statementsreport',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar imagen`
  String get selectImage {
    return Intl.message(
      'Seleccionar imagen',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `Términos y condiciones`
  String get termsandconditions {
    return Intl.message(
      'Términos y condiciones',
      name: 'termsandconditions',
      desc: '',
      args: [],
    );
  }

  /// `Validar email`
  String get validateyouremail {
    return Intl.message(
      'Validar email',
      name: 'validateyouremail',
      desc: '',
      args: [],
    );
  }

  /// `Ingrese el código enviado en su correo electrónico.`
  String get pleaseentercodeemail {
    return Intl.message(
      'Ingrese el código enviado en su correo electrónico.',
      name: 'pleaseentercodeemail',
      desc: '',
      args: [],
    );
  }

  /// `Inserte el código`
  String get enterthecode {
    return Intl.message(
      'Inserte el código',
      name: 'enterthecode',
      desc: '',
      args: [],
    );
  }

  /// `Validar`
  String get validate {
    return Intl.message(
      'Validar',
      name: 'validate',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar tu número de teléfono`
  String get confirmyourphonenumber {
    return Intl.message(
      'Confirmar tu número de teléfono',
      name: 'confirmyourphonenumber',
      desc: '',
      args: [],
    );
  }

  /// `Tú número de teléfono es`
  String get yourphonenumberis {
    return Intl.message(
      'Tú número de teléfono es',
      name: 'yourphonenumberis',
      desc: '',
      args: [],
    );
  }

  /// `Hello!`
  String get hello {
    return Intl.message(
      'Hello!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Seleccionar galería de fotos`
  String get selectphotogallery {
    return Intl.message(
      'Seleccionar galería de fotos',
      name: 'selectphotogallery',
      desc: '',
      args: [],
    );
  }

  /// `Tomar foto`
  String get takephoto {
    return Intl.message(
      'Tomar foto',
      name: 'takephoto',
      desc: '',
      args: [],
    );
  }

  /// `Cancelar`
  String get cancel {
    return Intl.message(
      'Cancelar',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `¿Olvidaste tu contraseña?`
  String get forgotyourpassword {
    return Intl.message(
      '¿Olvidaste tu contraseña?',
      name: 'forgotyourpassword',
      desc: '',
      args: [],
    );
  }

  /// `It's not you`
  String get itnotyou {
    return Intl.message(
      'It\'s not you',
      name: 'itnotyou',
      desc: '',
      args: [],
    );
  }

  /// `manually enter the code`
  String get manuallyenterthecode {
    return Intl.message(
      'manually enter the code',
      name: 'manuallyenterthecode',
      desc: '',
      args: [],
    );
  }

  /// `Nombre`
  String get name {
    return Intl.message(
      'Nombre',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Apellido`
  String get lasname {
    return Intl.message(
      'Apellido',
      name: 'lasname',
      desc: '',
      args: [],
    );
  }

  /// `Identification number`
  String get identificationnumber {
    return Intl.message(
      'Identification number',
      name: 'identificationnumber',
      desc: '',
      args: [],
    );
  }

  /// `Dirección`
  String get address {
    return Intl.message(
      'Dirección',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Nombre dirección`
  String get nameAddress {
    return Intl.message(
      'Nombre dirección',
      name: 'nameAddress',
      desc: '',
      args: [],
    );
  }

  /// `Home address`
  String get homeaddres {
    return Intl.message(
      'Home address',
      name: 'homeaddres',
      desc: '',
      args: [],
    );
  }

  /// `Cargando`
  String get loading {
    return Intl.message(
      'Cargando',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get languageString {
    return Intl.message(
      'en',
      name: 'languageString',
      desc: '',
      args: [],
    );
  }

  /// `Aceptar términos y condiciones`
  String get acceptTerms {
    return Intl.message(
      'Aceptar términos y condiciones',
      name: 'acceptTerms',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa con Google`
  String get google {
    return Intl.message(
      'Ingresa con Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Ingresa con Apple`
  String get apple {
    return Intl.message(
      'Ingresa con Apple',
      name: 'apple',
      desc: '',
      args: [],
    );
  }

  /// `Your Send`
  String get yoursend {
    return Intl.message(
      'Your Send',
      name: 'yoursend',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get show {
    return Intl.message(
      'Show',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Partner`
  String get partner {
    return Intl.message(
      'Partner',
      name: 'partner',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar`
  String get change {
    return Intl.message(
      'Cambiar',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Favorite User`
  String get favoriteUser {
    return Intl.message(
      'Favorite User',
      name: 'favoriteUser',
      desc: '',
      args: [],
    );
  }

  /// `Completar información`
  String get completeInformation {
    return Intl.message(
      'Completar información',
      name: 'completeInformation',
      desc: '',
      args: [],
    );
  }

  /// `Is not you`
  String get itsnotyou {
    return Intl.message(
      'Is not you',
      name: 'itsnotyou',
      desc: '',
      args: [],
    );
  }

  /// `Step 1`
  String get step1 {
    return Intl.message(
      'Step 1',
      name: 'step1',
      desc: '',
      args: [],
    );
  }

  /// `Save account`
  String get saveaccount {
    return Intl.message(
      'Save account',
      name: 'saveaccount',
      desc: '',
      args: [],
    );
  }

  /// `Info user`
  String get infouser {
    return Intl.message(
      'Info user',
      name: 'infouser',
      desc: '',
      args: [],
    );
  }

  /// `Cambiar contraseña`
  String get changeseguritypin {
    return Intl.message(
      'Cambiar contraseña',
      name: 'changeseguritypin',
      desc: '',
      args: [],
    );
  }

  /// `Contraseña actua`
  String get previouspin {
    return Intl.message(
      'Contraseña actua',
      name: 'previouspin',
      desc: '',
      args: [],
    );
  }

  /// `Nueva contraseña`
  String get newpin {
    return Intl.message(
      'Nueva contraseña',
      name: 'newpin',
      desc: '',
      args: [],
    );
  }

  /// `Confirmar contraseña`
  String get confirmnewpin {
    return Intl.message(
      'Confirmar contraseña',
      name: 'confirmnewpin',
      desc: '',
      args: [],
    );
  }

  /// `Tipo de cuenta`
  String get accountype {
    return Intl.message(
      'Tipo de cuenta',
      name: 'accountype',
      desc: '',
      args: [],
    );
  }

  /// `Control y facilidad`
  String get slideIntro1 {
    return Intl.message(
      'Control y facilidad',
      name: 'slideIntro1',
      desc: '',
      args: [],
    );
  }

  /// `Pregunta requerida`
  String get questionrequired {
    return Intl.message(
      'Pregunta requerida',
      name: 'questionrequired',
      desc: '',
      args: [],
    );
  }

  /// `No hay resultados`
  String get noresult {
    return Intl.message(
      'No hay resultados',
      name: 'noresult',
      desc: '',
      args: [],
    );
  }

  /// `Ha ocurrido un error, por favor inténtelo de nuevo más tarde`
  String get errornotification {
    return Intl.message(
      'Ha ocurrido un error, por favor inténtelo de nuevo más tarde',
      name: 'errornotification',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
