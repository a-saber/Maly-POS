import 'package:flutter/material.dart';

class PaymentMethodModel {
  final int id;
  final String name;
  final IconData icon;
  final String apiKey;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.apiKey,
  });
}
