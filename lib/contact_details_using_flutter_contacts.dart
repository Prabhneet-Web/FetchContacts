import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactDetailsUsingFlutterContacts extends StatefulWidget {
  const ContactDetailsUsingFlutterContacts({Key? key}) : super(key: key);

  @override
  State<ContactDetailsUsingFlutterContacts> createState() =>
      _ContactDetailsStateUsingFlutterContacts();
}

class _ContactDetailsStateUsingFlutterContacts
    extends State<ContactDetailsUsingFlutterContacts> {
  List<Contact>? _contacts;

  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _getPhoneData();
  }

  Future _getPhoneData() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (_permissionDenied) {
      return const Center(child: Text("Permission denied"));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(width * 0.042),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Text(
                "All Contacts",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.02,
                    fontFamily: 'AzoSans'),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _contacts!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_contacts![index].displayName),
                    subtitle: Text(_contacts![index].phones.isNotEmpty? _contacts![index].phones.first.number: ""),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
