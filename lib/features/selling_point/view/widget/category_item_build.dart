import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/utils/app_font_style.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/generated/l10n.dart';
import 'package:redacted/redacted.dart';

class CategoryItemBuild extends StatelessWidget {
  const CategoryItemBuild({
    super.key,
    required this.category,
  });
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SellingPointCubit.get(context).changeCategorytId(
          id: category.id,
        );
      },
      child: BlocBuilder<SellingPointCubit, SellingPointState>(
        builder: (context, state) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: category.id != -1 ? 10 : 15,
                horizontal: category.id != -1 ? 15 : 25,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color:
                      category.id == SellingPointCubit.get(context).categoryId
                          ? AppColors.black
                          : AppColors.grey,
                ),
              ),
              child: Row(
                children: [
                  category.id != -1
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8.0),
                          child: CustomCachedNetworkImage(
                            imageUrl: category.imageUrl,
                            borderRadius: BorderRadius.circular(15),
                            imageBuilder: (imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover)),
                            ),
                            width: 30,
                            height: 30,
                          ),
                        )
                      : SizedBox(),
                  Text(
                    category.name ?? S.of(context).noName,
                    style: AppFontStyle.itemssmallTitle(
                      context: context,
                      fontWeight: FontWeight.w600,
                      color: category.id ==
                              SellingPointCubit.get(context).categoryId
                          ? AppColors.black
                          : AppColors.grey,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryItemBuildLoading extends StatelessWidget {
  const CategoryItemBuildLoading({super.key, required this.index});

  final int index;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: index != 0 ? 10 : 15,
          horizontal: index != 0 ? 15 : 25,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.grey),
        ),
        // alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            index != 0
                ? Container(
                    color: AppColors.grey,
                    width: 30,
                    height: 30,
                  ).redacted(
                    context: context,
                    redact: true,
                    configuration: RedactedConfiguration(
                      animationDuration:
                          const Duration(milliseconds: 800), //default
                    ),
                  )
                : SizedBox(),
            index != 0
                ? const SizedBox(
                    width: 5,
                  )
                : const SizedBox(),
            Container(
              color: Colors.grey,
              width: 30,
              height: 15,
            ).redacted(
              context: context,
              redact: true,
              configuration: RedactedConfiguration(
                animationDuration: const Duration(milliseconds: 800), //default
              ),
            ),
          ],
        ),
      ),
    );
  }
}
