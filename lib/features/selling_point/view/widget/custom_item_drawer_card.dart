import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/selling_point/data/model/product_selling_model.dart';
import 'package:pos_app/generated/l10n.dart';

import '../../../../core/helper/my_form_validators.dart';

import '../../../../core/widget/custom_form_field.dart';

class CustomItemDrawerCard extends StatefulWidget {
  const CustomItemDrawerCard({
    super.key,
    this.onTapAdd,
    this.onTapRemove,
    this.onTapDelete,
    required this.product,
    this.onChangePrice,
    this.onToggleShowEditPrice,
    this.onTapQuantity,
  });
  final ProductSellingModel product;
  final void Function()? onTapAdd;
  final void Function()? onTapRemove;
  final void Function()? onTapDelete;
  final VoidCallback? onChangePrice;
  final VoidCallback? onToggleShowEditPrice;
  final VoidCallback? onTapQuantity;

  @override
  State<CustomItemDrawerCard> createState() => _CustomItemDrawerCardState();
}

class _CustomItemDrawerCardState extends State<CustomItemDrawerCard> {
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CustomCachedNetworkImage(
                    imageUrl: widget.product.product.imageUrl,
                    borderRadius: BorderRadius.circular(15),
                    imageBuilder: (imageProvider) => Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.product.product.name ?? S.of(context).noName} ${widget.product.productUnit?.unit?.name ?? ''}',
                          style: AppFontStyle.itemsSubTitle(
                            context: context,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: 150,
                          child: Form(
                            key: widget.product.formKey,
                            child: CustomFormField(
                                controller: widget.product.priceController,
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    MyFormValidators.validateDoublePrice(
                                      value,
                                      context: context,
                                      haveMin: true,
                                      min: widget.product.minPrice,
                                    ),
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false)
                                    _debounce!.cancel();

                                  _debounce = Timer(
                                      const Duration(milliseconds: 600), () {
                                    widget.onChangePrice?.call();
                                  });

                                  // Future.delayed(Duration(milliseconds: 500)).then((value){
                                  //
                                  //
                                  // });
                                }),
                          ),
                        ),
                        /* InputQty.int(
                           initVal: 1,
                            qtyFormProps: QtyFormProps(
                              controller: widget.product.qtyController,),
                            onQtyChanged: (value){
                              widget.product.count=value;
                            },
                            decoration: QtyDecorationProps(
                              borderShape: BorderShapeBtn.circle,
                              btnColor: Colors.blue,
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none),
                              fillColor: Colors.grey[200],

                              plusBtn:   InkWell(
                                onTap: widget.onTapAdd,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ) ,
                              minusBtn: InkWell(
                                onTap: widget.onTapRemove,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ) ,
                              isBordered: true
                          ),
                        )*/
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue,
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: InkWell(
                          onTap: widget.onTapQuantity,
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${widget.product.count}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                (widget.product.currentPriceWithTax).toStringAsFixed(2),
                style: AppFontStyle.itemsSubTitle(
                  context: context,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    InkWell(
                      onTap: widget.onTapAdd,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onTapRemove,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional.center,
              child: InkWell(
                onTap: widget.onTapDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
              ),
            ))
          ],
        ),
        /* if(product.showEditPrice)...
        [
        const SizedBox(
          height: 10,
        ),
        Row(

          children: [
            Expanded(
              flex: 3,


              child: LayoutBuilder(
                  builder: (context, constraints) {
                  return Form(
                  //  key: product.formKey,
                    child: CustomFormField(
                      controller: product.priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) => MyFormValidators.validateDoublePrice(
                        value,
                        context: context,
                        haveMin: true,
                        min: product.minPrice,
                      ),
                    ),
                  );
                }
              ),
            ),
            // CustomTextBtn(
            //   text: "Save",
            //   textColor: AppColors.primary,
            //   onPressed: (){
            //
            //       // Defer setState to after the current frame
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //
            //           onChangePrice!();
            //
            //       });
            //
            //   },
            // ),
           const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: (){

                  // Defer setState to after the current frame
                  WidgetsBinding.instance.addPostFrameCallback((_) {

                    onChangePrice!();

                  });

                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    border:
                    Border.all(color: AppColors.success, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    S.of(context).save,
                    textAlign: TextAlign.center,
                    style: AppFontStyle.itemsSubTitle(
                      context: context,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        )
        ],*/
      ],
    );
  }
}
