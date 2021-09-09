import 'dart:typed_data';

import 'package:hive/hive.dart';

// import 'package:hive_flutter/hive_flutter.dart';

part 'person_model.g.dart';

@HiveType(typeId: 0)
class Person {
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  String dob;
  @HiveField(3)
  String address;
  @HiveField(4)
  Uint8List file;
  Person({
    required this.name,
    required this.email,
    required this.dob,
    required this.address,
    required this.file,
  });
}
