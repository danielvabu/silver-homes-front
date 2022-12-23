enum etableName {
  Users,
  Property,
  Property_Features,
  Property_Restriction,
  Property_Amenities_Utilities,
  AdditionalOccupants,
  SystemEnumDetails,
  AdditionalReferences,
  Applicant,
  Application,
  ApplicationDocument,
  Attachments,
  Occupation,
  CurrentTenancy,
  Employment,
  Person,
  PetInfo,
  PropertyDocument,
  ReferenceAnswers,
  VehicleInfo,
  AspNetUsers,
  MediaInfo,
  Notification,
  PropertyImages,
  Website_under_Maintenance,
  Maintenance,
  MaintenanceVendor,
  LogActivities,
  PropertyMaintenanceImages,
  Vendor,
  Events_type,
  Availability,
  AvailabilityTime,
  Slots,
  availability_overrides,
  request_documents,
  list_documents,
  documentsfields,
  htmlRequest,
  Events_type_templates,
  AvailabilityTemplate,
  AvailabilityTimeTemplate,
  availability_overridesTemplate,
}

class TableNames {
  /*--------Get tabel name return--------*/
  getTabelname(value) {
    String name;
    switch (value) {
      case etableName.Users:
        name = "Users";
        break;
      case etableName.Property:
        name = "Property";
        break;
      case etableName.Property_Features:
        name = "Property_Features";
        break;
      case etableName.Property_Restriction:
        name = "Property_Restriction";
        break;
      case etableName.Property_Amenities_Utilities:
        name = "Property_Amenities_Utilities";
        break;
      case etableName.AdditionalOccupants:
        name = "AdditionalOccupants";
        break;
      case etableName.SystemEnumDetails:
        name = "TABMD_SystemEnumDetails";
        break;
      case etableName.AdditionalReferences:
        name = "AdditionalReferences";
        break;
      case etableName.Applicant:
        name = "Applicant";
        break;
      case etableName.Application:
        name = "Application";
        break;
      case etableName.ApplicationDocument:
        name = "ApplicationDocument";
        break;
      case etableName.Attachments:
        name = "Attachments";
        break;
      case etableName.Occupation:
        name = "Occupation";
        break;
      case etableName.CurrentTenancy:
        name = "CurrentTenancy";
        break;
      case etableName.Employment:
        name = "Employment";
        break;
      case etableName.Person:
        name = "Person";
        break;
      case etableName.PetInfo:
        name = "PetInfo";
        break;
      case etableName.PropertyDocument:
        name = "PropertyDocument";
        break;
      case etableName.ReferenceAnswers:
        name = "ReferenceAnswers";
        break;
      case etableName.VehicleInfo:
        name = "VehicleInfo";
        break;
      case etableName.AspNetUsers:
        name = "AspNetUsers";
        break;
      case etableName.MediaInfo:
        name = "MediaInfo";
        break;
      case etableName.Notification:
        name = "Notification";
        break;
      case etableName.PropertyImages:
        name = "PropertyImages";
        break;
      case etableName.Website_under_Maintenance:
        name = "Website_under_Maintenance";
        break;
      case etableName.Maintenance:
        name = "Maintenance";
        break;
      case etableName.MaintenanceVendor:
        name = "MaintenanceVendor";
        break;
      case etableName.LogActivities:
        name = "LogActivities";
        break;
      case etableName.PropertyMaintenanceImages:
        name = "PropertyMaintenanceImages";
        break;
      case etableName.Vendor:
        name = "Vendor";
        break;
      case etableName.Events_type:
        name = "Events_type";
        break;
      case etableName.Events_type_templates:
        name = "Events_type_template";
        break;
      case etableName.Availability:
        name = "availability";
        break;
      case etableName.AvailabilityTime:
        name = "availability_time";
        break;
      case etableName.Slots:
        name = "slots";
        break;
      case etableName.availability_overrides:
        name = "availability_overrides";
        break;
      case etableName.AvailabilityTemplate:
        name = "availability_template";
        break;
      case etableName.AvailabilityTimeTemplate:
        name = "availability_time_template";
        break;
      case etableName.availability_overridesTemplate:
        name = "availability_overrides_template";
        break;
      case etableName.request_documents:
        name = "requestdocuments";
        break;
      case etableName.list_documents:
        name = "listdocuments";
        break;
      case etableName.documentsfields:
        name = "documentsfields";
        break;
      case etableName.htmlRequest:
        name = "applicationsendhtml";
        break;
      default:
        name = "";
    }
    return name;
  }
}
