import 'package:flutter/material.dart';

class RoleTable extends StatefulWidget {
  RoleTable({Key? key}) : super(key: key);

  @override
  State<RoleTable> createState() => _RoleTableState();
}

class _RoleTableState extends State<RoleTable> {
  var titleMargin = 10.0;
  var checkValue = false;
  List<bool> viewArray = [false, false, false, false, false, false, false, false];
  List<bool> editArray = [false, false, false, false, false, false, false, false];
  List<bool> platformArray = [false, false, false, false, false, false, false, false];
  List<bool> emailArray = [false, false, false, false, false, false, false, false];
  List<bool> smsArray = [false, false, false, false, false, false, false, false];
  late List<List<bool>> matrix;
  var view = false;
  var edit = false;

  @override
  void initState() {
    matrix = [viewArray, editArray, platformArray, emailArray, smsArray];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title(),
              const SizedBox(
                height: 15,
              ),
              roleField(),
              Expanded(
                child: body(),
              ),
            ],
          ),
        ), /*  customRoleTable() */
      ),
    );
  }

  Column body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
            height: 50,
            //width:400,
            child: TabBar(
                indicatorWeight: 4,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: "Assigned Properties",
                    /* child: Text("Assigned Properties",style: TextStyle(color: Colors.black), )*/
                  ),
                  Tab(
                    text: "Unassigned Properties",
                    /* child: Text("Unassigned Properties",style: TextStyle(color: Colors.black), )*/
                  )
                ])),
        const SizedBox(height: 15),
        Flexible(
          //height:500,
          child: TabBarView(
            children: [
              customRoleTable() /* Text("HOLA") */,
              customRoleTable() /* const Text("HOLA") */
            ],
          ),
        ),
      ],
    );
  }

  Column roleField() {
    return Column(
      children: [
        Row(
          children: [
            const Text("Role Name"),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            height: 30,
            child: TextFormField(
              decoration: const InputDecoration(enabledBorder: OutlineInputBorder()),
            )),
      ],
    );
  }

  Row title() {
    return Row(
      children: const [
        Text(
          "New Role",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  Widget customRoleTable() {
    return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            titleRow(),
            Expanded(child: dTableRow("Properties", 1)),
            Expanded(
              child: dTableRow("Tenants", 2),
            ),
            Expanded(
              child: dTableRow("Maintenance", 3),
            ),
            Expanded(
              child: dTableRow("Payments", 4),
            ),
            Expanded(
              child: dTableRow("Documents", 5),
            ),
            Expanded(
              child: dTableRow("Tasks", 6),
            ),
            Expanded(
              child: dTableRow("Team Management", 7),
            ),

            /*  dTableRow("Tenants"),
            dTableRow("Maintenance"),
            dTableRow("Payments"),
            dTableRow("Documents"),
            dTableRow("Tasks"),
            dTableRow("Team Management") */
          ],
        ));
  }

  dTableRow(String rowTitle, int index) {
    return tRow([
      Expanded(
        flex: 4,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              Text(
                rowTitle,
              ),
            ],
          ),
        ),
      ),
      Expanded(flex: 3, child: customCheckBox(0, index)),
      Expanded(flex: 3, child: customCheckBox(1, index)),
      Expanded(
        flex: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                customCheckBox(2, index),
                const Text("Platform"),
              ],
            ),
            Row(
              children: [
                customCheckBox(3, index),
                const Text("Email"),
              ],
            ),
            Row(
              children: [
                customCheckBox(4, index),
                const Text("SMS"),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Checkbox customCheckBox(int col, int row) {
    return Checkbox(
        side: MaterialStateBorderSide.resolveWith((set) => const BorderSide(color: Colors.black, width: 1)),
        shape: checkShape(),
        fillColor: const MaterialStatePropertyAll(Colors.white),
        checkColor: Colors.black,
        value: matrix[col][row],
        onChanged: (value) {
          setState(() {
            if (row == 0) {
              for (int i = 0; i < matrix[col].length; i++) {
                matrix[col][i] = value ?? false;
              }
            } else
              matrix[col][row] = value ?? false;
          });
        });
  }

  RoundedRectangleBorder checkShape() => RoundedRectangleBorder(side: const BorderSide(), borderRadius: BorderRadius.circular(3));

  tRow(List<Widget> cells) {
    List<Widget> finalWidgets = [];

    for (var cell in cells) {
      finalWidgets.add(cell);

      finalWidgets.add(const VerticalDivider(
        color: Colors.black,
        width: 1,
        thickness: 1,
      ));
    }

    finalWidgets.removeLast();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: finalWidgets,
      ),
    );
  }

  titleRow() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tRow([
          const Spacer(flex: 4),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    height: titleMargin,
                  ),
                  const Text(
                    "View",
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    height: titleMargin,
                  ),
                  const Text(
                    "Edit",
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          Expanded(
              flex: 6,
              child: Column(
                children: [
                  SizedBox(
                    height: titleMargin,
                  ),
                  const Text(
                    "Notifications",
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ]),
        dTableRow("", 0),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.black,
        )
      ],
    );
  }
}
