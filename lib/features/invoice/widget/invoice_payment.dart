import 'package:crm_prasarana_mobile/common/components/divider/custom_divider.dart';
import 'package:crm_prasarana_mobile/common/components/text/text_icon.dart';
import 'package:crm_prasarana_mobile/core/helper/date_converter.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/core/utils/style.dart';
import 'package:crm_prasarana_mobile/features/invoice/model/invoice_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicePayment extends StatelessWidget {
  const InvoicePayment(
      {super.key, required this.payment, required this.currency});
  final Payments payment;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${LocalStrings.payment.tr} #${payment.id ?? ''}',
              style: regularDefault,
            ),
            Text(
              '$currency${payment.amount ?? ''}',
              style: regularDefault,
            ),
          ],
        ),
        const CustomDivider(space: Dimensions.space10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextIcon(
              text: payment.methodName ?? '',
              icon: Icons.payments_outlined,
            ),
            const SizedBox(
              width: Dimensions.space15,
            ),
            TextIcon(
              text:
                  DateConverter.formatValidityDate(payment.dateRecorded ?? ''),
              icon: Icons.calendar_month,
            ),
          ],
        )
      ],
    );
  }
}
