import 'package:crm_prasarana_mobile/common/components/divider/custom_divider.dart';
import 'package:crm_prasarana_mobile/common/components/text/text_icon.dart';
import 'package:crm_prasarana_mobile/core/helper/date_converter.dart';
import 'package:crm_prasarana_mobile/core/helper/string_format_helper.dart';
import 'package:crm_prasarana_mobile/core/route/route.dart';
import 'package:crm_prasarana_mobile/core/utils/color_resources.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/core/utils/style.dart';
import 'package:crm_prasarana_mobile/features/ticket/model/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.index,
    required this.ticketModel,
  });
  final int index;
  final TicketsModel ticketModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.ticketDetailsScreen,
            arguments: ticketModel.data![index].id!);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                left: BorderSide(
                  width: 5.0,
                  color: ColorResources.ticketStatusColor(
                      ticketModel.data![index].status!),
                ),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ticketModel.data![index].subject}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          ticketModel.data![index].statusName?.tr ?? '',
                          style: TextStyle(
                              color: ColorResources.ticketStatusColor(
                                  ticketModel.data![index].status!)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimensions.space5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2,
                          child: Text(
                            Converter.parseHtmlString(
                                ticketModel.data![index].message ?? ''),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: lightSmall.copyWith(
                                color: ColorResources.blueGreyColor),
                          ),
                        ),
                        Text(ticketModel.data![index].priorityName?.tr ?? '',
                            style: lightSmall.copyWith(
                                color: ColorResources.ticketPriorityColor(
                                    ticketModel.data![index].priority ?? ''))),
                      ],
                    ),
                    const CustomDivider(space: Dimensions.space10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextIcon(
                          text: ticketModel.data![index].company ?? '',
                          icon: Icons.account_box_rounded,
                        ),
                        TextIcon(
                          text: DateConverter.formatValidityDate(
                              ticketModel.data![index].dateCreated ?? ''),
                          icon: Icons.calendar_month,
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
