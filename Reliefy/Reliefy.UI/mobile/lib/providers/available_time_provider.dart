import 'package:mobile/providers/http_provider.dart';

import '../models/available_times.dart';

class AvailableTimeProvider extends HttpProvider {
  Future<List<AvailableTimes>?> getAvailableTimes(String doctorId) async {
    final res = await get("/api/availableTime/$doctorId");
    if (res.statusCode == 200 && res.body is List) {
      return (res.body as List<dynamic>).map((e) => AvailableTimes.fromJson(e)).toList();
    }
    throw Exception(res.statusText);
  }
}
