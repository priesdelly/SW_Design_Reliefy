import 'package:mobile/models/appointment.dart';
import 'package:mobile/providers/http_provider.dart';

class AppointmentProvider extends HttpProvider {
  Future<List<Appointment>> getList() async {
    final res = await get('/api/appointment');
    if (res.statusCode == 200 && res.body is List) {
      return (res.body as List<dynamic>).map((e) => Appointment.fromJson(e)).toList();
    }
    throw Exception(res.statusText);
  }

  Future<Appointment?> create({required DateTime startTime, required DateTime endTime, required String doctorId}) async {
    Map request = {"startTime": startTime.toUtc().toIso8601String(), "endTime": endTime.toUtc().toIso8601String(), "doctorId": doctorId};
    final res = await post('/api/appointment', request);
    if (res.statusCode == 200) {
      return Appointment.fromJson(res.body);
    }
    throw Exception(res.statusText);
  }
}
