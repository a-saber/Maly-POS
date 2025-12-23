import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/formate_date_time.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/features/shifts/data/model/shifts_model.dart';
import 'package:pos_app/generated/l10n.dart';

class CustomCardOfSomeDetailsofShift extends StatelessWidget {
  const CustomCardOfSomeDetailsofShift({
    super.key,
    required this.shift,
  });

  final ShiftData shift;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.shiftDetails,
            arguments: shift.id!,
          );
        },
        title: Text(
          "${S.of(context).shiftNumber}: ${shift.id}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "${S.of(context).startAt}: ${getLocalTimeFormate(shift.startAt ?? '-')}"),
            Text(
                "${S.of(context).endAt}: ${getLocalTimeFormate(shift.endAt ?? '-')}"),
            Text("${S.of(context).ordersCount}: ${shift.ordersCount ?? 0}"),
            Text("${S.of(context).branch}: ${shift.branch?.name ?? '-'}"),
            Text("${S.of(context).manager}: ${shift.user?.name ?? '-'}"),
          ],
        ),
      ),
    );
  }
}
