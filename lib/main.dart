import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ms_vpn/constants/string_constants.dart';
import 'package:ms_vpn/data/model/vpn.dart';
import 'package:ms_vpn/home_screen.dart';
import 'package:ms_vpn/theme/dark_theme.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(VpnAdapter());
  await Hive.openBox<Vpn>(VPN_BOX);
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: const HomeScreen(),
    );
  }
}
