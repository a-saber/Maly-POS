import 'dart:math';

class Decimal {
  final BigInt value;
  final int scale;

  Decimal(this.value, this.scale);

  factory Decimal.parse(String input) {
    final neg = input.startsWith('-');
    final s = neg ? input.substring(1) : input;

    if (!s.contains(".")) {
      final v = BigInt.parse(s);
      return Decimal(neg ? -v : v, 0);
    }

    final parts = s.split(".");
    final whole = parts[0];
    final frac = parts[1];

    final combined = BigInt.parse(whole + frac);
    return Decimal(neg ? -combined : combined, frac.length);
  }
  Decimal operator +(Decimal other) {
    final int maxScale = max(scale, other.scale);
    final BigInt v1 = value * BigInt.from(10).pow(maxScale - scale);
    final BigInt v2 = other.value * BigInt.from(10).pow(maxScale - other.scale);
    return Decimal(v1 + v2, maxScale);
  }

  Decimal operator *(Decimal other) {
    return Decimal(value * other.value, scale + other.scale);
  }

  Decimal operator /(Decimal other) {
    final int precision = 10;
    final BigInt factor = BigInt.from(10).pow(precision + other.scale - scale);
    final BigInt numerator = value * factor;
    final BigInt result = numerator ~/ other.value;
    return Decimal(result, precision);
  }

  Decimal roundTo(int newScale) {
    if (newScale >= scale) {
      final diff = newScale - scale;
      return Decimal(value * BigInt.from(10).pow(diff), newScale);
    }

    final diff = scale - newScale;
    final BigInt divisor = BigInt.from(10).pow(diff);
    final BigInt quotient = value ~/ divisor;
    final BigInt remainder = (value.abs()) % divisor;
    final BigInt half = divisor ~/ BigInt.from(2);

    BigInt roundedQuotient = quotient;
    if (remainder >= half) {
      // handle negative numbers correctly
      if (value >= BigInt.zero)
        roundedQuotient += BigInt.one;
      else
        roundedQuotient -= BigInt.one;
    }

    return Decimal(roundedQuotient, newScale);
  }

  @override
  String toString() {
    final neg = value.isNegative;
    final absValue = value.abs();
    final s = absValue.toString().padLeft(scale + 1, '0');
    final pos = s.length - scale;
    final res = s.substring(0, pos) + "." + s.substring(pos);
    return neg ? "-$res" : res;
  }
}

class DecimalHelper {
  static const int scale = 10;

  static Decimal add(String a, String b) {
    return (Decimal.parse(a) + Decimal.parse(b)).roundTo(scale);
  }

  static Decimal multiply(String a, String b) {
    return (Decimal.parse(a) * Decimal.parse(b)).roundTo(scale);
  }

  static Decimal divide(String a, String b) {
    return (Decimal.parse(a) / Decimal.parse(b)).roundTo(scale);
  }
}
