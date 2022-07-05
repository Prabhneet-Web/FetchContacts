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
  List<Contact>? _contactFiltered;
  bool _permissionDenied = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getPhoneData();
    _searchController.addListener(() {
      _filterContacts();
    });
  }

  _filterContacts() {
    List<Contact>? contacts = [];
    contacts.addAll(_contacts!);
    if (_searchController.text.isNotEmpty) {
      contacts.retainWhere((contact) {
        String searchTerm = _searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) return true;

        // var phone = contact.phones.first.number.firstWhere((element) {
        //   return element.value.contains(searchTerm);
        // }, orElse: () => null
        // );

        // return phone != null;
        return false;
      });
      setState(() => _contactFiltered = contacts);
    }
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
    bool isSearching = _searchController.text.isNotEmpty;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
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
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.045),
              child: Text(
                "All Contacts",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.02,
                    fontFamily: 'AzoSans'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.042,
                  left: width * 0.04,
                  right: width * 0.04),
              child: Container(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide()),
                        labelText: "Search Contacts",
                        labelStyle: TextStyle(
                            fontFamily: 'AzoSansMedium',
                            fontSize: height * 0.017),
                        suffixIcon: Icon(Icons.search)

                    ),
                  )),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: isSearching == true
                      ? _contactFiltered!.length
                      : _contacts!.length,
                  itemBuilder: (context, index) {
                    Contact contact = isSearching == true
                        ? _contactFiltered![index]
                        : _contacts![index];
                    return Column(
                      children: [
                        ListTile(
                          leading: (contact.photo != null &&
                              contact.photo!.isNotEmpty)
                              ? CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                          )
                              : const CircleAvatar(
                            backgroundImage:
                            AssetImage("lib/DefaultAvatar.jpeg"),
                          ),
                          title: Text(
                            contact.displayName,
                            style: TextStyle(
                                fontFamily: 'AzoSansMedium',
                                fontSize: height * 0.017),
                          ),
                          subtitle: Text(
                              contact.phones.isNotEmpty
                                  ? _contacts![index].phones.first.number
                                  : "",
                              style: TextStyle(
                                  fontFamily: "AzoSansRegular",
                                  color: Colors.black,
                                  fontSize: height * 0.017)),
                        ),
                        const Divider(height: 8)
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
