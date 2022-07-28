import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repositories/chat_repository.dart';


final chatControllerProvider = Provider(
    (ref){
      final chatRepository= ref.watch(chatRepositoryProvider);
      return ChatController(chatRepository, ref);
    });


class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController(this.chatRepository, this.ref);

  void sentTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!));
  }
}
