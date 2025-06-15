import '/app/services/api/end_points.dart';

class AttedanceEntitie {
  final String message;
  String? status;

  AttedanceEntitie({required this.message, this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{ApiKey.message: message, ApiKey.status: status};
  }

  factory AttedanceEntitie.fromMap(Map<String, dynamic> map) {
    return AttedanceEntitie(
      message: map[ApiKey.message] as String,
      status: map[ApiKey.status] as String?,
    );
  }
}
