import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/presentation/models/admin_models/admin_dashbord_state.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_account_state.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_leads_state.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_property_state.dart';
import 'package:silverhome/presentation/models/admin_models/admin_landlord_state.dart';
import 'package:silverhome/presentation/models/admin_models/admin_setting_state.dart';
import 'package:silverhome/presentation/models/basic_tenant/lease_details_state.dart';
import 'package:silverhome/presentation/models/basic_tenant/tenant_personal_state.dart';
import 'package:silverhome/presentation/models/customer/customer_propertylist_state.dart';
import 'package:silverhome/presentation/models/landlord_models/event_types_state.dart';
import 'package:silverhome/presentation/models/landlord_models/event_types_summery_state.dart';
import 'package:silverhome/presentation/models/landlord_models/landlord_tenancy_activetenant_state.dart';
import 'package:silverhome/presentation/models/landlord_models/landlord_tenancy_applicant_state.dart';
import 'package:silverhome/presentation/models/landlord_models/landlord_tenancy_lead_state.dart';
import 'package:silverhome/presentation/models/landlord_models/notification_state.dart';
import 'package:silverhome/presentation/models/vendor/add_vendor_state.dart';

import 'admin_models/admin_add_newmember_state.dart';
import 'admin_models/admin_landlord_leads_details_state.dart';
import 'admin_models/admin_landlorddetails_state.dart';
import 'admin_models/admin_portal_state.dart';
import 'admin_models/admin_property_details_state.dart';
import 'admin_models/admin_team_state.dart';
import 'basic_tenant/tenant_add_maintenance_state.dart';
import 'basic_tenant/tenant_maintenance_state.dart';
import 'basic_tenant/tenant_portal_state.dart';
import 'customer/customer_portal_state.dart';
import 'customer/customer_property_details_state.dart';
import 'landlord_models/editlead_state.dart';
import 'landlord_models/event_types_form_state.dart';
import 'landlord_models/funnelview_state.dart';
import 'landlord_models/landlord_profile_state.dart';
import 'landlord_models/landlord_tenancy_lease_state.dart';
import 'landlord_models/landlordapplication_state.dart';
import 'landlord_models/landlordtenancyarchive_state.dart';
import 'landlord_models/newlead_state.dart';
import 'landlord_models/portal_state.dart';
import 'landlord_models/preview_document_state.dart';
import 'landlord_models/preview_lease_state.dart';
import 'landlord_models/property_list_state.dart';
import 'landlord_models/eventtypes_list_state.dart';
import 'landlord_models/property_state.dart';
import 'landlord_models/property_summery_state.dart';
import 'landlord_models/propertyform_state.dart';
import 'landlord_models/reference_check_dialog_state.dart';
import 'landlord_models/reference_questionnaire_details_state.dart';
import 'landlord_models/reference_questionnaire_state.dart';
import 'landlord_models/referencecheck_state.dart';
import 'landlord_models/tenancy_lease_agreement_state.dart';
import 'landlord_models/tenancy_varification_doc_state.dart';
import 'landlord_models/tenancyform_state.dart';
import 'landlord_models/tenants_application_details_state.dart';
import 'landlord_models/tenantsfilter_state.dart';
import 'landlord_models/tf_additonal_info_state.dart';
import 'landlord_models/tf_additonal_occupant_state.dart';
import 'landlord_models/tf_additonal_reference_state.dart';
import 'landlord_models/tf_currenttenancy_state.dart';
import 'landlord_models/tf_employment_state.dart';
import 'landlord_models/tf_personal_state.dart';
import 'landlord_models/varification_document_state.dart';
import 'maintenance/add_maintenance_state.dart';
import 'maintenance/edit_maintenance_state.dart';
import 'maintenance/landlord_maintenance_state.dart';
import 'maintenance/maintenance_details_state.dart';
import 'vendor/landlord_vendor_state.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  factory AppState({
    required PortalState portalState,
    required TenancyFormState tenancyFormState,
    required TFPersonalState tfPersonalState,
    required TFEmploymentState tfEmploymentState,
    required TFCurrentTenancyState tfCurrentTenancyState,
    required TFAdditionalOccupantState tfAdditionalOccupantState,
    required TFAdditionalInfoState tfAdditionalInfoState,
    required TFAdditionalReferenceState tfAdditionalReferenceState,
    required TenantFilterState tenantFilterState,
    required LandLordApplicationState landLordApplicationState,
    required NewLeadState newLeadState,
    required FunnelViewState funnelViewState,
    required PropertyFormState propertyFormState,
    required EventTypesFormState eventTypesFormState,
    required PropertyState propertyState,
    required EventTypesState eventTypesState,
    required PropertySummeryState propertySummeryState,
    required EventTypesSummeryState eventTypesSummeryState,
    required PropertyListState propertyListState,
    required EventTypesListState eventTypesListState,
    required EditLeadState editLeadState,
    required TenantsApplicationDetailsState tenantsApplicationDetailsState,
    required TenancyVarificationDocumentState tenancyVarificationDocumentState,
    required VarificationDocumentState varificationDocumentState,
    required ReferenceQuestionnaireState referenceQuestionnaireState,
    required PreviewDocumentState previewDocumentState,
    required ReferenceCheckState referenceCheckState,
    required LandLordTenancyArchiveState landLordTenancyArchiveState,
    required ReferenceQuestionnaireDetailsState
        referenceQuestionnaireDetailsState,
    required ReferenceCheckDialogState referenceCheckDialogState,
    required LandLordTenancyLeaseState landlordTenancyLeaseState,
    required LandLordActiveTenantState landLordActiveTenantState,
    required PreviewLeaseState previewLeaseState,
    required TenancyLeaseAgreementState tenancyLeaseAgreementState,
    required LandLordTenancyLeadState landLordTenancyLeadState,
    required LandLordTenancyApplicantState landLordTenancyApplicantState,
    required NotificationState notificationState,
    required LandlordProfileState profileState,
    required LandlordMaintenanceState landlordMaintenanceState,
    required LandlordVendorState landlordVendorState,
    required MaintenanceDetailsState maintenanceDetailsState,
    required AddMaintenanceState addMaintenanceState,
    required AddVendorState addVendorState,
    required EditMaintenanceState editMaintenanceState,

    /*Admin*/
    required AdminPortalState adminPortalState,
    required AdminDashbordState adminDashbordState,
    required AdminLandlordDetailsState adminLandlordDetailsState,
    required AdminAddNewMemberState adminAddNewMemberState,
    required AdminLandlordState adminLandlordState,
    required AdminLandlordAccountState adminLandlordAccountState,
    required AdminLandlordPropertyState adminLandlordPropertyState,
    required AdminPropertyDetailsState adminPropertyDetailsState,
    required AdminLandlordLeadsState adminLandlordLeadsState,
    required AdminLandlordLeadsDetailsState adminLandlordLeadsDetailsState,
    required AdminTeamState adminTeamState,
    required AdminSettingState adminSettingState,

    /*Customer*/
    required CustomerPortalState customerPortalState,
    required CustomerPropertylistState customerPropertylistState,
    required CustomerPropertyDetailsState customerPropertyDetailsState,

    /*Basic Tenant*/
    required TenantPortalState tenantPortalState,
    required TenantMaintenanceState tenantMaintenanceState,
    required LeaseDetailsState leaseDetailsState,
    required TenantAddMaintenanceState tenantAddMaintenanceState,
    required TenantPersonalState tenantPersonalState,
  }) = _AppState;

  factory AppState.initial() => AppState(
        portalState: PortalState.initial(),
        tenancyFormState: TenancyFormState.initial(),
        tfPersonalState: TFPersonalState.initial(),
        tfEmploymentState: TFEmploymentState.initial(),
        tfCurrentTenancyState: TFCurrentTenancyState.initial(),
        tfAdditionalOccupantState: TFAdditionalOccupantState.initial(),
        tfAdditionalInfoState: TFAdditionalInfoState.initial(),
        tfAdditionalReferenceState: TFAdditionalReferenceState.initial(),
        tenantFilterState: TenantFilterState.initial(),
        landLordApplicationState: LandLordApplicationState.initial(),
        newLeadState: NewLeadState.initial(),
        funnelViewState: FunnelViewState.initial(),
        propertyFormState: PropertyFormState.initial(),
        eventTypesFormState: EventTypesFormState.initial(),
        propertyState: PropertyState.initial(),
        eventTypesState: EventTypesState.initial(),
        propertySummeryState: PropertySummeryState.initial(),
        eventTypesSummeryState: EventTypesSummeryState.initial(),
        propertyListState: PropertyListState.initial(),
        eventTypesListState: EventTypesListState.initial(),
        editLeadState: EditLeadState.initial(),
        tenantsApplicationDetailsState:
            TenantsApplicationDetailsState.initial(),
        tenancyVarificationDocumentState:
            TenancyVarificationDocumentState.initial(),
        varificationDocumentState: VarificationDocumentState.initial(),
        referenceQuestionnaireState: ReferenceQuestionnaireState.initial(),
        previewDocumentState: PreviewDocumentState.initial(),
        referenceCheckState: ReferenceCheckState.initial(),
        landLordTenancyArchiveState: LandLordTenancyArchiveState.initial(),
        referenceQuestionnaireDetailsState:
            ReferenceQuestionnaireDetailsState.initial(),
        referenceCheckDialogState: ReferenceCheckDialogState.initial(),
        landlordTenancyLeaseState: LandLordTenancyLeaseState.initial(),
        landLordActiveTenantState: LandLordActiveTenantState.initial(),
        previewLeaseState: PreviewLeaseState.initial(),
        tenancyLeaseAgreementState: TenancyLeaseAgreementState.initial(),
        landLordTenancyLeadState: LandLordTenancyLeadState.initial(),
        landLordTenancyApplicantState: LandLordTenancyApplicantState.initial(),
        notificationState: NotificationState.initial(),
        profileState: LandlordProfileState.initial(),
        landlordMaintenanceState: LandlordMaintenanceState.initial(),
        landlordVendorState: LandlordVendorState.initial(),
        maintenanceDetailsState: MaintenanceDetailsState.initial(),
        addMaintenanceState: AddMaintenanceState.initial(),
        addVendorState: AddVendorState.initial(),
        editMaintenanceState: EditMaintenanceState.initial(),

        /*Admin*/
        adminPortalState: AdminPortalState.initial(),
        adminDashbordState: AdminDashbordState.initial(),
        adminLandlordDetailsState: AdminLandlordDetailsState.initial(),
        adminAddNewMemberState: AdminAddNewMemberState.initial(),
        adminLandlordState: AdminLandlordState.initial(),
        adminLandlordAccountState: AdminLandlordAccountState.initial(),
        adminLandlordPropertyState: AdminLandlordPropertyState.initial(),
        adminPropertyDetailsState: AdminPropertyDetailsState.initial(),
        adminLandlordLeadsState: AdminLandlordLeadsState.initial(),
        adminLandlordLeadsDetailsState:
            AdminLandlordLeadsDetailsState.initial(),
        adminTeamState: AdminTeamState.initial(),
        adminSettingState: AdminSettingState.initial(),

        /*Customer*/
        customerPortalState: CustomerPortalState.initial(),
        customerPropertylistState: CustomerPropertylistState.initial(),
        customerPropertyDetailsState: CustomerPropertyDetailsState.initial(),

        /*Basic Tenant*/
        tenantPortalState: TenantPortalState.initial(),
        tenantMaintenanceState: TenantMaintenanceState.initial(),
        leaseDetailsState: LeaseDetailsState.initial(),
        tenantAddMaintenanceState: TenantAddMaintenanceState.initial(),
        tenantPersonalState: TenantPersonalState.initial(),
      );
}
