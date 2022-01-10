import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_store_management/Backend/Interfaces/IBorrower.dart';
import 'package:web_store_management/Backend/Interfaces/IPay.dart';
import 'package:web_store_management/Backend/Utility/Mapping.dart';
import 'package:web_store_management/Notification/Snack_notification.dart';
import 'Login_operation.dart';

class BorrowerOperation extends Login implements IBorrower, IPay {
  @override
  Future<bool> addBorrower(String firstname, String lastname, String mobile,
      String homeaddress, num balance) async {
    String id = '7';
    var borrower = json.encode({
      'id': id,
      'firstname': firstname.trim(),
      'lastname': lastname.trim(),
      'mobile': mobile.trim(),
      'address': homeaddress.trim(),
      'balance': balance,
    });

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8090/api/addborrower"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: borrower,
      );

      if (response.statusCode == 404) return false;
    } catch (e) {
      e.toString();
      SnackNotification.notif(
        'Error',
        'Something went wrong while adding the borrower',
        Colors.redAccent.shade200,
      );
      return false;
    }

    //if status code is 202
    return true;
  }

  @override
  Future<bool> addNewLoan(String firstname, String lastname, String plan,
      String term, String duedate) async {
    for (var item in Mapping.selectedProducts) {
      try {
        await http.post(
          Uri.parse("http://localhost:8090/api/addloan"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: json.encode({
            'firstname': firstname,
            'lastname': lastname,
            'productCode': item.getProductCode,
            'plan': plan,
            'duedate': duedate,
            'term': term,
            'qty': item.getProductQty,
            'status': 'PENDING',
          }),
        );
      } catch (e) {
        print('EREOR');
        e.toString();
        SnackNotification.notif(
          'Error',
          'Something went wrong while adding the loan',
          Colors.redAccent.shade200,
        );
        return false;
      }
    }

    return true;
  }

  @override
  Future<bool> updateBorrower(int id, String firstname, String lastname,
      String mobile, String address) async {
    var borrowerUpdateLoad = json.encode({
      'id': id,
      'firstname': firstname.trim(),
      'lastname': lastname.trim(),
      'mobile': mobile.trim(),
      'address': address.trim()
    });

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8090/api/borrower"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: borrowerUpdateLoad,
      );

      if (response.statusCode == 404) return false;
    } catch (e) {
      e.toString();
      SnackNotification.notif(
        'Error',
        'Something went wrong while updating the borrower',
        Colors.redAccent.shade200,
      );
      return false;
    }

    //if status code is 202
    return true;
  }

  @override
  Future<bool> makePayment(int id, double payment, String date) async {
    var paymentLoad = json.encode(
        {'BorrowerID': id, 'CollectionAmount': payment, 'GivenDate': date});

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8090/api/payment"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: paymentLoad,
      );

      if (response.statusCode == 404) return false;
    } catch (e) {
      e.toString();
      SnackNotification.notif(
        'Error',
        'Something went wrong while fetching borrowers',
        Colors.redAccent.shade200,
      );
      return false;
    }

    //if status code is 202
    return true;
  }

  @override
  bool removeBorrower() {
    throw UnimplementedError();
  }
}
