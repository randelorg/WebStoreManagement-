import 'package:web_store_management/Models/LoanedProductHistoryModel.dart';
import '../../Models/PaymentHistoryModel.dart';
import '../../Models/AdminModel.dart';
import '../../Models/EmployeeModel.dart';
import '../../Models/ProductModel.dart';
import '../../Models/BorrowerModel.dart';

class Mapping {
  //for identifying user role
  static String userRole = '';
  static List<AdminModel> adminList = [];
  static List<EmployeeModel> employeeList = [];
  static List<ProductModel> productList = [];
  static List<ProductModel> selectedProducts = [];
  static List<BorrowerModel> borrowerList = [];
  static List<BorrowerModel> creditApprovals = [];
  static List<PaymentHistoryModel> paymentList = [];
  static List<LoanedProductHistory> productHistoryList = [];
}
