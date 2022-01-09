import 'package:web_store_management/Models/LoanedProductHistory_model.dart';
import 'package:web_store_management/Models/SelectedProducts_model.dart';
import '../../Models/PaymentHistory_model.dart';
import '../../Models/Admin_model.dart';
import '../../Models/Employee_model.dart';
import '../../Models/Product_model.dart';
import '../../Models/Borrower_model.dart';

class Mapping {
  //for identifying user role
  static String userRole = '';
  static List<AdminModel> adminList = [];
  static List<EmployeeModel> employeeList = [];
  static List<ProductModel> productList = [];
  static List<SelectedProductsModel> selectedProducts = [];
  static List<BorrowerModel> borrowerList = [];
  static List<PaymentHistoryModel> paymentList = [];
  static List<LoanedProductHistory> productHistoryList = [];
}
