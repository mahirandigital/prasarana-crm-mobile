import 'package:crm_prasarana_mobile/common/components/no_data.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/features/lead/model/lead_details_model.dart';
import 'package:crm_prasarana_mobile/features/lead/widget/attachment_card.dart';
import 'package:flutter/material.dart';

class LeadAttachment extends StatelessWidget {
  const LeadAttachment({
    super.key,
    required this.leadModel,
  });
  final LeadDetails leadModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.space15),
      child: leadModel.attachments!.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) {
                return AttachmentCard(
                  index: index,
                  attachment: leadModel.attachments!,
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: Dimensions.space10),
              itemCount: leadModel.attachments!.length)
          : const NoDataWidget(),
    );
  }
}
