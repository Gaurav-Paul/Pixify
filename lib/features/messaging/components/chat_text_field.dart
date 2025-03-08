import 'package:flutter/material.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/chat_service.dart';

class ChatTextField extends StatefulWidget {
  final String recieverUID;
  final ScrollController scrollController;
  const ChatTextField({
    super.key,
    required this.recieverUID,
    required this.scrollController,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool isExtended = true;
  bool loading = false;
  final TextEditingController chatTextController = TextEditingController();

  @override
  void initState() {
    
    super.initState();
    widget.scrollController.animateTo(
      1000000,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  sendMessage() async {
    if (chatTextController.text.isEmpty ||
        chatTextController.text.trim().isEmpty) {
      return;
    }

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    await ChatService().sendMessage(
      context: context,
      textMessage: chatTextController.text,
      receiverUserUid: widget.recieverUID,
      senderUserUid: AuthService.auth.currentUser!.uid,
    );

    await widget.scrollController.animateTo(
      1000000,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );

    chatTextController.clear();

    if (mounted) {
      setState(() {
        isExtended = true;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      shape: const StadiumBorder(),
      color: Colors.amber,
      child: loading
          ? Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(100),
              ),
              height: 60,
              child: const Center(
                child: Text(
                  "Sending Message Please Wait...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                  ),
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    width: isExtended
                        ? MediaQuery.of(context).size.width - 30
                        : 300,
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black,
                    ),
                    child: TextField(
                      controller: chatTextController,
                      onChanged: (value) {
                        if (value.trim().isEmpty) {
                          if (mounted) {
                            setState(() {
                              isExtended = true;
                            });
                          }
                          return;
                        }
                        if (value.isNotEmpty) {
                          if (mounted) {
                            setState(() {
                              isExtended = false;
                            });
                          }
                        } else {
                          if (mounted) {
                            setState(() {
                              isExtended = true;
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your message here...",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                  ),
                  !isExtended
                      ? FloatingActionButton(
                          onPressed: sendMessage,
                          shape: const CircleBorder(),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.amber,
                          child: const Icon(Icons.send),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
    );
  }
}
