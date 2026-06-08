import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_mosque_attedance/app/config/color_manager.dart';
import 'package:my_mosque_attedance/data/entities/attedance_entitie.dart';
import 'package:my_mosque_attedance/data/repositories/users_repositories.dart';
import 'package:my_mosque_attedance/screens/custom_widgets/snack_bar_error.dart';
import 'package:my_mosque_attedance/screens/qr_scanner_screen/qr_scanner_screen.dart';
import '../../data/enums/app_state_enum.dart';
import '../../data/enums/loading_state_enum.dart';
import 'package:http/http.dart' as http;

class PointsScreenLogic extends Bindings {
  @override
  void dependencies() {
    Get.put(PointsScreenController());
  }
}

class PointsScreenController extends GetxController {
  final isConnectedPage = true.obs;
  var loadingState = LoadingState.idle.obs;
  var appState = AppState.run.obs;
  final userRepo = Get.find<ImpUsersRepositories>();

  final selectedPoints = RxnInt(); // عدد النقاط المختار
  final operationType = 'add'.obs; // 'add' أو 'remove'
  final reason = ''.obs; // سبب الإضافة / الحذف

  // عنصر التحكم بحقل السبب لتعبئته عند الاختيار من القائمة
  final reasonController = TextEditingController();

  // قائمة الأسباب الجاهزة للاختيار منها
  final reasons = <String>[
    'حفظ سورة',
    'مشاركة',
    'سلوك جيد',
    'غياب',
    'تأخير',
  ].obs;

  // اختيار سبب من القائمة وتعبئة الحقل به
  void selectReason(String value) {
    reason.value = value;
    reasonController.text = value;
  }

  // إضافة سبب جديد إلى القائمة
  void addReason(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (!reasons.contains(trimmed)) {
      reasons.add(trimmed);
    }
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  openQRCode(BuildContext context) async {
    if (selectedPoints.value == null) {
      SnackBarCustom.show(
        context,
        'الرجاء اختيار عدد النقاط أولاً',
        ColorManager.redColor,
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => QRScannerScreen(
              onDetect: (id) {
                int points = selectedPoints.value!;
                if (operationType.value == 'remove') {
                  points = -points; // نستخدم الرقم السالب للحذف
                }
                updatePoints(id, points, context);
              },
            ),
      ),
    );
  }

  updatePoints(String id, int points, BuildContext context) async {
    loadingState.value = LoadingState.loading;
    final response = await userRepo.updatePoint(
      id: id,
      points: points,
      reason: reason.value,
    );

    if (response.success) {
      final data = response.data;
      SnackBarCustom.show(context, data, ColorManager.greenColor);
    } else {
      SnackBarCustom.show(
        context,
        response.networkFailure!.message,
        ColorManager.redColor,
      );
    }
    loadingState.value = LoadingState.idle;
  }
}
