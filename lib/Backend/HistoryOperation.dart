import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_store_management/Models/LoanedProductHistory_model.dart';
import 'package:web_store_management/Models/PaymentHistory_model.dart';
import 'package:web_store_management/Notification/Snack_notification.dart';
import 'Interfaces/IHistory.dart';
import '../Backend/Utility/Mapping.dart';

class HistoryOperation implements IHistory {
  @override
  Future<int> viewLoanHistory(String borrowerId) async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:8090/api/loanedproducts/' + borrowerId));

      final parsed =
          await jsonDecode(response.body).cast<Map<String, dynamic>>();
      Mapping.productHistoryList = parsed
          .map<LoanedProductHistory>(
              (json) => LoanedProductHistory.fromJson(json))
          .toList();

      if (response.statusCode == 404) {
        SnackNotification.notif(
            'Error', 'Cant fetch loaned product history', Colors.red.shade600);
        return -1;
      }

      return 1;
    } catch (e) {
      print(e.toString());
      SnackNotification.notif(
          'Error', 'Cant fetch loaned product history', Colors.red.shade600);
      return -1;
    }
  }

  @override
  Future<int> viewPaymentHistory(String borrowerId) async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8090/api/payment/' + borrowerId));

      final parsed =
          await jsonDecode(response.body).cast<Map<String, dynamic>>();
      Mapping.paymentList = parsed
          .map<PaymentHistoryModel>(
              (json) => PaymentHistoryModel.fromJson(json))
          .toList();

      if (response.statusCode == 404) {
        SnackNotification.notif(
            'Error', 'There is history of this borrower', Colors.red.shade600);
        return -1;
      }

      return 1;
    } catch (e) {
      print(e.toString());
      SnackNotification.notif(
          'Error', 'Cant fetch payment history', Colors.red.shade600);
      return -1;
    }
  }
}