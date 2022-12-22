class Weburl {
  static bool ShowLog = false;

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  static bool Domain_PROD = false;
  static bool Domain_UAT = false; //User Acceptance Testing
  static bool Domain_CR = false; //Quality Assurance or Change request
  static bool Domain_Dev = true;

  static bool isPROD_API = false;

  static bool IS_PROD = false;
  static bool IS_UAT = false;
  static String DBCODE_PROD = "SilverHome";
  static String DBCODE_UAT = "SilverHome_UAT";
  static String DBCODE_DEV = "SilverHome_DEV";

  static String urlProd = "https://app.silverhomes.ai/#/";
//"https://www.ren-hogar.com/#/
  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  static var Domain_NEW = "https://";
  static var Domain_URL = Domain_PROD
      ? "https://app.silverhomes.ai/#/"
      : Domain_UAT
          ? "http://161.97.104.204:8090/#/"
          : Domain_CR
              ? "http://161.97.104.204:8091/#/"
              : urlProd;

  static var Email_URL = Domain_PROD
      ? "https://app.silverhomes.ai/"
      : Domain_UAT
          ? "http://161.97.104.204:8090"
          : Domain_CR
              ? "http://161.97.104.204:8091"
              : "https://danivargas.co/";

  static var CustomerFeaturedPage = Domain_URL;

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/
  // static var API_ServerNew = isPROD_API
  //     ? "https://prsjz0gbn3.execute-api.us-east-1.amazonaws.com/staging/"
  //     : "https://vuy3fbu93g.execute-api.us-east-1.amazonaws.com/prod/";

  static var API_Server = isPROD_API
      ? "https://api.silverhomes.ai"
      : "https://qjif09kr99.execute-api.us-east-1.amazonaws.com/dev";

//      : "https://25k75q7gy2.execute-api.us-east-1.amazonaws.com";

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  /* static var API_Server = isPROD_API
      ? "https://silverhomeappinstance.azurewebsites.net"
      : isUAT_API
          ? "http://161.97.104.204:4049"
          : "http://161.97.104.204:8013";*/

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  static var API_CODE = IS_PROD
      ? DBCODE_PROD
      : IS_UAT
          ? DBCODE_UAT
          : DBCODE_DEV;

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  static var DocURL =
      API_Server + "/appdata/" + API_CODE + "/Attachments/Files/";
  //static var image_API = API_Server + "/default/file?id=";
  static var image_API = Email_URL + "r/?id=";

  static var base_url = API_Server + "/"; //"/api/v1/CRUD/";
  static var base_url_Login = API_Server + "/";
  //static var base_url_Login = API_Server + "/default/";
  //static var base_url_Login = API_Server + "/api/v1/identity/";
  static var base_url_WorkFlow = API_Server + "/";

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  static var Role = "Administrator";
  static var RoleID = "b46739e6-afcb-47ef-a674-7be205a8e4e3";

  static var Super_Admin_Role = "SuperAdmin";
  static var Super_Admin_RoleID = "C22CAB85-3157-4F85-887C-968A625EB644";

  static var Member_Role = "Member";
  static var Member_RoleID = "7811057A-7288-4A6A-BA91-1903E743A07C";

  static var Select_Api = base_url + "select";
  static var Insert_Api = base_url + "insert";
  static var Update_Api = base_url + "update";
  static var Delete_Api = base_url + "delete";
  static var Query_Api = base_url + "query";
  //static var RawSQL_Api = base_url + "RawSQL?";
  static var RawSQL_Api = Email_URL + "rawsql/?";

  //static var FileUpload_Api = base_url_WorkFlow + "upload";
  static var FileUpload_Api = Email_URL + "aws/";
  static var DSQ_Api = base_url + "DSQ";
  static var GetNamesS3 = base_url + "upload-link";
  static var InsertMedia = base_url + "insert-media";
  static var WorkFlow_Api = base_url_WorkFlow + "workflow/";

  static var login_Api = base_url_Login + "login";

  static var register_Api = base_url_Login + "register";
  static var ChangePassword_Api = base_url_Login + "changepassword";

  static var Standard_API = "&Type=standard";
  static var Icon_API = "&Type=icon";
  static var Thumbnail_API = "&Type=thumbnail";

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  static var silverhomes_url = "https://www.silverhomes.ai";

  //static var silverhomes_contact_url_old = "contact@silverhomes.ai";
  static var silverhomes_contact_url = "support@silverhomes.ai";

  //static var silverhomes_contact_mail_old = "mailto:contact@silverhomes.ai";
  static var silverhomes_contact_mail = "mailto:support@silverhomes.ai";

  static var Sample_Properties_csv = Email_URL + "sample_bulk_properties.csv";

  static var Sample_property_value_file =
      Email_URL + "data_entry_instructions.xlsx";

  static var PrivacyPolicy_and_TermsConditions =
      "https://www.silverhomes.ai/legal";

  static var verification_document_url =
      "https://www.consumer.equifax.ca/personal/products/credit-score-report/";

  /*X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X-X*/

  /*DSQ API CALL*/
  static var DSQ_CommonView = "EBE4AF34-DD14-48AE-BE48-506EBC162BA5";
  static var DSQ_UserLogin = "79E93CA0-4C99-428E-A4C2-D593BF1A2F71";
  static var DSQ_CheckUserExist = "f43d6117-ee65-4c7c-abac-ffae0ef7d638";
  static var DSQ_SYSTEMENUM = "BBA3DA70-D120-46AF-AC3F-BABE13B7318C";
  static var DSQ_TenancyStatusCount = "D10E98FB-4AEE-4A5F-A94B-68FC5208F7D2";
  static var DSQ_PropertyStatusCount = "DCB21DB3-58F7-47F0-BDAA-E70E08E2AD60";
  static var DSQ_PropertyOnBoardingList =
      "A31C1BFE-C78D-425F-B9F6-F7D2A6B70BE7";
  static var DSQ_PropertyDetails = "4602BD62-35B7-42FD-81E4-D14AA7D13ED5";
  static var DSQ_EventTypeDetails = "43534533-ASDD-EVENY-TYPR-SDF5";
  static var DSQ_EventTypeDetailsTemplate = "43534533-ASDD-EVENY-TYPR-TEMP";
  static var DSQ_Property_AM_UT = "09d001cb-9953-4ab7-ba2a-15396128cf56";
  static var DSQ_Property_Images = "18b332a0-4a49-4abb-a15d-f7a2ef64f2f9";
  static var DSQ_Property_Restrictions = "f9b47b59-860c-4438-8cce-37ce7290e53a";

  static var DSQ_EventTypesOnBoardingList =
      "A31C1BFE-C78D-425F-B9F5-F7D2A6B60BE8";

  static var DSQ_EventTypesOnBoardingListTemp =
      "A31C1BFE-C78D-425F-B9F5-F7D2A6B60999";

  static var DSQ_EventTypesOnBoardingListTempver =
      "A31C1BFE-C78D-425F-B9F5-F7D2A6B60992";

  static var DSQ_getNamesEvent = "A31C1BFE-C78D-425F-B9F5-F7D2A6B60NNN";
  static var DSQ_EventTypesSlots = "A31C1BFE-C78D-425F-B9F5-F7D2A6B60BE2";
  static var DSQ_EventTypesSlots1 = "A31C1BFE-C78D-425F-B9F5-F7D2A6B60BE1";
  static var DSQ_APPLICATIONLIST_OWNERWISE =
      "CB8345B3-BA21-4FB7-8B38-BBF7EF074AA7";
  static var DSQ_APPLICANT_DETAILS = "0FE8C355-75AA-453E-881D-E3D91D3B4D11";
  static var DSQ_APPLICANT_Application = "0d35722e-5560-4e0a-a44a-34130dfb15b2";
  static var DSQ_APPLICANT_AdditionalOccupant =
      "64cfba80-7ccb-4ea0-aa07-d5b8ef0e8919";
  static var DSQ_APPLICANT_AdditionalReference =
      "91bb808a-01a7-44c8-b637-e117231ebf74";
  static var DSQ_APPLICANT_CurrentTenancy =
      "85424946-cf76-4849-a4c6-11cba825e5e3";
  static var DSQ_APPLICANT_Employemant = "374669a1-14b8-4011-9e38-a7a02c4650c4";
  static var DSQ_APPLICANT_PetInfo = "b4a611b5-43a8-49f5-850f-0d3ec4d674a7";
  static var DSQ_APPLICANT_VehicleInfo = "0489cf7f-6724-4fc9-9211-136294cab103";
  // Note Use //static var DSQ_VARIFICATION_DOCUMENTLIST = "66DB2BDD-674E-4E5E-A67B-06CEEFAE75F8";
  static var DSQ_VIEW_VARIFICATION_DOCUMENTData =
      "B9027858-8D51-485F-BFDB-00ED6D5207A2";
  static var DSQ_VIEW_VARIFICATION_DOCUMENTLIST =
      "c9034517-1c57-4910-b93c-b0822974cb48";
  static var DSQ_APPLICANT_REFERENCE_CHECK_LIST =
      "192C8D29-A42B-45AA-B77D-4D4DFB3F1D8A";
  static var DSQ_REFERENCE_LIST_APPLICANT_WISE =
      "025566ED-F18F-47A0-907E-8C2AB625497B";
  static var DSQ_REFERENCE_Details = "5EF565CD-72CA-4CF2-AD83-5353E4120439";
  static var DSQ_VIEW_LEASE_DETAILS = "90065C54-F797-4886-9871-94F78F156742";
  static var DSQ_VIEW_LEASE_Document = "2a814940-8100-430e-ab7c-a538d6f75871";
  static var DSQ_Notification = "38ABB85C-E04E-44ED-B6BD-C313D7854F66";
  static var DSQ_User_ProfileDetails = "2A3A9C63-E440-4EA5-9705-BB36C8D7D245";

  /*Workflow ID*/
  static var Welcome_workflow = "C2C47DF1-606D-4255-ACEB-CB9CB79A9084";
  static var Lead_Invitation_workflow = "8229F603-5461-44EF-9B1C-86B4D46D2C7E";
  static var Document_Request_workflow = "AD1FB523-3500-4925-A520-CA26B9EB9901";
  static var Reference_Request_workflow =
      "D1397E39-98B0-4C24-BF25-9B9FFC9A22AC";
  static var Leasesent_workflow = "149A3CF8-4A1B-4E72-8EE9-5B7104249F32";
  static var WorkFlow_DuplicatProperty = "1DF5CC24-A44B-45DE-B9E4-289D65EAC2DD";
  static var WorkFlow_DuplicateEventype =
      "1DF5CC24-A44B-45DE-B9E4-289D65EAC222";
  static var WorkFlow_DuplicateEventypeTemplate =
      "1DF5CC24-A44B-45DE-B9E4-289D65EAC777";
  static var WorkFlow_CreateTemplateEventype =
      "1DF5CC24-A44B-45DE-B9E4-289D65EAC333";
  static var WorkFlow_Featured_image = "17D6D091-6A4D-49E9-84AD-8A0C675DDC8B";
  static var WorkFlow_Image_zip = "629DFE4B-BE8E-4E6F-8E7A-574B725EA8EA";
  static var WorkFlow_ResetPassWordMain =
      "261197C1-A298-4C0F-9954-6373630EC312";
  static var WorkFlow_Property_Archive = "46A7EE92-106C-4200-BB95-13F4E94EBDE6";
  static var WorkFlow_Property_Archive_Restore =
      "FE623FE8-9538-41C1-A505-AD22EF773A8D";
  static var WorkFlow_All_Archive_Property =
      "A92FF41C-3874-4F6D-AA1F-433B9054B509";
  static var WorkFlow_ReferenceRequestReceivedDate =
      "DED13ACC-FE21-4090-AB2C-08A8ACB28620";
  static var WorkFlow_RestoreAllArchive =
      "ECC4B79A-77D6-431A-83F8-F58BE84FA562";
  static var WorkFlow_ActiveTenant = "34F4BE34-7F77-4C58-B600-1EF90B0292AD";
  static var WorkFlow_Notifi_Application =
      "D0798C7C-C674-452E-9CCA-578F710B7E87";
  static var WorkFlow_Notifi_Document = "10381376-5A21-4D44-BFE0-0A47E6C1F07A";
  static var WorkFlow_Notifi_Reference = "0B991D1C-9558-463B-8942-126E4C8B0116";
  static var WorkFlow_Notifi_lease = "8DFEF354-D7A0-4B98-929E-32A6A7359D2A";
  static var WorkFlow_Terminate_Tenancy =
      "709403DF-8279-455A-BC8D-1188D0DA1FE4";

  /*============================================================================*/
  /*=============================   Admin Screen ===============================*/
  /*============================================================================*/
  static var Admin_Dashbord_DSQ1 = "AA12026A-494F-496C-9EE4-4F4853462853";
  static var Admin_Dashbord_DSQ2 = "A613BEF7-5362-448F-B8D8-954F13B0FB2A";
  static var Admin_LandlordList = "5C1C6D4A-5DE8-4471-AE8A-CC7BB42EDF2B";
  static var Admin_Landlord_details = "2A0144AA-8B19-4756-9B82-292896EBBE31";
  static var Admin_website_maintenance = "D79D5C17-EFF4-4196-8FF1-4B6FCCD02A9C";
  static var Admin_Landlord_propertyList =
      "A31C1BFE-C78D-425F-B9F6-F7D2A6B70BE7";
  static var Admin_Landlord_propertyList_New =
      "CC387F7A-B084-482A-9302-95669E77ADF8";
  static var Admin_Landlord_property_details =
      "4602BD62-35B7-42FD-81E4-D14AA7D13ED5";
  static var Admin_Landlord_LeadsList = "EBE4AF34-DD14-48AE-BE48-506EBC162BA5";
  static var Admin_Landlord_Leads_details =
      "0FE8C355-75AA-453E-881D-E3D91D3B4D11";
  static var workflow_Admin_Landlord_Property_Upload =
      "92A8329A-F944-4167-A12D-5250F14EDDFC";
  static var workflow_Admin_Customer_URL =
      "44B63695-7DEE-4720-816C-395371DDF113";

  /*============================================================================*/
  /*=============================   Common API  ===============================*/
  /*============================================================================*/
  static var DSQ_Country = "df730b13-7cf4-4398-bd48-059426808d09";
  static var DSQ_State = "4fbe976f-7234-430e-aea6-a0b242463ada";
  static var DSQ_City = "50cc1bc9-dfc0-49bc-8085-0efb46797230";

  /*============================================================================*/
  /*=============================   Customer  ===============================*/
  /*============================================================================*/
  static var DSQ_Featue_propertylist = "3DA3DE9E-87AF-4AEB-B9BE-D4F48B208FDE";
  static var DSQ_TenantEmail_already_Property =
      "1879AF78-107B-4DC6-813A-47A6B5C22E6C";

  /*============================================================================*/
  /*============================= Maintenace Module ============================*/
  /*============================================================================*/
  static var DSQ_landlord_Maintenance_Count =
      "e337b8ca-53f2-47ef-93ab-bde4129f3772";
  static var DSQ_Property_Maintenance_list =
      "77a3bf68-b6de-451c-83b8-06652e433d28";
  //static var DSQ_landlord_MaintenanceList = "08EC96E2-F319-463C-A0FB-9E44202CCC44";
  static var DSQ_landlord_MaintenanceList =
      "0d6fa4ab-3b15-496d-b181-3a860a4181f8";
  static var DSQ_landlord_Maintenance_Details =
      "3558F43C-6981-4843-8229-7552048F58C8";
  static var DSQ_landlord_MaintenanceVendor_Details =
      "d114ea9b-61fc-443f-a200-72be8718c992";
  static var DSQ_landlord_PropertyMaintenanceImages =
      "fb4d7ee9-9cbb-48a6-b738-97bdc234c4be";
  static var DSQ_LogActivity_list = "78DCFF48-E132-4F9F-87BE-81788F930614";
  static var DSQ_Applicant_Propertywise =
      "2b72bb56-5c52-4d1f-b3b7-3b5007039a2c";
  static var workflow_landlord_Maintenance_Duplicate =
      "A9449386-B324-43A0-8315-8AF80B4AD56E";

  /*============================================================================*/
  /*============================= Vendor Module  ===============================*/
  /*============================================================================*/
  static var DSQ_landlord_VendorList = "688B8F85-E969-4448-AA3C-8A720E9613FD";
  static var DSQ_City_Wise_VendorList = "88ee034a-5a09-4157-85c9-1215f63a7920";
  static var DSQ_Vendor_Details = "E09EFEF9-5818-427F-A1B4-2C126739275C";
  static var workflow_landlord_Vendor_Duplicate =
      "480d26a5-e639-4223-b3f2-09c83c51b8fe";

  /*============================================================================*/
  /*=============================  Tenant Profile  ===============================*/
  /*============================================================================*/
  static var WorkFlow_tenant_forgotpass =
      "4BF75FD9-98E2-4F0D-968C-D381DDDDC6BF";
  static var workflow_tenant_register_old =
      "E27A87B1-0E21-41D4-916B-06A3200134A3";
  static var workflow_tenant_register = "504f96f9-8015-4833-9464-9fd89bec46b2";
  static var DSQ_tenant_Details = "aad4e3d4-1270-4235-ba7f-7fe681fdbe3f";
  static var DSQ_Application_by_Applicant =
      "02d871a8-5ce3-4579-9f6c-ba0ec83c53db";
  /*============================================================================*/
  /*=============================  Documents  ===============================*/
  /*============================================================================*/
  static var Create_Document_Api = base_url + "documents/create/folder";
  static var Restore_Document_Api = base_url + "documents/restore";
  static var Rename_Document_Api = base_url + "documents/remane";
  static var Upload_Document_Api = base_url + "documents/upload";
  static var Duplicate_Document_Api = base_url + "documents/duplicate";
  static var Delete_Document_Api = base_url + "documents/delete";
  static var Move_Document_Api = base_url + "documents/move";
  static var Get_Document_Filters_Api = base_url + "documents/filters";
  static var Get_Documents_List = base_url + "documents/list";
  static var Change_Restrict_Editing = base_url + "documents/restrict";
}
