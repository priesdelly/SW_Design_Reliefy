import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/models/chat_session.dart';
import 'package:mobile/providers/http_provider.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../utils/constant.dart';

class ChatProvider extends HttpProvider {
  final wsUrl = Uri.parse('wss://localhost:5001');
  final serverUrl = '$kServerUrl/chatHub';
  late final HubConnection hub;

  ChatProvider() {
    final httpConnectionOptions =
        HttpConnectionOptions(accessTokenFactory: () => FirebaseAuth.instance.currentUser!.getIdToken());
    hub = HubConnectionBuilder().withUrl(serverUrl, options: httpConnectionOptions).withAutomaticReconnect().build();
  }

  Future<ChatSession> getSession(String appointmentId) async {
    final res = await get('/api/chat/GetSession/$appointmentId');
    if (res.statusCode == 200) {
      return ChatSession.fromJson(res.body);
    }
    throw Exception(res.statusText);
  }

  @override
  void dispose() {
    hub.stop();
    super.dispose();
  }
}
