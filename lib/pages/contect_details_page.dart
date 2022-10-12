import 'dart:io';

import 'package:contect_app_flutter/model/contact_model.dart';
import 'package:contect_app_flutter/providers/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../util/helper_function.dart';

class ContactDetailsPage extends StatefulWidget {
  static final routeName = '/contact_details';

  const ContactDetailsPage({Key? key}) : super(key: key);

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final id = argList[0];
    final name = argList[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) => FutureBuilder<ContactModel>(
          future: provider.getById(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final contact = snapshot.data!;

              return ListView(
                children: [
                  SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: contact.image != null
                          ? Image.file(
                              File(contact.image!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            )
                          : Icon(Icons.person)),
                  ListTile(
                    title: Text(contact.mobile),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {
                          _callMethod(contact.mobile);
                        }, icon: Icon(Icons.call)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.message)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.email!.isEmpty
                        ? 'Email not set yet'
                        : contact.email!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (contact.email!.isNotEmpty)
                          IconButton(onPressed: () {

                          }, icon: Icon(Icons.email)),
                        IconButton(onPressed: () {
                          showUpdateDialog(
                            context: context,
                            title: 'Email : ${contact.email}',
                            onSave: (value)async {
                              await provider.updateById(id, tblContactColEmail, value);
                              setState(() {

                              });

                            },
                          );
                        }, icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(contact.streetAddress!.isEmpty
                        ? 'Email not set yet'
                        : contact.streetAddress!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (contact.streetAddress!.isNotEmpty)
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.location_on_outlined)),
                        IconButton(
                            onPressed: () {
                              showUpdateDialog(
                                context: context,
                                title: 'Address : ${contact.streetAddress}',
                                onSave: (value)async {
                                  await provider.updateById(id, tblContactColAddress, value);
                                  setState(() {

                                  });

                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                      ],
                    ),
                  )
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to fatch data'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _callMethod(String mobile) async{
    final url ='tel:$mobile';
    if(await canLaunchUrlString(url)){
      await launchUrlString(url);
    }else{
      showMsg(context, 'cannot perform');
    }
  }
}
