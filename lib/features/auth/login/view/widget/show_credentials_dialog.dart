import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pos_app/core/helper/my_service_locator.dart';


import '../../../../../core/utils/app_font_style.dart';
import '../../../../../generated/l10n.dart';
import '../../manager/cubit/login_cubit.dart';

class CredentialsWidget extends StatelessWidget {
  const CredentialsWidget({super.key, required this.credentials, required this.loginCubit});
  final List credentials;
  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    return  BlocProvider.value(
      value:  loginCubit,

      child: AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),

        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        content:   BlocConsumer<LoginCubit, LoginState>(

      listener: (context, state) {


      },
      builder: (context, state) {
            return SizedBox(
              width: getResponsiveSize(context, size: 500),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                 ... credentials.map((e) => GestureDetector(
                   onTap: (){
                     loginCubit.onTapCredentials(e);
                     Navigator.pop(context);
                   },
                   child: Padding(
                     padding: const EdgeInsets.only(bottom: 10),
                     child: Container(
                       width: double.infinity,

                       padding: EdgeInsets.all(10),



                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey),
                         borderRadius: BorderRadius.circular(8)
                       ),
                         child: Row(
                           children: [
                             Icon(Icons.key,color: Colors.grey,),
                             SizedBox(width: 10,),
                             Column(
                               mainAxisSize: MainAxisSize.min,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [


                                 Text(e.split(":")[0],

                                 ),
                                 Text('**************'),
                               ],
                             ),
                           ],
                         )),
                   ),
                 )
                 )
                ],

              ),
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: () {
              loginCubit.showCredentials=false;
              Navigator.pop(context);
            },
            child: Text(S.of(context).cancel),
          ),
        ],

      ),
    );
  }
}

