import 'dart:async';
import 'dart:convert';
import 'package:crm_prasarana_mobile/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:crm_prasarana_mobile/common/models/response_model.dart';
import 'package:crm_prasarana_mobile/features/profile/model/profile_model.dart';
import 'package:crm_prasarana_mobile/features/profile/repo/profile_repo.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  ProfileRepo profileRepo;
  ProfileController({required this.profileRepo});

  bool isLoading = true;
  ProfileModel profileModel = ProfileModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadData();
    isLoading = false;
    update();
  }

  Future<dynamic> loadData() async {
    ResponseModel responseModel = await profileRepo.getData();
    if (responseModel.status) {
      profileModel =
          ProfileModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }
}
