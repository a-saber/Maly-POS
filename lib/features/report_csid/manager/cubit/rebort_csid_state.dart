

import 'package:flutter/cupertino.dart';

@immutable
sealed class ReportScidState {}

final class ReportScidInitial extends ReportScidState {}
final class ReportScidSelectUserName extends ReportScidState {}
final class ReportScidSelectInvoiceType extends ReportScidState {}
final class ReportScidSelectCsidType extends ReportScidState {}
final class ReportScidSelectDate extends ReportScidState {}


