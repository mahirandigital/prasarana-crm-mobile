import 'package:async/async.dart';
import 'package:crm_prasarana_mobile/common/components/app-bar/custom_appbar.dart';
import 'package:crm_prasarana_mobile/common/components/buttons/rounded_button.dart';
import 'package:crm_prasarana_mobile/common/components/buttons/rounded_loading_button.dart';
import 'package:crm_prasarana_mobile/common/components/custom_date_form_field.dart';
import 'package:crm_prasarana_mobile/common/components/custom_drop_down_button_with_text_field.dart';
import 'package:crm_prasarana_mobile/common/components/custom_loader/custom_loader.dart';
import 'package:crm_prasarana_mobile/common/components/text-form-field/custom_drop_down_text_field.dart';
import 'package:crm_prasarana_mobile/common/components/text-form-field/custom_text_field.dart';
import 'package:crm_prasarana_mobile/common/components/text/text_icon.dart';
import 'package:crm_prasarana_mobile/common/models/currencies_model.dart';
import 'package:crm_prasarana_mobile/core/helper/date_converter.dart';
import 'package:crm_prasarana_mobile/core/utils/color_resources.dart';
import 'package:crm_prasarana_mobile/core/utils/dimensions.dart';
import 'package:crm_prasarana_mobile/core/utils/local_strings.dart';
import 'package:crm_prasarana_mobile/core/utils/style.dart';
import 'package:crm_prasarana_mobile/features/customer/model/customer_model.dart';
import 'package:crm_prasarana_mobile/features/item/model/item_model.dart';
import 'package:crm_prasarana_mobile/features/lead/model/lead_model.dart';
import 'package:crm_prasarana_mobile/features/proposal/controller/proposal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProposalScreen extends StatefulWidget {
  const AddProposalScreen({super.key});

  @override
  State<AddProposalScreen> createState() => _AddProposalScreenState();
}

class _AddProposalScreenState extends State<AddProposalScreen> {
  final AsyncMemoizer<CustomersModel> customersMemoizer = AsyncMemoizer();
  final AsyncMemoizer<LeadsModel> leadsMemoizer = AsyncMemoizer();
  final AsyncMemoizer<CurrenciesModel> currenciesMemoizer = AsyncMemoizer();
  final AsyncMemoizer<ItemsModel> itemsMemoizer = AsyncMemoizer();

  @override
  void dispose() {
    Get.find<ProposalController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.addProposal.tr,
      ),
      body: GetBuilder<ProposalController>(
        builder: (controller) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.space15, horizontal: Dimensions.space10),
              child: Column(
                spacing: Dimensions.space15,
                children: [
                  CustomTextField(
                    labelText: LocalStrings.subject.tr,
                    controller: controller.subjectController,
                    focusNode: controller.subjectFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.clientNameFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterSubject.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),

                  CustomDropDownTextField(
                    hintText: LocalStrings.relatedTo.tr,
                    onChanged: (value) {
                      controller.proposalRelatedController.text = value;
                      controller.update();
                    },
                    selectedValue: controller.proposalRelatedController.text,
                    items: controller.proposalRelated.entries
                        .map((MapEntry element) => DropdownMenuItem(
                              value: element.key,
                              child: Text(
                                element.value,
                                style: regularDefault.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                            ))
                        .toList(),
                  ),
                  if (controller.proposalRelatedController.text == 'lead')
                    FutureBuilder(
                        future: leadsMemoizer.runOnce(controller.loadLeads),
                        builder: (context, leadList) {
                          if (leadList.data?.status ?? false) {
                            return CustomDropDownTextField(
                              hintText: LocalStrings.selectLead.tr,
                              onChanged: (value) {
                                controller.clientController.text = value;
                              },
                              items: controller.leadsModel.data!.map((value) {
                                return DropdownMenuItem(
                                  value: value.id,
                                  child: Text(
                                    value.company ?? '',
                                    style: regularDefault.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (leadList.data?.status == false) {
                            return CustomDropDownWithTextField(
                                selectedValue: LocalStrings.noLeadFound.tr,
                                list: [LocalStrings.noLeadFound.tr]);
                          } else {
                            return const CustomLoader(isFullScreen: false);
                          }
                        }),
                  if (controller.proposalRelatedController.text == 'customer')
                    FutureBuilder(
                        future:
                            customersMemoizer.runOnce(controller.loadCustomers),
                        builder: (context, customerList) {
                          if (customerList.data?.status ?? false) {
                            return CustomDropDownTextField(
                              hintText: LocalStrings.selectClient.tr,
                              onChanged: (value) {
                                controller.clientController.text = value.userId;
                                //controller.clientNameController.text = value.company;
                                //controller.clientEmailController.text = value.email;
                              },
                              items:
                                  controller.customersModel.data!.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value.company ?? '',
                                    style: regularDefault.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color),
                                  ),
                                );
                              }).toList(),
                            );
                          } else if (customerList.data?.status == false) {
                            return CustomDropDownWithTextField(
                                selectedValue: LocalStrings.noClientFound.tr,
                                list: [LocalStrings.noClientFound.tr]);
                          } else {
                            return const CustomLoader(isFullScreen: false);
                          }
                        }),

                  CustomTextField(
                    labelText: LocalStrings.to.tr,
                    controller: controller.clientNameController,
                    focusNode: controller.clientNameFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.clientEmailFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterName.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),

                  CustomTextField(
                    labelText: LocalStrings.email.tr,
                    controller: controller.clientEmailController,
                    focusNode: controller.clientEmailFocusNode,
                    textInputType: TextInputType.text,
                    nextFocus: controller.clientFocusNode,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocalStrings.enterEmail.tr;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),

                  Row(
                    spacing: Dimensions.space5,
                    children: [
                      Expanded(
                        child: CustomDateFormField(
                          labelText: LocalStrings.date.tr,
                          onChanged: (DateTime? value) {
                            controller.dateController.text =
                                DateConverter.formatDate(value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomDateFormField(
                          labelText: LocalStrings.dueDate.tr,
                          onChanged: (DateTime? value) {
                            controller.openTillController.text =
                                DateConverter.formatDate(value!);
                          },
                        ),
                      ),
                    ],
                  ),

                  CustomDropDownTextField(
                    hintText: LocalStrings.selectStatus.tr,
                    onChanged: (value) {
                      controller.statusController.text = value;
                    },
                    selectedValue: controller.statusController.text,
                    items: controller.proposalStatus.entries
                        .map((MapEntry element) => DropdownMenuItem(
                              value: element.key,
                              child: Text(
                                element.value,
                                style: regularDefault.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                              ),
                            ))
                        .toList(),
                  ),

                  FutureBuilder(
                      future:
                          currenciesMemoizer.runOnce(controller.loadCurrencies),
                      builder: (context, currenciesList) {
                        if (currenciesList.data?.status ?? false) {
                          return CustomDropDownTextField(
                            hintText: LocalStrings.selectCurrency.tr,
                            onChanged: (value) {
                              controller.currencyController.text = value;
                            },
                            selectedValue: controller.currencyController.text,
                            items:
                                controller.currenciesModel.data!.map((value) {
                              return DropdownMenuItem(
                                value: value.id,
                                child: Text(
                                  value.name ?? '',
                                  style: regularDefault.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color),
                                ),
                              );
                            }).toList(),
                          );
                        } else if (currenciesList.data?.status == false) {
                          return CustomDropDownWithTextField(
                              selectedValue: LocalStrings.noCurrencyFound.tr,
                              list: [LocalStrings.noCurrencyFound.tr]);
                        } else {
                          return const CustomLoader(isFullScreen: false);
                        }
                      }),
                  // Items Section Start
                  Row(
                    children: [
                      Container(
                        width: Dimensions.space3,
                        height: Dimensions.space15,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: Dimensions.space5),
                      Text(
                        LocalStrings.items.tr,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              '${LocalStrings.showQuantityAs.tr}:',
                              style: lightSmall.copyWith(
                                  color: ColorResources.blueGreyColor),
                            ),
                            const SizedBox(width: Dimensions.space5),
                            const Icon(
                              Icons.circle,
                              size: Dimensions.space15,
                              color: ColorResources.blueGreyColor,
                            ),
                            Text(
                              ' ${LocalStrings.qty.tr}',
                              style: lightSmall.copyWith(
                                  color: ColorResources.blueGreyColor),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(Dimensions.space15),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorResources.blueGreyColor,
                        ),
                        borderRadius:
                            BorderRadius.circular(Dimensions.space10)),
                    child: Column(
                      spacing: Dimensions.space15,
                      children: [
                        CustomTextField(
                          labelText: LocalStrings.itemName.tr,
                          controller: controller.itemController,
                          focusNode: controller.itemFocusNode,
                          textInputType: TextInputType.text,
                          nextFocus: controller.descriptionFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocalStrings.enterItemName.tr;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            return;
                          },
                        ),
                        CustomTextField(
                          labelText: LocalStrings.description.tr,
                          textInputType: TextInputType.text,
                          controller: controller.descriptionController,
                          focusNode: controller.descriptionFocusNode,
                          nextFocus: controller.qtyFocusNode,
                          onChanged: (value) {
                            return;
                          },
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: CustomTextField(
                                labelText: LocalStrings.qty.tr,
                                textInputType: TextInputType.number,
                                controller: controller.qtyController,
                                focusNode: controller.qtyFocusNode,
                                nextFocus: controller.unitFocusNode,
                                onChanged: (value) {
                                  return;
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.space5),
                            Flexible(
                              flex: 2,
                              child: CustomTextField(
                                labelText: LocalStrings.unit.tr,
                                textInputType: TextInputType.text,
                                controller: controller.unitController,
                                focusNode: controller.unitFocusNode,
                                nextFocus: controller.rateFocusNode,
                                onChanged: (value) {
                                  return;
                                },
                              ),
                            ),
                          ],
                        ),
                        CustomTextField(
                          labelText: LocalStrings.rate.tr,
                          textInputType: TextInputType.number,
                          focusNode: controller.rateFocusNode,
                          controller: controller.rateController,
                          onChanged: (value) {
                            controller.calculateProposalAmount();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return LocalStrings.enterRate.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (controller.proposalItemList.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.proposalItemList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimensions.space15),
                      itemBuilder: (context, index) {
                        return Badge(
                          offset: const Offset(-10, -10),
                          backgroundColor: ColorResources.colorRed,
                          largeSize: Dimensions.space23,
                          label: GestureDetector(
                            onTap: () {
                              controller.decreaseItemField(index);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: ColorResources.colorRed,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.clear,
                                  color: ColorResources.colorWhite, size: 15),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(Dimensions.space15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorResources.blueGreyColor,
                                ),
                                borderRadius:
                                    BorderRadius.circular(Dimensions.space10)),
                            child: Column(
                              spacing: Dimensions.space15,
                              children: [
                                CustomTextField(
                                  labelText: LocalStrings.itemName.tr,
                                  controller: controller.proposalItemList[index]
                                      .itemNameController,
                                  textInputType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LocalStrings.enterItemName.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {
                                    return;
                                  },
                                ),
                                CustomTextField(
                                  labelText: LocalStrings.description.tr,
                                  textInputType: TextInputType.text,
                                  controller: controller.proposalItemList[index]
                                      .descriptionController,
                                  onChanged: (value) {
                                    return;
                                  },
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: CustomTextField(
                                        labelText: LocalStrings.qty.tr,
                                        textInputType: TextInputType.number,
                                        controller: controller
                                            .proposalItemList[index]
                                            .qtyController,
                                        onChanged: (value) {
                                          return;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.space5),
                                    Flexible(
                                      flex: 2,
                                      child: CustomTextField(
                                        labelText: LocalStrings.unit.tr,
                                        textInputType: TextInputType.text,
                                        controller: controller
                                            .proposalItemList[index]
                                            .unitController,
                                        onChanged: (value) {
                                          return;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  labelText: LocalStrings.rate.tr,
                                  textInputType: TextInputType.number,
                                  controller: controller
                                      .proposalItemList[index].rateController,
                                  onChanged: (value) {
                                    controller.calculateProposalAmount();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LocalStrings.enterRate.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  GestureDetector(
                    onTap: () => controller.increaseItemField(),
                    child: TextIcon(
                      text: LocalStrings.addItems.tr,
                      textStyle: regularDefault.copyWith(
                          color: ColorResources.secondaryColor),
                      alignment: MainAxisAlignment.center,
                      icon: Icons.add_circle_outline_rounded,
                      iconSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          GetBuilder<ProposalController>(builder: (controller) {
        return controller.isLoading
            ? const CustomLoader()
            : controller.isSubmitLoading
                ? const RoundedLoadingBtn()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.space10),
                    child: RoundedButton(
                      text: LocalStrings.submit.tr,
                      press: () {
                        controller.submitProposal();
                      },
                    ),
                  );
      }),
    );
  }
}
