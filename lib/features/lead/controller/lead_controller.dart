import 'dart:async';
import 'dart:convert';
import 'package:crm_prasarana_mobile/common/components/file_download_dialog/download_dialog.dart';
import 'package:crm_prasarana_mobile/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/common/models/response_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/lead_create_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/lead_details_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/lead_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/sources_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/statuses_model.dart';
import 'package:crm_prasarana_mobile/features/lead/repo/lead_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadController extends GetxController {
  LeadRepo leadRepo;
  LeadController({required this.leadRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  LeadsModel leadsModel = LeadsModel();
  LeadDetailsModel leadDetailsModel = LeadDetailsModel();

  StatusesModel statusesModel = StatusesModel();
  SourcesModel sourcesModel = SourcesModel();

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadLeads();
    isLoading = false;
    update();
  }

  Future<void> loadLeads() async {
    ResponseModel responseModel = await leadRepo.getAllLeads();
    if (responseModel.status) {
      leadsModel = LeadsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadLeadDetails(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadDetails(leadId);
    if (responseModel.status) {
      leadDetailsModel =
          LeadDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  bool downloadLoading = false;
  Future<void> downloadAttachment(
      String attachmentType, String attachmentKey) async {
    downloadLoading = true;
    update();

    ResponseModel responseModel =
        await leadRepo.attachmentDownload(attachmentKey);
    if (responseModel.status) {
      showDialog(
        context: Get.context!,
        builder: (context) => DownloadingDialog(
            isImage: true,
            isPdf: false,
            url: attachmentType,
            fileName: attachmentKey),
      );
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    downloadLoading = false;
    update();
  }

  Future<StatusesModel> loadLeadStatuses() async {
    ResponseModel responseModel = await leadRepo.getLeadStatuses();
    return statusesModel =
        StatusesModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<SourcesModel> loadLeadSources() async {
    ResponseModel responseModel = await leadRepo.getLeadSources();
    return sourcesModel =
        SourcesModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<void> loadLeadUpdateData(leadId) async {
    ResponseModel responseModel = await leadRepo.getLeadDetails(leadId);
    if (responseModel.status) {
      leadDetailsModel =
          LeadDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
      sourceController.text = leadDetailsModel.data?.source ?? '';
      statusController.text = leadDetailsModel.data?.status ?? '';
      nameController.text = leadDetailsModel.data?.name ?? '';
      assignedController.text = leadDetailsModel.data?.assigned ?? '';
      valueController.text = leadDetailsModel.data?.leadValue ?? '';
      titleController.text = leadDetailsModel.data?.title ?? '';
      emailController.text = leadDetailsModel.data?.email ?? '';
      websiteController.text = leadDetailsModel.data?.website ?? '';
      phoneNumberController.text = leadDetailsModel.data?.phoneNumber ?? '';
      companyController.text = leadDetailsModel.data?.company ?? '';
      addressController.text = leadDetailsModel.data?.address ?? '';
      cityController.text = leadDetailsModel.data?.city ?? '';
      stateController.text = leadDetailsModel.data?.state ?? '';
      countryController.text = leadDetailsModel.data?.country ?? '';
      defaultLanguageController.text =
          leadDetailsModel.data?.defaultLanguage ?? '';
      descriptionController.text = leadDetailsModel.data?.description ?? '';
      //customContactDateController.text = leadDetailsModel.data?.lastContact ?? '';
      //contactedTodayController.text = leadDetailsModel.data?.lastContact ?? '';
      isPublicController.text = leadDetailsModel.data?.isPublic ?? '';
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  TextEditingController sourceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController assignedController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController defaultLanguageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController isPublicController = TextEditingController();

  FocusNode sourceFocusNode = FocusNode();
  FocusNode statusFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode assignedFocusNode = FocusNode();
  FocusNode tagsFocusNode = FocusNode();
  FocusNode valueFocusNode = FocusNode();
  FocusNode titleFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode websiteFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode companyFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();
  FocusNode defaultLanguageFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode isPublicFocusNode = FocusNode();

  Future<void> submitLead({String? leadId, bool isUpdate = false}) async {
    String source = sourceController.text.toString();
    String status = statusController.text.toString();
    String name = nameController.text.toString();
    String assigned = assignedController.text.toString();
    String tags = tagsController.text.toString();
    String value = valueController.text.toString();
    String title = titleController.text.toString();
    String email = emailController.text.toString();
    String website = websiteController.text.toString();
    String phoneNumber = phoneNumberController.text.toString();
    String company = companyController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String state = stateController.text.toString();
    String country = countryController.text.toString();
    String defaultLanguage = defaultLanguageController.text.toString();
    String description = descriptionController.text.toString();
    String isPublic = isPublicController.text.toString();

    if (source.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.pleaseSelectSource.tr]);
      return;
    }
    if (status.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterStatus.tr]);
      return;
    }
    if (name.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterName.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    LeadCreateModel leadModel = LeadCreateModel(
      source: source,
      status: status,
      name: name,
      assigned: assigned,
      tags: tags,
      value: value,
      title: title,
      email: email,
      website: website,
      phoneNumber: phoneNumber,
      company: company,
      address: address,
      city: city,
      state: state,
      country: country,
      defaultLanguage: defaultLanguage,
      description: description,
      isPublic: isPublic,
    );

    ResponseModel responseModel = await leadRepo.createLead(leadModel,
        leadId: leadId, isUpdate: isUpdate);
    if (responseModel.status) {
      clearData();
      Get.back();
      if (isUpdate) await loadLeadDetails(leadId);
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Lead
  Future<void> deleteLead(leadId) async {
    ResponseModel responseModel = await leadRepo.deleteLead(leadId);

    isSubmitLoading = true;
    update();

    if (responseModel.status) {
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [(responseModel.message.tr)]);
    }

    isSubmitLoading = false;
    update();
  }

  // Search Leads
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchLead() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await leadRepo.searchLead(keysearch);
    if (responseModel.status) {
      leadsModel = LeadsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();

    if (!isSearch) {
      searchController.clear();
      initialData();
    }
  }

  void clearData() {
    isLoading = false;
    isSubmitLoading = false;
    sourceController.text = '';
    statusController.text = '';
    nameController.text = '';
    assignedController.text = '';
    tagsController.text = '';
    valueController.text = '';
    titleController.text = '';
    emailController.text = '';
    websiteController.text = '';
    phoneNumberController.text = '';
    companyController.text = '';
    addressController.text = '';
    cityController.text = '';
    stateController.text = '';
    countryController.text = '';
    defaultLanguageController.text = '';
    descriptionController.text = '';
    isPublicController.text = '';
  }
}
