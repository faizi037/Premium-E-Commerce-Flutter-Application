import 'package:isar/isar.dart';

part 'profile.g.dart';

@collection
class Profile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String email;
  
  late String username;
  
  late DateTime? birthday;
  
  late DateTime createdAt;
}
