import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

var darkBlue = const Color.fromARGB(255, 0, 15, 43);
var clearBlue = const Color.fromARGB(255, 223, 230, 249);

class EditRoleSelectionDialog extends StatefulWidget {
  EditRoleSelectionDialog({Key? key}) : super(key: key);

  @override
  State<EditRoleSelectionDialog> createState() => _EditRoleSelectionDialogState();
}

class _EditRoleSelectionDialogState extends State<EditRoleSelectionDialog> {
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
              "Edit Team Member",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(
            height: 15,
          ),
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
        Row(
          children: [
            Flexible(
                child: SizedBox(
              child: teamMemberRow("First name"),
            )),
            SizedBox(
              width: 10.sp,
            ),
            Flexible(
                child: SizedBox(
              child: teamMemberRow("Last Name"),
            )),
          ],
        ),
        Row(
          children: [
            Flexible(
                child: SizedBox(
              child: teamMemberRow("Email"),
            )),
            SizedBox(
              width: 10.sp,
            ),
            Flexible(
                child: SizedBox(
              child: teamMemberRow("Role"),
            )),
          ],
        ),
      ],
    );
  }

  Column teamMemberRow(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.toString(),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Padding(
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
      ],
    );
  }
}
