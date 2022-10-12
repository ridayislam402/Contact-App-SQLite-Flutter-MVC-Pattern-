import 'dart:io';

import 'package:contect_app_flutter/customwidgets/contact_item.dart';
import 'package:contect_app_flutter/model/contact_model.dart';
import 'package:contect_app_flutter/pages/contect_details_page.dart';
import 'package:contect_app_flutter/pages/new_contact_page.dart';
import 'package:contect_app_flutter/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactHomePage extends StatelessWidget {
  static final routeName = '/';

  const ContactHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ContactProvider>(context, listen: false).getAll();
    return Scaffold(
      appBar: AppBar(title: Text('Contact Home')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewContactPage.routeName),
        child: Icon(Icons.add),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => provider.contactList.isEmpty
            ? const Center(
                child: Text('No Contact Found'),
              )
            : ListView.builder(
                itemCount: provider.contactList.length,
                itemBuilder: (context, index) {
                  final contact = provider.contactList[index];
                  return ContactItem(contact : contact,provider : provider);
                },
              ),
      ),
    );
  }
}
