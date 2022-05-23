import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

part 'tenantsfilter_state.freezed.dart';

@freezed
class TenantFilterState with _$TenantFilterState {
  const factory TenantFilterState({
    required List<FilterPropertyItem> properties,
    required List<FilterCityItem> cities,
    required List<FilterRatingItem> ratinglist,
    required List<FilterApplicationReceived> applicationreceivelist,
    required List<SystemEnumDetails> statuslist,
    required List<SystemEnumDetails> employmentstatuslist,
    required List<SystemEnumDetails> annualincomelist,
    required List<FilterNumberOfOccupants> numberoccupationlist,
    required List<FilterPets> petslist,
    required List<FilterSmoking> smokinglist,
    required List<FilterVehical> vehicallist,
    required bool isExpandProperties,
    required bool isExpandCity,
    required bool isExpandRating,
    required bool isExpandApplicationReceived,
    required bool isExpandStatus,
    required bool isExpandEmploymentStatus,
    required bool isExpandAnnualincome,
    required bool isExpandNumberOfOccupation,
    required bool isExpandPets,
    required bool isExpandSmoking,
    required bool isExpandVehical,
    required bool IsApplyFilter,
  }) = _TenantFilterState;

  factory TenantFilterState.initial() => TenantFilterState(
        properties: List.empty(),
        cities: List.empty(),
        ratinglist: List.empty(),
        applicationreceivelist: List.empty(),
        statuslist: List.empty(),
        employmentstatuslist: List.empty(),
        annualincomelist: List.empty(),
        numberoccupationlist: List.empty(),
        petslist: List.empty(),
        smokinglist: List.empty(),
        vehicallist: List.empty(),
        isExpandProperties: false,
        isExpandCity: false,
        isExpandRating: false,
        isExpandApplicationReceived: false,
        isExpandStatus: false,
        isExpandEmploymentStatus: false,
        isExpandAnnualincome: false,
        isExpandNumberOfOccupation: false,
        isExpandPets: false,
        isExpandSmoking: false,
        isExpandVehical: false,
        IsApplyFilter: false,
      );
}
