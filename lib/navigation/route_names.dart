import 'dart:html';

import 'package:flutter/material.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/presentation/screens/admin_panel/admin_portal/admin_portal_screen.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_login/tenant_login_screen.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_portal/tenant_portal_screen.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_reset_password/tenant_resetpw_screen.dart';
import 'package:silverhome/presentation/screens/basic_tenant/tenant_signup/tenant_signup_screen.dart';
import 'package:silverhome/presentation/screens/customer/customer_featurelist_page.dart';
import 'package:silverhome/presentation/screens/forgot_password/forgotpassword_screen.dart';
import 'package:silverhome/presentation/screens/landlord/leaseAgreement/tenancy_lease_agreement_screen.dart';
import 'package:silverhome/presentation/screens/landlord/portal/portal_screen.dart';
import 'package:silverhome/presentation/screens/landlord/reference_questionnaire/reference_questionnaire_screen.dart';
import 'package:silverhome/presentation/screens/landlord/tenancyform/tenancyapplicationfrom_screen.dart';
import 'package:silverhome/presentation/screens/landlord/varificationDocument/tenancy_varification_document_screen.dart';
import 'package:silverhome/presentation/screens/landlord/welcome_screen/welcome_screen.dart';
import 'package:silverhome/presentation/screens/login/login_screen.dart';
import 'package:silverhome/presentation/screens/maintenance_request/maintenace_request.dart';
import 'package:silverhome/presentation/screens/register/registration_screen.dart';
import 'package:silverhome/presentation/screens/reset_password/resetpassword_screen.dart';
import 'package:silverhome/presentation/screens/splash/splash_screen.dart';
import 'package:silverhome/presentation/screens/under_maintenance/under_maintenance.dart';
import 'package:silverhome/widget/tenantScreening/widget.dart';

import '../presentation/screens/landlord/tenancyform/taf_employment_screen.dart';
import '../widget/tenantScreening/progress_widget.dart';

class RouteNames {
  static const String splashScreen = '/';
  static const String Login = '/login';
  static const String ForgotPassword = '/forgotpassword';
  static const String Welcome = '/welcome';
  static const String ResetPassword = '/resetpassword';
  static const String Register = '/register';
  static const String Portal = '/portal';
  static const String TenancyApplicationform = '/tenancy_application_form';
  static const String TenancyVerificationDocument = '/tenancy_verification_document';
  static const String TenancyLeaseAgreement = '/tenancy_lease_agreement';
  static const String ReferenceQuestionnaire = '/reference_questionnaire';
  static const String CustomerPropertyPage = '/customerfeaturedpage';
  static const String underMaintenanceScreen = '/undermaintenance';

  /*Admin_portal*/
  static const String Admin_Portal = '/admin/portal';

  /*Basic Tenant Portal*/
  /* static const String Basic_Tenant_Portal = '/tenant_portal';
  static const String Basic_Tenant_Login = '/tenant_login';
  static const String MaintenanceRequest = '/MaintenanceRequest';*/

  static const String Basic_Tenant_Portal = 'tenant_portal';
  static const String Basic_Tenant_Login = 'tenant_login';
  static const String Basic_Tenant_Register = 'tenant_register';
  static const String maintenanceRequest = 'maintenance_request';
  static const String TenantResetpassword = 'tenant_resetpassword';

  static bool isFresh = true;

  static Map<String, Widget Function(BuildContext)> routes = {
    splashScreen: (context) => /* LoginScreen(), */

        /* SizedBox(
      height:800,
      width:900,
      child: Scaffold(
        body: StepCompletionWidget(
              indexOfCompletion: 2,
              currentIndex: 1,
              numberOfSteps: 4,
              stepsText: const ["P1","P2","P3"],
              content: [Container(), Container(), Container(), Container()],
            ),
      ),
    ), */
        SplashScreen(),
    Login: (context) => LoginScreen(),
    underMaintenanceScreen: (context) => UnderMaintenanceScreen(),
    ForgotPassword: (context) => ForgotPasswordScreen(),
    Register: (context) => RegistrationScreen(),
    Portal: (context) => !Prefs.getBool(PrefsName.Is_login) ? LoginScreen() : PortalScreen(),
    Admin_Portal: (context) =>
        !Prefs.getBool(PrefsName.Is_login) || !Prefs.getBool(PrefsName.Is_adminlogin) ? LoginScreen() : AdminPortalScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    List<String> pathComponents = settings.name!.split('/');

    /*if (pathComponents.length == 2) {
      switch ("/${pathComponents[1]}") {
        case TenancyApplicationform:
          return MaterialPageRoute(
            builder: (_) => TenancyApplicationFormScreen(),
            settings: RouteSettings(name: "/" + pathComponents[1]),
          );
        case ReferenceQuestionnaire:
          return MaterialPageRoute(
            builder: (_) => ReferenceQuestionnaireScreen(),
            settings: RouteSettings(name: "/" + pathComponents[1]),
          );
        default:
          {
            return MaterialPageRoute(
              builder: (_) => CustomerFeaturedlistPage(LID: pathComponents[1]),
              settings: RouteSettings(name: "/${pathComponents[1]}"),
            );
          }
      }
    }*/

    if (pathComponents.length == 2) {
      Helper.Log("Got to pathComponents", "2");

      String url = window.location.href.toString();
      List<String> components = url.substring(url.indexOf("#") + 1).split("/");
      if (pathComponents.length != components.length && isFresh) {
        pathComponents = components;
        isFresh = false;
        return MaterialPageRoute(builder: (_) => SizedBox());
      }
      switch ("/${pathComponents[1]}") {
        case TenancyApplicationform:
          Helper.Log("Got to TenancyApplicationform", "2");

          return MaterialPageRoute(
            builder: (_) => TenancyApplicationFormScreen(),
            settings: RouteSettings(name: "/" + pathComponents[1]),
          );
        case ReferenceQuestionnaire:
          return MaterialPageRoute(
            builder: (_) => ReferenceQuestionnaireScreen(),
            settings: RouteSettings(name: "/" + pathComponents[1]),
          );
        default:
          {
            String url = window.location.href;

            Helper.Log("Got to url", url);

            if (!url.contains(ResetPassword) ||
                !url.contains(TenancyApplicationform) ||
                !url.contains(TenancyVerificationDocument) ||
                !url.contains(ReferenceQuestionnaire) ||
                !url.contains(TenancyLeaseAgreement) ||
                !url.contains(Welcome) ||
                !url.contains(maintenanceRequest) ||
                !url.contains(TenantResetpassword) ||
                !url.contains(Basic_Tenant_Register)) {
              return MaterialPageRoute(
                builder: (_) => CustomerFeaturedlistPage(LID: pathComponents[1]),
                settings: RouteSettings(name: "/${pathComponents[1]}"),
              );
            }
            return MaterialPageRoute(builder: (_) => SizedBox());
          }
      }
    } else if (pathComponents.length == 3) {
      Helper.Log("Got to pathComponents", "3");

      switch ("/${pathComponents[1]}") {
        case Welcome:
          return MaterialPageRoute(
            builder: (_) => WelcomeScreen(ID: pathComponents[2]),
          );
        case ResetPassword:
          return MaterialPageRoute(
            builder: (_) => ResetPaswordScreen(ID: pathComponents[2]),
          );
        case TenancyApplicationform:
          Helper.Log("Got to TenancyApplicationform", "3");

          return MaterialPageRoute(
            builder: (_) => TenancyApplicationFormScreen(ApplicantID: pathComponents[2]),
            settings: RouteSettings(name: "/" + pathComponents[1] + "/" + pathComponents[2]),
          );
        case TenancyVerificationDocument:
          return MaterialPageRoute(
            builder: (_) => TenancyVerificationDocumentScreen(applicantID: pathComponents[2]),
            settings: RouteSettings(name: "/" + pathComponents[1] + "/" + pathComponents[2]),
          );
        case TenancyLeaseAgreement:
          return MaterialPageRoute(
            builder: (_) => TenancyLeaseAgreementScreen(ApplicationID: pathComponents[2]),
            settings: RouteSettings(name: "/" + pathComponents[1] + "/" + pathComponents[2]),
          );
        case ReferenceQuestionnaire:
          return MaterialPageRoute(
            builder: (_) => ReferenceQuestionnaireScreen(RID: pathComponents[2]),
            settings: RouteSettings(name: "/" + pathComponents[1] + "/" + pathComponents[2]),
          );
        default:
          {
            switch (pathComponents[2]) {
              case Basic_Tenant_Login:
                return MaterialPageRoute(
                  builder: (_) => TenantLoginScreen(Companyname: pathComponents[1].toString()),
                  settings: RouteSettings(name: "/${pathComponents[1]}/${pathComponents[2]}"),
                );
              case Basic_Tenant_Portal:
                return MaterialPageRoute(
                  builder: (_) => TenantPortalScreen(),
                  settings: RouteSettings(name: "/${pathComponents[1]}/${pathComponents[2]}"),
                );
              default:
                return _errorRoute();
            }
          }
      }
    } else if (pathComponents.length == 4) {
      Helper.Log("Got to pathComponents", "4");

      switch (pathComponents[2]) {
        case Basic_Tenant_Register:
          return MaterialPageRoute(
            builder: (_) => TenantSignupScreen(Companyname: "${pathComponents[1]}", ID: "${pathComponents[3]}"),
            settings: RouteSettings(name: "/${pathComponents[1]}/${pathComponents[2]}/${pathComponents[3]}"),
          );
        case maintenanceRequest:
          return MaterialPageRoute(
            builder: (_) => MaintenanceRequest(mID: "${pathComponents[3]}"),
            settings: RouteSettings(name: "/${pathComponents[1]}/${pathComponents[2]}/${pathComponents[3]}"),
          );
        case TenantResetpassword:
          return MaterialPageRoute(
            builder: (_) => TenantResetPWScreen(Companyname: "${pathComponents[1]}", ID: "${pathComponents[3]}"),
            settings: RouteSettings(name: "/${pathComponents[1]}/${pathComponents[2]}/${pathComponents[3]}"),
          );
        default:
          return _errorRoute();
      }
    }
    return _errorRoute();
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text(
            'ERROR : wrong routing',
            style: MyStyles.Medium(18, myColor.Circle_main),
          ),
        ),
      );
    });
  }
}

Future<void> navigateTo(BuildContext context, String screen) async {
  Navigator.pushNamed(context, screen);
}
