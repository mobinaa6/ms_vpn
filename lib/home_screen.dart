// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:hive/hive.dart';
import 'package:ms_vpn/constants/custom_colors.dart';
import 'package:ms_vpn/constants/string_constants.dart';
import 'package:ms_vpn/data/model/vpn.dart';
import 'package:ms_vpn/utils/ext.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var vpnBox = Hive.box<Vpn>(VPN_BOX);

  String configLink1 =
      'vless://238c77f4-d52f-43ad-ab97-33b4863bfeb2@vip1.miladgersna.lol:22496?type=tcp&path=%2F&headerType=http&security=none#%E3%80%8A%E3%80%8AUser%E3%80%8B%E3%80%8B-Mobin-vless';
  String configLink2 =
      'vmess://ewogICJ2IjogIjIiLAogICJwcyI6ICJNb2Jpbi1WbWVzcy1tb2JpbiIsCiAgImFkZCI6ICJ2aXAxLm1pbGFkZ2Vyc25hLmxvbCIsCiAgInBvcnQiOiA0MTU1OCwKICAiaWQiOiAiMjdlNzAzMTMtOWEyMy00ODhkLWJiYmItZDI4M2YxZDIxNzk1IiwKICAibmV0IjogInRjcCIsCiAgInR5cGUiOiAibm9uZSIsCiAgInRscyI6ICJub25lIgp9';
  FlutterV2ray? flutterV2ray;
  V2RayURL? v2rayURL;
  String status = '';
  String ping = '';
  int itemSelected = 0;
  Color itemBorderColor = Colors.white;
  FlutterV2ray? flutterV2rayMain;
  V2RayURL? v2rayURLMain;
  List<FlutterV2ray> flutterv2rayList = [];
  List<V2RayURL> v2rayUrlList = [];
  var isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorSchemeTheme = Theme.of(context).colorScheme;
    String statusConfig;
    initV2rayWhenListIsEmpty(List<Vpn> vpnList) async {
      vpnList.forEach((element) async {
        var flutterV2raynew = FlutterV2ray(
          onStatusChanged: (status) {
            setState(() {
              statusConfig = status.state;
            });
          },
        );
        await flutterV2raynew.initializeV2Ray();
        v2rayURLMain = FlutterV2ray.parseFromURL(element.configLink);
        setState(() {
          flutterv2rayList.add(flutterV2raynew);
          v2rayUrlList.add(v2rayURLMain!);
        });
      });
    }

    return Scaffold(
      backgroundColor: colorSchemeTheme.surface,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppbarMain(
                  importConfig: () async {
                    flutterV2rayMain = FlutterV2ray(
                      onStatusChanged: (status) {
                        setState(() {
                          statusConfig = status.state;
                        });
                      },
                    );
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    await flutterV2rayMain?.initializeV2Ray();
                    v2rayURLMain = FlutterV2ray.parseFromURL(data?.text ?? '');
                    flutterv2rayList.add(flutterV2rayMain!);
                    v2rayUrlList.add(v2rayURLMain!);
                    vpnBox.add(
                      Vpn(
                        data?.text ?? '',
                      ),
                    );
                    setState(() {
                      itemSelected = 0;
                    });

                    await flutterv2rayList[0].requestPermission();
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (vpnBox.values.toList().isNotEmpty &&
                        v2rayUrlList.isEmpty) {
                      initV2rayWhenListIsEmpty(vpnBox.values.toList());
                    }

                    if (v2rayUrlList.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                itemSelected = index;
                              });
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: itemSelected == index
                                        ? colorSchemeTheme.primary
                                        : colorSchemeTheme.secondary,
                                    width: itemSelected == index ? 3 : 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          v2rayUrlList[index]
                                              .remark
                                              .replaceRange(
                                                  0,
                                                  v2rayUrlList[index]
                                                      .remark
                                                      .indexOf('-'),
                                                  ''),
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(v2rayUrlList[index]
                                                  .url
                                                  .contains('vmess')
                                              ? 'vmess'
                                              : 'vless'),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 24,
                                        )),
                                    IconButton(
                                      onPressed: () async {
                                        await vpnBox.deleteAt(index);
                                        flutterv2rayList.removeAt(index);
                                        v2rayUrlList.removeAt(index);
                                        vpnBox.values.toList().sort();
                                        flutterv2rayList.sort();
                                        v2rayUrlList.sort();
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  childCount: vpnBox.values.toList().isEmpty
                      ? 0
                      : vpnBox.values.toList().length,
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 230)),
            ],
          ),
          GestureDetector(
            onTap: () async {
              try {
                if (vpnBox.values.toList().isNotEmpty) {
                  var isAllowPermission =
                      await flutterv2rayList[itemSelected].requestPermission();
                  if (isAllowPermission) {
                    if (!isButtonClicked) {
                      await flutterv2rayList[itemSelected]
                          .startV2Ray(
                        remark: v2rayUrlList[itemSelected].remark,
                        config:
                            v2rayUrlList[itemSelected].getFullConfiguration(),
                        blockedApps: null,
                        bypassSubnets: null,
                        proxyOnly: false,
                      )
                          .then((value) {
                        isButtonClicked = !isButtonClicked;
                      });
                    } else {
                      await flutterv2rayList[itemSelected].stopV2Ray();
                    }
                  } else {
                    showToast(
                        'لطغا برای استفاده از برنامه اجازه دسترسی را بدهید');
                  }
                } else {
                  showToast('لطفا لینک کانفیگ خود را وارد کنید');
                }
              } catch (e) {
                showToast('مشکلی در کانفیگ یا اینترنت شما وجود دارد');
              }
            },
            child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: isButtonClicked ? null : widget.colorSchemeTheme.secondary,
                    gradient: isButtonClicked
                        ? CustomColors.activeButtonColor
                        : null),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      size: 50,
                      // color: widget.colorSchemeTheme.onSecondary,
                    ),
                  ],
                )),
          )
        ],
      )),
    );
  }
}

// ignore: must_be_immutable
class AppbarMain extends StatelessWidget {
  AppbarMain({
    super.key,
    this.importConfig,
  });

  VoidCallback? importConfig;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded),
        ),
        const Text(
          'MS Vpn',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        IconButton(
          onPressed: importConfig,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.colorSchemeTheme,
    required this.v2rayURL,
    required this.indexFromRemark,
    required this.isVmess,
    required this.itemBorderColor,
  });

  final ColorScheme colorSchemeTheme;
  final V2RayURL? v2rayURL;
  final int? indexFromRemark;
  final bool isVmess;
  final Color itemBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: itemBorderColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  v2rayURL?.remark.replaceRange(0, indexFromRemark, '') ?? '',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    isVmess ? 'vmess' : 'vless',
                  ),
                )
              ],
            ),
            Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.copy,
                  size: 24,
                )),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
