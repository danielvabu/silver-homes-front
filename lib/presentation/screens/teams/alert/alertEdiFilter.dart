import 'package:flutter/material.dart';

var darkBlue = const Color.fromARGB(255, 0, 15, 43);
var clearBlue = const Color.fromARGB(255, 223, 230, 249);

class FilterScreen extends StatefulWidget {
  FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late List<List<bool>> matrix;
  @override
  void initState() {
    matrix = [
      [false, false],
      [false, false]
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(children: const [
            Text(
              "Filter",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(
            height: 15,
          ),
          content(),
          Spacer(),
          buttonRow(),
        ],
      ),
    ));
  }

  Widget content() => SizedBox(
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            filterTitle("Property"),
            const SizedBox(
              height: 9,
            ),
            dropDown("Select Property", [
              DropdownMenuItem(
                value: 0,
                child: Row(
                  children: [
                    customCheckBox2(1, 0),
                    const Text(
                      "Brentwood - Unit 10 - 867 Hamilton Road",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 1,
                child: Row(
                  children: [
                    customCheckBox2(1, 1),
                    const Text(
                      "Brentwood - Unit 10 - 867 Hamilton Road",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(
              height: 15,
            ),
            filterTitle("Building Name"),
            const SizedBox(
              height: 9,
            ),
            dropDown("Select Building Name", const []),
            const SizedBox(
              height: 15,
            ),
            filterTitle("City"),
            const SizedBox(
              height: 9,
            ),
            dropDown("Select City", const []),
            const SizedBox(
              height: 15,
            ),
            filterTitle("Assignment"),
            SizedBox(
              height: 9,
            ),
            Row(
              children: [
                customCheckBox(0, 0),
                SizedBox(width: 5),
                const Text(
                  "Assigned",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(children: [
              customCheckBox(0, 1),
              SizedBox(width: 5),
              const Text("Unassigned", style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          ],
        ),
      );

  DropdownButtonFormField<int> dropDown(String title, List<DropdownMenuItem<int>> list) {
    return DropdownButtonFormField<int>(
        dropdownColor: Colors.white,
        focusColor: Colors.white,
        decoration: InputDecoration(
            label: Text(title),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 15)),
        items: list,
        onChanged: (value) {
          setState(() {
            if (value != null) {
              matrix[1][value] = !(matrix[1][value]);
            }
          });
        });
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
            matrix[col][row] = value ?? false;
          });
        });
  }

  Checkbox customCheckBox2(int col, int row) {
    return Checkbox(
        side: MaterialStateBorderSide.resolveWith((set) => const BorderSide(color: Colors.black, width: 1)),
        shape: checkShape(),
        fillColor: const MaterialStatePropertyAll(Colors.white),
        checkColor: Colors.black,
        value: matrix[col][row],
        onChanged:
            null /* (value) {
          setState(() {
           
              matrix[col][row] = value ?? false;}
          );
        } */
        );
  }

  RoundedRectangleBorder checkShape() => RoundedRectangleBorder(side: const BorderSide(), borderRadius: BorderRadius.circular(3));
  Container filterTitle(String text) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  Row buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: () {}, child: const Text("Clear all", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: darkBlue,
          ),
          child: SizedBox(
            height: 35,
            width: 100,
            child: TextButton(
              onPressed: () {},
              child: SizedBox.expand(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Apply",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                  )
                ],
              )),
            ),
          ),
        )
      ],
    );
  }
}
