import 'package:crm_prasarana_mobile/common/components/app-bar/custom_appbar.dart';
import 'package:crm_prasarana_mobile/common/components/custom_loader/custom_loader.dart';
import 'package:crm_prasarana_mobile/core/service/api_service.dart';
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/features/privacy/controller/privacy_controller.dart';
import 'package:crm_prasarana_mobile/features/privacy/repo/privacy_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:crm_prasarana_mobile/core/utils/style.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(PrivacyRepo(apiClient: Get.find()));
    final controller = Get.put(PrivacyController(repo: Get.find()));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: LocalStrings.privacyPolicy.tr,
          bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          isShowActionBtn: false,
        ),
        body: GetBuilder<PrivacyController>(
          builder: (controller) => SizedBox(
            width: MediaQuery.of(context).size.width,
            child: controller.isLoading
                ? const CustomLoader()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              color: Colors.transparent,
                              child: HtmlWidget(controller.selectedHtml,
                                  textStyle: regularDefault.copyWith(
                                      color: Colors.black),
                                  onLoadingBuilder:
                                      (context, element, loadingProgress) =>
                                          const Center(child: CustomLoader()))))
                    ],
                  ),
          ),
        ));
  }
}
