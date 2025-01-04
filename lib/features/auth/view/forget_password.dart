import 'package:crm_prasarana_mobile/common/components/buttons/rounded_button.dart';
import 'package:crm_prasarana_mobile/common/components/buttons/rounded_loading_button.dart';
import 'package:crm_prasarana_mobile/common/components/text-form-field/custom_text_field.dart';
import 'package:crm_prasarana_mobile/core/service/api_service.dart';
import 'package:crm_prasarana_mobile/core/utils/color_resources.dart';
import 'package:crm_prasarana_mobile/core/utils/images.dart';
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/features/auth/controller/forget_password_controller.dart';
import 'package:crm_prasarana_mobile/features/auth/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/core/utils/style.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(AuthRepo(apiClient: Get.find()));
    Get.put(ForgetPasswordController(loginRepo: Get.find()));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: GetBuilder<ForgetPasswordController>(
            builder: (auth) => SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage(MyImages.login),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 140.0, bottom: 30.0),
                          child: Center(
                            child: Image.asset(MyImages.appLogo,
                                color: ColorResources.colorWhite, height: 60),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocalStrings.forgotPasswordTitle.tr,
                                  style: mediumOverLarge.copyWith(
                                      fontSize: Dimensions.fontMegaLarge,
                                      color: Colors.white),
                                ),
                                Text(
                                  LocalStrings.forgotPasswordDesc.tr,
                                  style: regularDefault.copyWith(
                                      fontSize: Dimensions.fontDefault,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 25.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                      labelText: LocalStrings.emailAddress.tr,
                                      hintText:
                                          LocalStrings.emailAddressHint.tr,
                                      textInputType: TextInputType.emailAddress,
                                      inputAction: TextInputAction.done,
                                      controller: auth.emailController,
                                      onSuffixTap: () {},
                                      onChanged: (value) {
                                        return;
                                      },
                                      validator: (value) {
                                        if (auth.emailController.text.isEmpty) {
                                          return LocalStrings.enterEmail.tr;
                                        } else {
                                          return null;
                                        }
                                      }),
                                  const SizedBox(height: Dimensions.space25),
                                  auth.submitLoading
                                      ? const RoundedLoadingBtn()
                                      : RoundedButton(
                                          press: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              auth.submitForgetPassword();
                                            }
                                          },
                                          text: LocalStrings.submit.tr,
                                        ),
                                  const SizedBox(height: Dimensions.space40)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.grey),
                        onPressed: () => Get.back(),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0, //No shadow
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
