import 'package:flutter/foundation.dart';

@immutable
class Sensor {
  Sensor({
    required this.Sensor1,
    required this.Sensor2,
  });

  Sensor.fromJson(Map<String, Object?> json)
      : this(
          Sensor1: json['sensor1'] as num,
          Sensor2: json['sensor2']! as num,
        );

  final num Sensor1;
  final num Sensor2;

  Map<String, Object?> toJson() {
    return {
      'Sensor1': Sensor1,
      'Sensor2': Sensor2,
    };
  }
}
