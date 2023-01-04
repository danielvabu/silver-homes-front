import 'package:flutter/material.dart';

var darkBlue = const Color.fromARGB(255, 0, 15, 43);
var clearBlue = const Color.fromARGB(255, 223, 230, 249);

class EditAsignment extends StatefulWidget {
  EditAsignment({Key? key}) : super(key: key);

  @override
  State<EditAsignment> createState() => _EditAsignmentState();
}

class _EditAsignmentState extends State<EditAsignment> {
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
              "Edit Assignment",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(
            height: 15,
          ),
          content(),
          const SizedBox(
            height: 20,
          ),
          buttonRow(),
        ],
      ),
    ));
  }

  Widget content() => SizedBox(
        height: 400,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Selected Properties",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: table2([
                    ListTile(
                      title: Text("Main Tower - Unit 201"),
                      trailing: deleteIcon(),
                    ),
                    ListTile(
                      title: Text("Main Tower - Unit 201"),
                      trailing: deleteIcon(),
                    ),
                    ListTile(
                      title: Text("Main Tower - Unit 201"),
                      trailing: deleteIcon(),
                    ),
                  ]))
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(child: assignationTable())
          ],
        ),
      );

  Row buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white, border: Border.all(color: darkBlue)),
          child: SizedBox(
            height: 35,
            width: 100,
            child: TextButton(
              onPressed: () {},
              child: SizedBox.expand(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Cancel",
                    style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
                  )
                ],
              )),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
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
                    "Save",
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

  assignationTable() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Text(
              "Assign to",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        DropdownButtonFormField(
            dropdownColor: Colors.white,
            focusColor: Colors.white,
            decoration: const InputDecoration(
                label: Text("Search People"),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 15)),
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text(
                  "Alex Cabarcas",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text(
                  "Luis Campos",
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
            onChanged: (value) {}),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "Selected People",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
            child: table2([
          ListTile(
            title: Row(
              children: [
                Text("Katherine Jill"),
                SizedBox(
                  width: 5,
                ),
                Text("|"),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "SALES REPRESENTATIVE",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            trailing: deleteIcon(),
          )
        ]))
      ],
    );
  }

  table2(List<Widget> content) {
    return Container(
      //color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey,
              )),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: content,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Image deleteIcon() => Image.asset(
        "assets/ic_delete.png",
        height: 18,
      );
}
