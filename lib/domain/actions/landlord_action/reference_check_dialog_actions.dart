import 'package:silverhome/domain/actions/action.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/presentation/models/app_state.dart';

class UpdateRCDLeadReferencelist implements Action {
  final List<LeadReference> leadReferencelist;

  UpdateRCDLeadReferencelist(this.leadReferencelist);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith
        .referenceCheckDialogState(leadReferencelist: leadReferencelist);
  }
}

class UpdateRCDisAllCheck implements Action {
  final bool isAllCheck;

  UpdateRCDisAllCheck(this.isAllCheck);

  @override
  AppState updateState(AppState appState) {
    return appState.copyWith.referenceCheckDialogState(isAllCheck: isAllCheck);
  }
}
