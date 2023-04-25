import 'package:mobile/providers/http_provider.dart';

import '../models/available_times.dart';

class AvailableTimeProvider extends HttpProvider {
  Future<List<AvailableTimes>?> getAvailableTimes(String doctorId) async {
    final res = await get<List<dynamic>>("/api/availableTime/$doctorId");
    if (res.statusCode == 200) {
      return res.body!.map((e) => AvailableTimes.fromJson(e)).toList();
    }
    throw Exception(res.statusText);
  }
}
