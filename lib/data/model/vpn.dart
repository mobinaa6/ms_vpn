import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:hive/hive.dart';
part 'vpn.g.dart';

@HiveType(typeId: 0)
class Vpn {
  @HiveField(0)
  String configLink;

  Vpn(this.configLink);
}
