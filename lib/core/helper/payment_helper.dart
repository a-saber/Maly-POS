
import 'package:nearpay_flutter_sdk/errors/purchase_error/purchase_error.dart';
import 'package:nearpay_flutter_sdk/errors/reconcile_error/reconcile_error.dart';
import 'package:nearpay_flutter_sdk/errors/refund_error/refund_error.dart';
import 'package:nearpay_flutter_sdk/errors/reverse_error/reversal_error.dart';
import 'package:nearpay_flutter_sdk/nearpay.dart';
import 'package:nearpay_flutter_sdk/util/util.dart';
import 'package:uuid/uuid.dart';

class PaymentHelper {
  static late final Nearpay nearpay;
  static const String authEmail = "engazat.@gmail.com"; // Change if needed

  // Initialize NearPay authentication
  static Future<void> initialize() async {
    print("^^^^^^^^^^^^ init");
    nearpay = Nearpay(
      authType: AuthenticationType.email,
      authValue: authEmail,
      env: Environments.sandbox, // Change to Environments.production when going live
      locale: Locale.localeDefault,
    );

    try {
      var response = await nearpay.initialize();
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^ NearPay Initialized Successfully\n${response.toString()}");
    } catch (e) {
      print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ NearPay Initialization Failed: $e");
    }
  }

  // Process a purchase transaction
  static Future<String> addTransaction({ required double amount}) async
  {
    try {
      var response = await nearpay.purchase(
        amount: (amount * 100).round(), // 14.55 SAR (amount in cents)
        transactionId: const Uuid().v4(), // Unique transaction ID
        //customerReferenceNumber: transactionId, // Custom reference number
        enableReceiptUi: true,
        enableReversalUi: true,
        enableUiDismiss: true,
        finishTimeout: 60,
      );

      print("^^^^^^^^^^^^^^^^^^^ Transaction Successful: ${response.toJson()}");
      print(response.receipts!.first.transaction_uuid);
      return response.receipts!.first.transaction_uuid;
    } catch (error) {
      String errorMSG;
      print("^^^^^^^^^^^^ Error transaction: $error");
      if (error is PurchaseAuthenticationFailed) {
        errorMSG ="Error Authentication Failed: ${error.message}";
      } else if (error is PurchaseGeneralFailure) {
        errorMSG ="Error General Failure: ${error.toString()}";
      } else if (error is PurchaseInvalidStatus) {
        errorMSG ="Error Invalid Status: ${error.toString()}";
      } else if (error is PurchaseDeclined) {
        errorMSG ="Error Payment Declined: ${error.toString()}";
      } else if (error is PurchaseRejected) {
        errorMSG ="Error Purchase Rejected: ${error.message}";
      } else {
        errorMSG ="Unexpected Error: $error";
      }
      print(errorMSG);
     return errorMSG;
    }
  }

  // Process a refund transaction
  static Future<void> refundTransaction({required String originalTransactionUUID, required String transactionId, required int amount}) async
  {
    nearpay.refund(
      amount: amount*100, // [Required], means 10.00
      originalTransactionUUID: originalTransactionUUID, // [Required] the orginal trnasaction uuid that you want to refund
      transactionId: transactionId, //[Optional] speacify the transaction uuid
      //customerReferenceNumber: '', //[Optional]
      enableReceiptUi: true, // [Optional] show the reciept in ui
      enableReversalUi: true, //[Optional] enable reversal of transaction from ui
      editableRefundUI: true, // [Optional] edit the reversal amount from uid
      enableUiDismiss: true, //[Optional] the ui is dimissible
      finishTimeout: 60, //[Optional] finish timeout in seconds
      //adminPin: '0000', // [Optional] when you add the admin pin here , the UI for admin pin won't be shown.
    ).then((response) {
      printJson(response.toJson());
    }).catchError((error) {
      if(error is RefundAuthenticationFailed) {
        // when the authentication failed .
      } else if (error is RefundGeneralFailure) {
        // Handle general failure
      } else if (error is RefundInvalidStatus) {
        // Handle invalid status
      } else if(error is RefundDeclined) {
        // when the refund is declined.
      } else if(error is RefundRejected) {
        // when the refund is rejected
      }
    });

  }

  // Process a reverse transaction
  static Future<void> reverseTransaction({required String originalTransactionUUID}) async
  {
    nearpay.reverse(
      originalTransactionUUID: originalTransactionUUID, // [Required] the orginal trnasaction uuid that you want to reverse
      enableReceiptUi: true, // [Optional] show the reciept in ui
      enableUiDismiss: true, //[Optional] the ui is dimissible
      finishTimeout: 60, //[Optional] finish timeout in seconds
    ).then((response) {
      printJson(response.toJson());
    }).catchError((error) {
      if(error is ReversalAuthenticationFailed) {
        // when the authentication failed .
      } else if (error is ReversalGeneralFailure) {
        // Handle general failure
      } else if(error is ReversalFailureMessage) {
        // when there is FailureMessage
      } else if (error is ReversalInvalidStatus) {
        // Handle invalid status
      }
    });

  }

  // Process a reconcile transaction
  static Future<void> reconcileTransaction({required String originalTransactionUUID}) async
  {
    nearpay.reconcile(
      reconciliationId: originalTransactionUUID,
      enableReceiptUi: true, // [Optional] show the reciept in ui
      enableUiDismiss: true, //[Optional] the ui is dimissible
      finishTimeout: 60, //[Optional] finish timeout in seconds
      adminPin: '0000', // [optional] when you add the admin pin here , the UI for admin pin won't be shown.
    ).then((response) {
      printJson(response.toJson());
    }).catchError((error) {
      if(error is ReconcileAuthenticationFailed) {
        // when the authentication failed .
      } else if (error is ReconcileGeneralFailure) {
        // Handle general failure
      } else if(error is ReconcileFailureMessage) {
        // when there is FailureMessage
      } else if (error is ReconcileInvalidStatus) {
        // Handle invalid status
      }
    });


  }
}
