import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_store_management/Backend/BorrowerOperation.dart';
import 'package:web_store_management/Backend/PurchasesOperation.dart';
import 'package:http/http.dart' as http;
import 'package:web_store_management/Backend/interfaces/ILoan.dart';
import 'dart:convert';
import 'dart:io';
import 'package:web_store_management/Notification/BannerNotif.dart';
import 'package:web_store_management/environment/Environment.dart';

class LoanOperation extends BorrowerOperation implements INewLoan {
  @override
  Future<bool> addBorrower(
    String barcode,
    String firstname,
    String lastname,
    String mobile,
    String homeaddress,
    num balance,
    Uint8List? contract,
    String plan,
    String term,
    String duedate,
  ) async {
    var response;
    bool status = false;
    var brwDetail = json.encode({
      'firstname': firstname.trim(),
      'lastname': lastname.trim(),
      'mobile': mobile.trim(),
      'address': homeaddress.trim(),
      'balance': balance,
      'contract': contract
    });

    try {
      await Environment.methodPost(
              "http://localhost:8090/api/addborrower", brwDetail)
          .then((value) {
        response = value;
      });

      //add loan
      await addNewLoan(barcode, firstname, lastname, plan, term, duedate)
          .then((value) => status = value);
      ;

      if (status) {
        //add investigation
        await addInvestigation(firstname, lastname);
      }

      //add the loan

      if (response.statusCode == 404) {
        return false;
      }

      if (response.statusCode == 202) {
        return true;
      }
    } catch (e) {
      e.toString();
      BannerNotif.notif(
        'Error',
        'Something went wrong while adding the borrower',
        Colors.redAccent.shade200,
      );
      return false;
    }

    //if status code is 202
    return true;
  }

  Future<bool> addInvestigation(String firstname, String lastname) async {
    var response;
    var brwDetail2 = json.encode({
      'firstname': firstname.trim(),
      'lastname': lastname.trim(),
    });

    try {
      await Environment.methodPost(
              "http://localhost:8090/api/addinvestigation", brwDetail2)
          .then((value) {
        response = value;
      });

      if (response.statusCode == 404) {
        return false;
      } else if (response.satusCode == 202) {
        return true;
      }
    } catch (e) {
      e.toString();
      BannerNotif.notif(
        'Error',
        'Something went wrong while adding the borrower',
        Colors.red.shade600,
      );
      return false;
    }

    //if status code is 202
    return true;
  }

  @override
  Future<bool> addNewLoan(String barcode, String firstname, String lastname,
      String plan, String term, String duedate) async {
    var response;
    final String unpaid = 'UNPAID';
    try {
      var payload = json.encode({
        "firstname": firstname,
        "lastname": lastname,
        "productCode": barcode,
        'plan': plan,
        'duedate': duedate,
        'term': term,
        'status': unpaid,
      });
      await Environment.methodPost("http://localhost:8090/api/addloan", payload)
          .then((value) {
        response = value;
      });

      if (response.statusCode == 202) {
        return true;
      }
    } catch (e) {
      e.toString();
      BannerNotif.notif(
        'Error',
        'Something went wrong while adding the loan',
        Colors.red.shade600,
      );
      return false;
    }

    return true;
  }

  Future<void> updateLoanProductItemId(int loanId, String productItemID) async {
    try {
      await http.get(
        Uri.parse(
          "http://localhost:8090/api/loanproductitem/$loanId/$productItemID",
        ),
        headers: {HttpHeaders.authorizationHeader: "${Environment.apiToken}"},
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<bool> approvedCredit(int investigationId, int borrowerId,
      String status, String? invoiceNumber) async {
    var x = PurchasesOperation();
    const String loan = 'LOAN';
    const String released = 'RELEASED';
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:8090/api/approved/${investigationId.toString()}/${borrowerId.toString()}/$status",
        ),
        headers: {HttpHeaders.authorizationHeader: "${Environment.apiToken}"},
      );

      if (status == released) {
        await x.customerPurchase(invoiceNumber.toString(), loan);
      }

      //if response is empty return false
      if (response.statusCode == 404) {
        return false;
      }

      if (response.statusCode == 202) {
        BannerNotif.notif(
          'Success',
          'Loan is now $status - Go now to Borrowers',
          Colors.green.shade600,
        );
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  @override
  Future<bool> updateBalanceAndContract(
      String barcode,
      num balance,
      int id,
      String firstname,
      String lastname,
      plan,
      term,
      dueDate,
      Uint8List? contract) async {
    var response, load;
    load = json.encode({
      "id": id,
      "balance": balance,
      "contract": contract,
    });
    try {
      await Environment.methodPost("http://localhost:8090/api/updatebal", load)
          .then((value) {
        response = value;
      });

      print(response.statusCode);

      //if response is empty return false
      if (response.statusCode == 404) {
        return false;
      } else {
        await addInvestigation(firstname, lastname);

        //add to new loan {renewal}
        await addNewLoan(barcode, firstname, lastname, plan, term, dueDate);
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
