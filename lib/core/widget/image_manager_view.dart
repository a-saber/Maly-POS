import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_app/core/manager/image_manager/image_manager_cubit.dart';
import 'package:pos_app/core/manager/image_manager/image_manager_state.dart';
import 'package:pos_app/core/utils/app_colors.dart';
import 'package:pos_app/core/widget/custom_cach_network_image.dart';
import 'package:pos_app/generated/l10n.dart';

class ImageManagerView extends StatelessWidget {
  const ImageManagerView({
    super.key,
    this.selectedImageBuilder,
    this.unSelectedImageBuilder,
    required this.onSelected,
    this.imageUrl,
  });

  final String? imageUrl;
  final Widget Function(XFile image)? selectedImageBuilder;
  final Widget Function()? unSelectedImageBuilder;
  final void Function(XFile image) onSelected;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageManagerCubit(),
      child: BlocConsumer<ImageManagerCubit, ImageManagerState>(
        listener: (context, state) {
          if (state is ImageManagerSelectImage) {
            onSelected(state.image);
          }
        },
        builder: (context, state) {
          return InkWell(
              onTap: () {
                _showImageSourcePicker(context);
              },
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      if (state is ImageManagerSelectImage) {
                        if (selectedImageBuilder != null) {
                          return selectedImageBuilder!(state.image);
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: FileImage(File(state.image.path)),
                                  fit: BoxFit.fitHeight),
                            ),
                          );
                        }
                      } else {
                        if (unSelectedImageBuilder != null) {
                          return unSelectedImageBuilder!();
                        } else {
                          if (imageUrl != null) {
                            return CustomCachedNetworkImage(
                              borderRadius: BorderRadius.circular(15),
                              imageUrl: imageUrl!,
                              imageBuilder: (imageProvider) => Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fitHeight)),
                              ),
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.3,
                            );
                          }
                          return const Icon(
                            Icons.image,
                            size: 50,
                            color: AppColors.primary,
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(S.of(context).selectImage),
                ],
              ));
        },
      ),
    );
  }

  void _showImageSourcePicker(outerContext) {
    showModalBottomSheet(
      context: outerContext,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  ImageManagerCubit.get(outerContext)
                      .selectImage(source: ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  ImageManagerCubit.get(outerContext)
                      .selectImage(source: ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
