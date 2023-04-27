import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/components/chat_item.dart';
import 'package:mobile/models/chat.dart';
import 'package:mobile/providers/chat_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import '../components/textbox_input.dart';
import '../models/user.dart';
import '../utils/constant.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatProvider _chatProvider = Get.put(ChatProvider());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final UserProvider _userProvider = Get.find();

  late final String _appointmentId;
  late final String _chatSessionId;
  late final String _receiverId;
  late User user;

  List<Chat> _messages = [];
  bool _isLoading = true;
  String? _isLocked;

  @override
  void initState() {
    init();
    _chatProvider.hub.start();
    _chatProvider.hub.on("ReceiveMessage", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final chat = Chat.fromJson(arguments.first as Map<String, dynamic>);
        setState(() {
          _messages.add(chat);
        });
      }
    });
    _userProvider.getUserInfo().then((value) => user = value!);
    super.initState();
  }

  init() async {
    _appointmentId = Get.parameters["appointmentId"]!;
    _receiverId = Get.parameters["doctorId"]!;
    _isLocked = Get.parameters["isLocked"];
    try {
      final chatSession = await _chatProvider.getSession(_appointmentId);
      _messages = chatSession.chats ?? [];
      _chatSessionId = chatSession.id!;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _chatProvider.hub.stop();
    super.dispose();
  }

  void onSend() async {
    final message = _messageController.text;
    if (message.isEmpty) return;
    setState(() {
      _messageController.text = '';
    });
    final request = Chat(message: message, chatSessionId: _chatSessionId, receiverId: _receiverId, senderId: user.id);
    await _chatProvider.hub.invoke("SendMessage", args: <Object>[request]);
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: kPaddingContainer, right: kPaddingContainer),
          child: Text("Chat"),
        ),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      controller: _scrollController,
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (_, i) => ChatItem(
                        content: _messages.elementAt(i).message ?? "",
                        isOwner: _messages.elementAt(i).senderId == user.id,
                      ),
                    ),
            ),
            const SizedBox(height: 100)
          ],
        ),
      ),
      bottomSheet: _isLocked == null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 5, right: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          height: 50,
                          child: TextboxInput(
                            controller: _messageController,
                            hintText: "Message...",
                          )),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.paperPlane),
                      onPressed: onSend,
                    )
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
