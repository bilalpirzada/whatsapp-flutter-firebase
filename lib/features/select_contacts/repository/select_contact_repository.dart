//1. create class selectContactrepository
//create necessary global variables such as final firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/features/chat/screens/mobile_chat_screen.dart';

//providing repository
final selectContactrepositoryProvider =
    Provider((ref) => SelectContactrepository(FirebaseFirestore.instance));

class SelectContactrepository {
  final FirebaseFirestore firestore;

  SelectContactrepository(this.firestore);

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
 

    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }


    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection("users").get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        //converting the data into userModel
        var userData = UserModel.fromMap(document.data());

        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            "name": userData.name,
            "uid": userData.uid,
          });
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content:
                'This number ${selectedContact.phones[0].number} doesn\'t exist on this app');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

//---------------
  Future<bool> isContactExist(Contact selectedContact) async {
    bool isFound = false;
    try {
      var userCollection = await firestore.collection("users").get();

      for (var document in userCollection.docs) {
        //converting the data into userModel
        var userData = UserModel.fromMap(document.data());
        for (int i = 0; i < selectedContact.phones.length; i++) {
          String selectedPhoneNum =
              selectedContact.phones[i].number.replaceAll(' ', '');
          if (selectedPhoneNum == userData.phoneNumber) {
            isFound = true;
          }
        }
      }
    } catch (e) {}
    return isFound;
  }
}
