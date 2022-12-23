import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/actions/customer/customer_portal_action.dart';
import 'package:silverhome/domain/actions/customer/customer_property_details_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/customer/customer_propertylist_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/customer/customer_property_card.dart';
import 'package:silverhome/widget/customer/responsive_grid.dart';

class CustomerPropertyListPageTest extends StatefulWidget {
  @override
  _CustomerPropertyListPageTestState createState() => _CustomerPropertyListPageTestState();
}

class _CustomerPropertyListPageTestState extends State<CustomerPropertyListPageTest> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      width: width,
      height: height - 170,
      padding: EdgeInsets.only(left: 80, right: 80),
      child: ConnectState<CustomerPropertylistState>(
        map: (state) => state.customerPropertylistState,
        where: notIdentical,
        builder: (cusProlistState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                child: Text(
                  GlobleString.CSM_FeaturedListings,
                  style: MyStyles.SemiBold(24, myColor.CM_footer_powerby),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(cusProlistState!.propertylist.length.toString()),
              new Expanded(
                child: ResponsiveGridList(
                    desiredItemWidth: 300,
                    minSpacing: 1,
                    children: Helper.Widgetchild(cusProlistState!.propertylist.length).map((i) {
                      return CSM_PropertyCard(
                        callbackOnItem: () {
                          getFeaturePropertyDetails(cusProlistState.propertylist[i], cusProlistState);
                          //_store.dispatch(UpdateCustomerPortal_pageindex(1));
                        },
                        propertyData: cusProlistState.propertylist[i],
                        pos: i,
                        cdwidth: 0,
                      );
                    }).toList()),
              ),
            ],
          );
        },
      ),
    ));
  }

  getFeaturePropertyDetails(PropertyData propertyval, CustomerPropertylistState cusProlistState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String propId = propertyval.ID.toString();

    await ApiManager().getPropertyRestriction_Customer(context, propId, (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateCPDRestrictionlist(restrictionlist));
      } else {
        _store.dispatch(UpdateCPDRestrictionlist([]));
      }
    });

    await ApiManager().getPropertyImagesDSQ(context, propId, (status, responce, PropertyImageMediaInfolist) {
      if (status) {
        _store.dispatch(UpdateCPDPropertyImageList(PropertyImageMediaInfolist));
      } else {
        _store.dispatch(UpdateCPDPropertyImageList([]));
      }
    });

    await ApiManager().getPropertyAmanityUtility(context, propId, (status, responce, amenitieslist, utilitylist) async {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        List<PropertyAmenitiesUtility> new_amenitieslist = <PropertyAmenitiesUtility>[];

        List<PropertyAmenitiesUtility> new_utilitylist = <PropertyAmenitiesUtility>[];

        List<PropertyAmenitiesUtility> new_notincludedutilitylist = <PropertyAmenitiesUtility>[];

        for (PropertyAmenitiesUtility proam in amenitieslist) {
          if (proam.value == "1") {
            new_amenitieslist.add(proam);
          }
        }

        for (PropertyAmenitiesUtility proam1 in utilitylist) {
          if (proam1.value == "1") {
            new_utilitylist.add(proam1);
          }
        }

        for (PropertyAmenitiesUtility proam2 in utilitylist) {
          if (proam2.value == "2") {
            new_notincludedutilitylist.add(proam2);
          }
        }

        _store.dispatch(UpdateCPDPropertyAmenitiesList(new_amenitieslist));
        _store.dispatch(UpdateCPDPropertyUtilitiesList(new_utilitylist));
        _store.dispatch(UpdateCPDPropertyNotIncludedUtilitiesList(new_notincludedutilitylist));
      } else {
        _store.dispatch(UpdateCPDPropertyAmenitiesList([]));
        _store.dispatch(UpdateCPDPropertyUtilitiesList([]));
        _store.dispatch(UpdateCPDPropertyNotIncludedUtilitiesList([]));
        await ApiManager().getPropertyFeaturelist(context);
      }
    });

    await ApiManager().getPropertyDetails(context, propId, (status, responce, propertyData) async {
      if (status) {
        _store.dispatch(UpdateCPDpropertylist(cusProlistState.propertylist));
        await ApiManager().Customer_bindPropertyData(propertyData!);
        _store.dispatch(UpdateCustomerPortal_pageindex(1));

        loader.remove();
      } else {
        loader.remove();
      }
    });
  }
}
