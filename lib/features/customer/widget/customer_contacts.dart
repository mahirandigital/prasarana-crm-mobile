import 'package:crm_prasarana_mobile/common/components/custom_fab.dart';
import 'package:crm_prasarana_mobile/common/components/custom_loader/custom_loader.dart';
import 'package:crm_prasarana_mobile/common/components/no_data.dart';
import 'package:crm_prasarana_mobile/core/route/route.dart';
import 'package:crm_prasarana_mobile/core/service/api_service.dart';
import 'package:crm_prasarana_mobile/core/utils/color_resources.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/features/customer/controller/customer_controller.dart';
import 'package:crm_prasarana_mobile/features/customer/model/contact_model.dart';
import 'package:crm_prasarana_mobile/features/customer/repo/customer_repo.dart';
import 'package:crm_prasarana_mobile/features/customer/widget/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class CustomerContacts extends StatefulWidget {
  const CustomerContacts({super.key, required this.id});
  final String id;

  @override
  State<CustomerContacts> createState() => _CustomerContactsState();
}

class _CustomerContactsState extends State<CustomerContacts> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(CustomerRepo(apiClient: Get.find()));
    final controller = Get.put(CustomerController(customerRepo: Get.find()));
    controller.isLoading = true;
    super.initState();
    handleScroll();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadCustomerContacts(widget.id);
    });
  }

  bool showFab = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.removeListener(() {});
    Get.find<CustomerController>().customerContactsModel = ContactsModel();
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (showFab) setState(() => showFab = false);
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!showFab) setState(() => showFab = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerController>(
      builder: (controller) {
        return Scaffold(
          floatingActionButton: AnimatedSlide(
            offset: showFab ? Offset.zero : const Offset(0, 2),
            duration: const Duration(milliseconds: 300),
            child: AnimatedOpacity(
              opacity: showFab ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: CustomFAB(
                  isShowIcon: true,
                  isShowText: false,
                  press: () {
                    Get.toNamed(RouteHelper.addContactScreen,
                        arguments: widget.id);
                  }),
            ),
          ),
          body: controller.isLoading
              ? const CustomLoader()
              : controller.customerContactsModel.data != null
                  ? RefreshIndicator(
                      color: ColorResources.primaryColor,
                      onRefresh: () async {
                        await controller.loadCustomerContacts(widget.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.space10),
                        child: ListView.builder(
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              return ContactCard(
                                index: index,
                                contactModel: controller.customerContactsModel,
                              );
                            },
                            itemCount:
                                controller.customerContactsModel.data!.length),
                      ),
                    )
                  : const Center(child: NoDataWidget()),
        );
      },
    );
  }
}
