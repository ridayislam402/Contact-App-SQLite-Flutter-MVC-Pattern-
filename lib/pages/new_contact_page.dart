import 'dart:io';

import 'package:contect_app_flutter/model/contact_model.dart';
import 'package:contect_app_flutter/providers/contact_provider.dart';
import 'package:contect_app_flutter/util/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewContactPage extends StatefulWidget {
  static final routeName = '/new_contact';

  const NewContactPage({Key? key}) : super(key: key);

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  String? dob;
  String? imagePath;
  ImageSource source = ImageSource.camera;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Contact'), actions: [
        IconButton(onPressed: _sevedContact, icon: Icon(Icons.save))
      ]),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        children: [
          Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        elevation: 5,
                        child: imagePath == null
                            ? Icon(
                          Icons.person,
                          size: 70,
                        )
                            : Image.file(File(imagePath!), fit: BoxFit.cover),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                source = ImageSource.camera;
                                _getImage();
                              },
                              icon: Icon(Icons.camera),
                              label: Text('Camera')),
                          TextButton.icon(
                              onPressed: () {
                                source = ImageSource.gallery;
                                _getImage();
                              },
                              icon: Icon(Icons.image),
                              label: Text('Gallery')),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(14.0)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This fild no be empty';
                      }
                      if (value.length > 20) {
                        return 'Name should be less then 10 char';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileController,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Mobile number',
                        prefixIcon: Icon(Icons.call),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(14.0)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field no be empty';
                      }else if (value.length == 11 || value.length == 14) {
                        return null;
                      }else{
                        return 'invalid number';
                      }

                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(14.0)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        filled: true,
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(14.0)))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: _showCalander,
                            icon: Icon(Icons.calendar_month),
                            label: Text('Show Date'),
                          ),
                          Text(dob == null ? 'No Date Chosen' : dob!)
                        ],
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  _sevedContact() {
    if (formKey.currentState!.validate()) {
      final contact = ContactModel(
          name: _nameController.text,
          mobile: _mobileController.text,
          email: _emailController.text,
          streetAddress: _addressController.text,
          dob: dob,
          image: imagePath,
      );
      Provider
          .of<ContactProvider>(context, listen: false)
          .insert(contact).then((id){
            contact.id = id;
            Provider.of<ContactProvider>(context, listen: false).updateList(contact);
          Navigator.pop(context);
      }).catchError((error) {
        print(error.toString());
        showMsg(context, 'Faild to Save');
      });
    }
  }

  void _showCalander() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dateTime != null) {
      setState(
            () {
          dob = getFormatedDate(dateTime, 'dd/MM/yyyy');
        },
      );
    }
  }

  void _getImage() async {
    final xfile = await ImagePicker().pickImage(source: source);
    if (xfile != null) {
      setState(
            () {
          imagePath = xfile.path;
          print(imagePath);
        },
      );
    }
  }
}
