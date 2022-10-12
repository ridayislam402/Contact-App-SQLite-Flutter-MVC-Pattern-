import 'dart:io';

import 'package:contect_app_flutter/providers/contact_provider.dart';
import 'package:flutter/material.dart';

import '../model/contact_model.dart';
import '../pages/contect_details_page.dart';

class ContactItem extends StatefulWidget {
  final ContactModel contact;
 final ContactProvider provider;
  const ContactItem({Key? key, required this.contact, required this.provider}) : super(key: key);

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white,),
      ),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) {
        return showDialog(barrierDismissible: false, context: context, builder: (context) =>
            AlertDialog(
              title: Text('Delete'),
              content: Text('Are You Sure'),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context, false);
                }, child: Text('Cancel')),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context, true);
                }, child: Text('Yes'))
              ],

            ),);
      },
      onDismissed: (direction) {
        widget.provider.deleteById(widget.contact.id);
      },
      child: ListTile(
        onTap: () => Navigator.pushNamed(
            context,
            ContactDetailsPage.routeName,
            arguments: [widget.contact.id, widget.contact.name]
        ),
        leading: widget.contact.image != null?
        Card( shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),

            elevation: 5,child: Image.file(File(widget.contact.image!))):
        Icon(Icons.person),
        title: Text(widget.contact.name),
        trailing: IconButton(
            onPressed: () async{
              final value = widget.contact.favorate? 0 : 1;
             await widget.provider.updateById(widget.contact.id, tblContactColFavorate, value);
             widget.contact.favorate = !widget.contact.favorate;

              setState(() {

              });
            },
            icon: Icon(widget.contact.favorate
                ? Icons.favorite
                : Icons.favorite_border)),

      ),
    );
  }
}
