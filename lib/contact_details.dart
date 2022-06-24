import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({Key? key}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  List<Contact>? _contacts ;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _getPhoneData();
  }

  Future _getPhoneData() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else{
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true) ;
      setState(()=> _contacts =  contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_permissionDenied) return const Center(child: Text("Permission denied"));
    if(_contacts == null) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text("${_contacts![index].name.first} ${_contacts![index].name.last}"));
              });
  }
}
