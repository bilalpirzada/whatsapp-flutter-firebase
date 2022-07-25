import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';

final selectContactControllerProvider = Provider((ref) {
  final selectContactrepository = ref.watch(selectContactrepositoryProvider);
  return SelectContactController(ref, selectContactrepository);
});

final getContactsProvider = FutureProvider((ref) {
  final selectContactrepository = ref.watch(selectContactrepositoryProvider);
  return selectContactrepository.getContacts();
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactrepository selectContactrepository;

  SelectContactController(this.ref, this.selectContactrepository);

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactrepository.selectContact(selectedContact, context);
  }
}
