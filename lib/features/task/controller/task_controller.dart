import 'dart:async';
import 'dart:convert';
import 'package:crm_prasarana_mobile/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:crm_prasarana_mobile/core/helper/string_format_helper.dart'
    as formatter;
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/common/models/response_model.dart';
import 'package:crm_prasarana_mobile/features/contract/model/contract_model.dart';
import 'package:crm_prasarana_mobile/features/customer/model/customer_model.dart';
import 'package:crm_prasarana_mobile/features/estimate/model/estimate_model.dart';
import 'package:crm_prasarana_mobile/features/invoice/model/invoice_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/lead_model.dart';
import 'package:crm_prasarana_mobile/features/project/model/project_model.dart';
import 'package:crm_prasarana_mobile/features/proposal/model/proposal_model.dart';
import 'package:crm_prasarana_mobile/features/task/model/task_create_model.dart';
import 'package:crm_prasarana_mobile/features/task/model/task_details_model.dart';
import 'package:crm_prasarana_mobile/features/task/model/tasks_model.dart';
import 'package:crm_prasarana_mobile/features/task/repo/task_repo.dart';
import 'package:crm_prasarana_mobile/features/ticket/model/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  TaskRepo taskRepo;
  TaskController({required this.taskRepo});

  bool isLoading = true;
  bool isSubmitLoading = false;
  bool isPublic = false;
  bool billable = false;
  TasksModel tasksModel = TasksModel();
  TaskDetailsModel taskDetailsModel = TaskDetailsModel();
  CustomersModel customersModel = CustomersModel();
  ProjectsModel projectsModel = ProjectsModel();
  InvoicesModel invoicesModel = InvoicesModel();
  ProposalsModel proposalsModel = ProposalsModel();
  EstimatesModel estimatesModel = EstimatesModel();
  ContractsModel contractsModel = ContractsModel();
  LeadsModel leadsModel = LeadsModel();
  TicketsModel ticketsModel = TicketsModel();

  final Map<String, String> taskPriority = {
    '1': LocalStrings.priorityLow.tr,
    '2': LocalStrings.priorityMedium.tr,
    '3': LocalStrings.priorityHigh.tr,
    '4': LocalStrings.priorityUrgent.tr,
  };

  final Map<String, String> taskRelated = {
    'lead': LocalStrings.lead.tr,
    'customer': LocalStrings.customer.tr,
    'invoice': LocalStrings.invoice.tr,
    'project': LocalStrings.project.tr,
    'estimate': LocalStrings.estimate.tr,
    'contract': LocalStrings.contract.tr,
    'ticket': LocalStrings.ticket.tr,
    //'expense': LocalStrings.expense.tr,
    'proposal': LocalStrings.proposal.tr,
  };

  final Map<String, String> repeatEvery = {
    '1': LocalStrings.week.tr,
    '2': LocalStrings.twoWeeks.tr,
    '3': LocalStrings.oneMonth.tr,
    '4': LocalStrings.twoMonths.tr,
    '5': LocalStrings.threeMonths.tr,
    '6': LocalStrings.sixMonths.tr,
    '7': LocalStrings.oneYear.tr,
    '8': LocalStrings.custom.tr,
  };

  final Map<String, String> repeatType = {
    'day': LocalStrings.days.tr,
    'week': LocalStrings.weeks.tr,
    'month': LocalStrings.months.tr,
    'year': LocalStrings.years.tr,
  };

  Future<void> initialData({bool shouldLoad = true}) async {
    isLoading = shouldLoad ? true : false;
    update();

    await loadTasks();
    isLoading = false;
    update();
  }

  Future<void> loadTasks() async {
    ResponseModel responseModel = await taskRepo.getAllTasks();
    if (responseModel.status) {
      tasksModel = TasksModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  Future<void> loadTaskDetails(taskId) async {
    ResponseModel responseModel = await taskRepo.getTaskDetails(taskId);
    if (responseModel.status) {
      taskDetailsModel =
          TaskDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isLoading = false;
    update();
  }

  changeIsPublic() {
    isPublic = !isPublic;
    update();
  }

  changeBillable() {
    billable = !billable;
    update();
  }

  Future<CustomersModel> loadCustomers() async {
    ResponseModel responseModel = await taskRepo.getAllCustomers();
    return customersModel =
        CustomersModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<ProjectsModel> loadProjects() async {
    ResponseModel responseModel = await taskRepo.getAllProjects();
    return projectsModel =
        ProjectsModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<InvoicesModel> loadInvoices() async {
    ResponseModel responseModel = await taskRepo.getAllInvoices();
    return invoicesModel =
        InvoicesModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<LeadsModel> loadLeads() async {
    ResponseModel responseModel = await taskRepo.getAllLeads();
    return leadsModel =
        LeadsModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<ContractsModel> loadContracts() async {
    ResponseModel responseModel = await taskRepo.getAllContracts();
    return contractsModel =
        ContractsModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<EstimatesModel> loadEstimates() async {
    ResponseModel responseModel = await taskRepo.getAllEstimates();
    return estimatesModel =
        EstimatesModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<ProposalsModel> loadProposals() async {
    ResponseModel responseModel = await taskRepo.getAllProposals();
    return proposalsModel =
        ProposalsModel.fromJson(jsonDecode(responseModel.responseJson));
  }

  Future<void> loadTaskUpdateData(taskId) async {
    ResponseModel responseModel = await taskRepo.getTaskDetails(taskId);
    if (responseModel.status) {
      taskDetailsModel =
          TaskDetailsModel.fromJson(jsonDecode(responseModel.responseJson));
      subjectController.text = taskDetailsModel.data?.name ?? '';
      rateController.text = taskDetailsModel.data?.hourlyRate ?? '';
      startDateController.text = taskDetailsModel.data?.startDate ?? '';
      dueDateController.text = taskDetailsModel.data?.dueDate ?? '';
      taskPriorityController.text = taskDetailsModel.data?.priority ?? '';
      taskRelatedController.text = taskDetailsModel.data?.relType ?? '';
      relationIdController.text = taskDetailsModel.data?.relId ?? '';
      descriptionController.text = formatter.Converter.parseHtmlString(
          taskDetailsModel.data?.description ?? '');
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }
    isLoading = false;
    update();
  }

  TextEditingController subjectController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController taskPriorityController = TextEditingController();
  TextEditingController repeatEveryController = TextEditingController();
  TextEditingController repeatEveryCustomController = TextEditingController();
  TextEditingController repeatTypeCustomController = TextEditingController();
  TextEditingController taskRelatedController = TextEditingController();
  TextEditingController relationIdController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode subjectFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  FocusNode startDateFocusNode = FocusNode();
  FocusNode dueDateFocusNode = FocusNode();
  FocusNode taskPriorityFocusNode = FocusNode();
  FocusNode taskRelatedFocusNode = FocusNode();
  FocusNode relationIdFocusNode = FocusNode();
  FocusNode repeatEveryFocusNode = FocusNode();
  FocusNode repeatEveryCustomFocusNode = FocusNode();
  FocusNode repeatTypeCustomFocusNode = FocusNode();
  FocusNode tagsFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  Future<void> submitTask({String? taskId, bool isUpdate = false}) async {
    String subject = subjectController.text.toString();
    String rate = rateController.text.toString();
    String startDate = startDateController.text.toString();
    String dueDate = dueDateController.text.toString();
    String priority = taskPriorityController.text.toString();
    String repeat = repeatEveryController.text.toString();
    String related = taskRelatedController.text.toString();
    String relId = relationIdController.text.toString();
    String tags = tagsController.text.toString();
    String description = descriptionController.text.toString();

    if (subject.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterSubject.tr]);
      return;
    }
    if (startDate.isEmpty) {
      CustomSnackBar.error(errorList: [LocalStrings.enterStartDate.tr]);
      return;
    }

    isSubmitLoading = true;
    update();

    TaskCreateModel taskModel = TaskCreateModel(
      subject: subject,
      isPublic: isPublic ? 'on' : '',
      billable: billable ? 'on' : '',
      hourlyRate: rate,
      startDate: startDate,
      dueDate: dueDate,
      priority: priority,
      repeatEvery: repeat,
      relType: related,
      relId: relId,
      tags: tags,
      description: description,
    );

    ResponseModel responseModel = await taskRepo.createTask(taskModel,
        taskId: taskId, isUpdate: isUpdate);
    if (responseModel.status) {
      Get.back();
      if (isUpdate) await loadTaskDetails(taskId);
      clearData();
      await initialData();
      CustomSnackBar.success(successList: [responseModel.message.tr]);
    } else {
      CustomSnackBar.error(errorList: [responseModel.message.tr]);
    }

    isSubmitLoading = false;
    update();
  }

  // Delete Task
  Future<void> deleteTask(taskId) async {
    ResponseModel responseModel = await taskRepo.deleteTask(taskId);

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

  // Search Tasks
  TextEditingController searchController = TextEditingController();
  String keysearch = "";

  Future<void> searchTask() async {
    keysearch = searchController.text;
    ResponseModel responseModel = await taskRepo.searchTask(keysearch);
    if (responseModel.status) {
      tasksModel = TasksModel.fromJson(jsonDecode(responseModel.responseJson));
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
    isPublic = false;
    billable = false;
    subjectController.text = '';
    rateController.text = '';
    startDateController.text = '';
    dueDateController.text = '';
    taskPriorityController.text = '';
    taskRelatedController.text = '';
    relationIdController.text = '';
    tagsController.text = '';
    descriptionController.text = '';
    repeatTypeCustomController.text = '';
    repeatEveryCustomController.text = '';
    repeatEveryController.text = '';
  }
}
