import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:my_mosque_attedance/app/config/assets_manager.dart';
import 'package:my_mosque_attedance/app/config/color_manager.dart';
import 'package:my_mosque_attedance/app/config/style_manager.dart';
import 'package:my_mosque_attedance/app/config/values_manager.dart';
import 'package:my_mosque_attedance/data/enums/loading_state_enum.dart';
import 'package:my_mosque_attedance/screens/custom_widgets/bottun_custom.dart';
import 'package:my_mosque_attedance/screens/home_screen/home_screen.dart';
import 'package:my_mosque_attedance/screens/home_screen/home_screen_logic.dart';
import 'package:my_mosque_attedance/screens/points_screen/points_screen_logic.dart';

class PointsScreen extends GetView<PointsScreenController> {
  const PointsScreen({super.key});

  // بوتم شيت لاختيار سبب جاهز أو إضافة سبب جديد للقائمة
  void _showReasonSheet(BuildContext context) {
    final newReasonController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorManager.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorManager.greyColor300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'اختر سبباً',
                style: StyleManager.h4_Bold(color: ColorManager.blackColor),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.reasons.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final item = controller.reasons[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item,
                          style: StyleManager.body01_Regular(),
                        ),
                        trailing: Obx(
                          () =>
                              controller.reason.value == item
                                  ? Icon(
                                    Icons.check_circle,
                                    color: ColorManager.firstColor,
                                  )
                                  : const SizedBox.shrink(),
                        ),
                        onTap: () {
                          controller.selectReason(item);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newReasonController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintStyle: StyleManager.body01_Regular(),
                        hintText: 'سبب جديد...',
                      ),
                      onSubmitted: (value) {
                        controller.addReason(value);
                        newReasonController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.firstColor,
                      foregroundColor: ColorManager.whiteColor,
                    ),
                    onPressed: () {
                      controller.addReason(newReasonController.text);
                      newReasonController.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة سبب'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

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
                  "نقاط الطالب",
                  style: StyleManager.h1_Bold(color: ColorManager.blackColor),
                ),
              ),
              SizedBox(height: 16),

              // نقاط + إدخال يدوي أو اختيار من القائمة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر عدد النقاط:',
                      style: StyleManager.h4_Bold(
                        color: ColorManager.blackColor,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            items:
                                [10, 20, 50, 100, 200, 500, 1000]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text('$e'),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              controller.selectedPoints.value = value;
                            },
                            hint: Text(
                              'اختر من القائمة',
                              style: StyleManager.body01_Regular(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintStyle: StyleManager.body01_Regular(),
                              hintText: 'أدخل يدوياً',
                            ),
                            onChanged: (value) {
                              int? parsed = int.tryParse(value);
                              if (parsed != null)
                                controller.selectedPoints.value = parsed;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'اختر العملية:',
                      style: StyleManager.h4_Bold(
                        color: ColorManager.blackColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Radio<bool>(
                            value: true,
                            groupValue: controller.operationType.value == 'add',
                            onChanged:
                                (_) => controller.operationType.value = 'add',
                          ),
                        ),
                        Text('إضافة', style: StyleManager.body01_Regular()),
                        SizedBox(width: 24),
                        Obx(
                          () => Radio<bool>(
                            value: false,
                            groupValue: controller.operationType.value == 'add',
                            onChanged:
                                (_) =>
                                    controller.operationType.value = 'remove',
                          ),
                        ),
                        Text('حذف', style: StyleManager.body01_Regular()),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'سبب العملية:',
                      style: StyleManager.h4_Bold(
                        color: ColorManager.blackColor,
                      ),
                    ),
                    TextFormField(
                      controller: controller.reasonController,
                      decoration: InputDecoration(
                        hintStyle: StyleManager.body01_Regular(),
                        hintText: 'مثلاً: حفظ سورة، غياب، سلوك...',
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: ColorManager.firstColor,
                          ),
                          tooltip: 'اختيار سبب',
                          onPressed: () => _showReasonSheet(context),
                        ),
                      ),
                      onChanged: (value) => controller.reason.value = value,
                    ),
                  ],
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
              SizedBox(height: 32),

              BottouCustom(
                function: () {
                  Get.off(HomeScreen(), binding: HomePageBinging());
                },
                text: "تسجيل الحضور",
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
