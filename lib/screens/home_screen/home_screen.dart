import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:my_mosque_attedance/app/config/assets_manager.dart';
import 'package:my_mosque_attedance/app/config/color_manager.dart';
import 'package:my_mosque_attedance/app/config/style_manager.dart';
import 'package:my_mosque_attedance/app/config/values_manager.dart';
import 'package:my_mosque_attedance/data/enums/loading_state_enum.dart';
import 'package:my_mosque_attedance/screens/custom_widgets/bottun_custom.dart';
import 'package:my_mosque_attedance/screens/home_screen/home_screen_logic.dart';
import 'package:my_mosque_attedance/screens/points_screen/points_screen.dart';
import 'package:my_mosque_attedance/screens/points_screen/points_screen_logic.dart';
import 'package:my_mosque_attedance/screens/qr_scanner_screen/qr_scanner_screen.dart';

class HomeScreen extends GetView<HomePageController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  color: ColorManager.firstColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      AssetsManager.logoIcon,
                      fit: BoxFit.contain,
                      // width: MediaQuery.sizeOf(context).width * 0.5,
                      height: MediaQuery.sizeOf(context).height * 0.12,
                    ),
                    Center(
                      child: Text(
                        "مسجد الغنيمي",
                        style: StyleManager.h3_Bold(
                          color: ColorManager.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  "تفقد حضور الطلاب",
                  style: StyleManager.h1_Bold(color: ColorManager.blackColor),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  "امسح الباركود لتسجيل الحضور",
                  style: StyleManager.h4_Bold(color: ColorManager.blackColor),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: InkWell(
                  onTap: () async {
                    if (controller.loadingState.value == LoadingState.idle)
                      controller.openQRCode(context);
                  },
                  child: Image.asset(
                    AssetsManager.qrIcon,
                    fit: BoxFit.contain,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: MediaQuery.sizeOf(context).height * 0.25,
                  ),
                ),
              ),
              Obx(
                () =>
                    controller.loadingState.value == LoadingState.loading
                        ? Padding(
                          padding: const EdgeInsets.only(top: AppPadding.p40),
                          child: CircularProgressIndicator(),
                        )
                        : Container(),
              ),
              SizedBox(height: 64),
              BottouCustom(
                function: () {
                  Get.off(PointsScreen(), binding: PointsScreenLogic());
                },
                text: "ادارة النقاط",
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(color: ColorManager.firstColor),
          child: Center(
            child: Text(
              "by NGP",
              style: StyleManager.h4_Bold(color: ColorManager.whiteColor),
            ),
          ),
        ),
      ),
    );
  }
}
