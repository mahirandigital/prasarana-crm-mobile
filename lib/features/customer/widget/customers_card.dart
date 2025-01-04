import 'package:crm_prasarana_mobile/common/components/circle_avatar_with_letter.dart';
import 'package:crm_prasarana_mobile/core/route/route.dart';
import 'package:crm_prasarana_mobile/core/utils/color_resources.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/core/utils/style.dart';
import 'package:crm_prasarana_mobile/features/customer/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomersCard extends StatelessWidget {
  const CustomersCard({
    super.key,
    required this.index,
    required this.customerModel,
  });
  final int index;
  final CustomersModel customerModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.customerDetailsScreen,
            arguments: customerModel.data![index].userId!);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space5),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.cardRadius),
              color: Theme.of(context).cardColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.space15,
                    vertical: Dimensions.space10),
                leading: CircleAvatarWithInitialLetter(
                  initialLetter: customerModel.data![index].company ?? '',
                ),
                title: Text(customerModel.data![index].company ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: regularDefault.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color)),
                subtitle: Text(
                  customerModel.data![index].phoneNumber ?? '',
                  style: regularSmall.copyWith(color: ColorResources.blueColor),
                ),
                trailing: Container(
                    padding: const EdgeInsets.all(Dimensions.space5),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.cardRadius),
                        side: BorderSide(
                            color: customerModel.data![index].active == '1'
                                ? ColorResources.greenColor
                                : ColorResources.redColor),
                      ),
                    ),
                    child: Text(
                      customerModel.data![index].active == '1'
                          ? LocalStrings.active.tr
                          : LocalStrings.notActive.tr,
                      style: regularSmall.copyWith(
                          color: customerModel.data![index].active == '1'
                              ? ColorResources.greenColor
                              : ColorResources.redColor),
                    )))),
      ),
    );
  }
}
