import 'package:hive/hive.dart';
part 'hiveconfig.g.dart';

@HiveType(typeId: 1)
class HiveConfig extends HiveObject {
  @HiveField(0)
  final String link;

  @HiveField(1)
  final String remark;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String type;

  @HiveField(4)
  bool isclicked;

  HiveConfig(this.link, this.remark, this.image, this.type, this.isclicked);
}
