import 'package:flutter/material.dart';
import 'package:pos_app/core/widget/custom_app_bar.dart';
import 'package:pos_app/generated/l10n.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: S.of(context).profile),
    );
  }
}
