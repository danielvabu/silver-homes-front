import 'package:flutter/material.dart';

var darkBlue = const Color.fromARGB(255, 0, 15, 43);
var clearBlue = const Color.fromARGB(255, 223, 230, 249);

class RoleSelectionDialog extends StatefulWidget {
  RoleSelectionDialog({Key? key}) : super(key: key);

  @override
  State<RoleSelectionDialog> createState() => _RoleSelectionDialogState();
}

class _RoleSelectionDialogState extends State<RoleSelectionDialog> {
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
              "There are Team Members assigned to the Property Manager role.",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: const [
              Text(
                "Please assign a different role for the following team members:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          addNewRoleButtonRow(),
          const SizedBox(
            height: 15,
          ),
          table(),
          const SizedBox(
            height: 20,
          ),
          buttonRow(),
        ],
      ),
    ));
  }

  Row addNewRoleButtonRow() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(5)),
          child: SizedBox(
            height: 40,
            width: 150,
            child: TextButton(
              onPressed: () {},
              child: SizedBox.expand(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Add New Role",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
            ),
          ),
        )
      ],
    );
  }

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

  Column table() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: clearBlue,
          child: SizedBox(
            height: 40,
            child: Row(children: const [
              SizedBox(width: 20),
              Expanded(
                  child: Text(
                "Team Member",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
              Expanded(flex: 2, child: Text("Role", style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 100)
            ]),
          ),
        ),
        SizedBox(
          height: 50,
          child: teamMemberRow("Harry Potter"),
        ),
        Container(
          color: Colors.grey[200],
          child: SizedBox(
            height: 50,
            child: teamMemberRow("Jill Jones"),
          ),
        ),
      ],
    );
  }

  Row teamMemberRow(String name) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(child: Text(name)),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: DropdownButtonFormField(
                dropdownColor: Colors.white,
                focusColor: Colors.white,
                decoration: const InputDecoration(
                    label: Text("Select Role"),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 15)),
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(
                      "Administrator",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(
                      "Manager",
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                ],
                onChanged: (value) {}),
          ),
        ),
        const SizedBox(width: 100)
      ],
    );
  }
}
