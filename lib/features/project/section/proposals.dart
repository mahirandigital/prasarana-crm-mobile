import 'package:crm_prasarana_mobile/common/components/custom_loader/custom_loader.dart';
import 'package:crm_prasarana_mobile/common/components/no_data.dart';
import 'package:crm_prasarana_mobile/core/service/api_service.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/features/project/controller/project_controller.dart';
import 'package:crm_prasarana_mobile/features/project/repo/project_repo.dart';
import 'package:crm_prasarana_mobile/features/proposal/widget/proposal_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectProposals extends StatefulWidget {
  const ProjectProposals({super.key, required this.id});
  final String id;

  @override
  State<ProjectProposals> createState() => _ProjectProposalsState();
}

class _ProjectProposalsState extends State<ProjectProposals> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(ProjectRepo(apiClient: Get.find()));
    final controller = Get.put(ProjectController(projectRepo: Get.find()));
    controller.isLoading = true;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadProjectGroup(widget.id, 'proposals');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading
              ? const CustomLoader()
              : controller.proposalsModel.data?.isNotEmpty ?? false
                  ? RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).cardColor,
                      onRefresh: () async {
                        controller.loadProjectGroup(widget.id, 'tasks');
                      },
                      child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.space15),
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ProposalCard(
                              index: index,
                              proposalModel: controller.proposalsModel,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Dimensions.space10),
                          itemCount: controller.proposalsModel.data!.length),
                    )
                  : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
