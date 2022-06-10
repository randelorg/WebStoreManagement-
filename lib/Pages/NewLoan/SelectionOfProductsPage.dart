import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:web_store_management/Backend/TextMessage.dart';
import 'package:web_store_management/Notification/BannerNotif.dart';
import 'package:web_store_management/Pages/NewLoan/PaymentPlan.dart';
import '../../Helpers/FilePickerHelper.dart';
import '../../Backend/Utility/Mapping.dart';
import '../../Backend/GlobalController.dart';

class SelectionOfProductsPage extends StatefulWidget {
  final int? id;
  final String? barcode, itemCode;
  final String? firstname, lastname, number, address;
  final String? action;
  const SelectionOfProductsPage({
    Key? key,
    this.barcode,
    this.itemCode,
    this.id,
    this.action,
    this.firstname,
    this.lastname,
    this.number,
    this.address,
  }) : super(key: key);

  @override
  _SelectionOfProductsPage createState() => _SelectionOfProductsPage();

  final String appliance = 'Appliances';
  final String newLoan = 'new_loan';
  final String renewLoan = 'renew_loan';
}

class _SelectionOfProductsPage extends State<SelectionOfProductsPage> {
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final homeAddress = TextEditingController();
  //classess
  var pick = Picker();
  var image;
  //display selected file name
  String fileName = 'UPLOAD CONTRACT';

  var controller = GlobalController();
  late Future _products;
  int indexValue = 0;

  //for product details
  final barcode = TextEditingController();
  final productCode = TextEditingController();
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productType = TextEditingController();

  //for mobile verification
  final mobileNumberOtp = TextEditingController();
  final otp = TextEditingController();
  var sendMessOtp = TextMessage();

  bool successSentOtp = false, verified = false;
  String _verifyOtp = '', actionTaken = '';
  int counter = 0;
  int brwID = -1;

  bool checkOtp(int code) {
    if (code == int.parse(_verifyOtp)) return true;

    return false;
  }

  void setTextFields() {
    setState(() {
      firstname.text = widget.firstname.toString();
      lastname.text = widget.lastname.toString();
      homeAddress.text = widget.address.toString();
      mobileNumberOtp.text = widget.number.toString();
    });
  }

  @override
  void initState() {
    try {
      if (widget.action!.isNotEmpty) {
        setTextFields();
        actionTaken = widget.action.toString();
        brwID = widget.id!.toInt();
      }
    } catch (e) {
      actionTaken = widget.newLoan;
    }

    this._products = controller.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          width: (MediaQuery.of(context).size.width) / 4,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Step 1",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Text(
                  "BORROWER DETAILS",
                  style: TextStyle(fontFamily: 'Cairo_Bold', fontSize: 30),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    bottom: 6,
                    right: 6,
                    left: 6,
                  ), //add padding to the textfields
                  child: TextField(
                    controller: firstname,
                    decoration: InputDecoration(
                      hintText: 'Firstname',
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      labelStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.only(left: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: TextField(
                    controller: lastname,
                    decoration: InputDecoration(
                      hintText: 'Lastname',
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      labelStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.only(left: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: TextField(
                    controller: homeAddress,
                    decoration: InputDecoration(
                      hintText: 'Home Address',
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      labelStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.only(left: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: TextField(
                      controller: mobileNumberOtp,
                      maxLength: 12,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Mobile Number',
                        suffixIcon: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 15),
                          ),
                          child: Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: 15,
                              color: HexColor("#155293"),
                              fontFamily: 'Cairo_SemiBold',
                            ),
                          ),
                          onPressed: () {
                            if (mobileNumberOtp.text.isEmpty) {
                              BannerNotif.notif(
                                "Error",
                                "Please fill the mobile number field",
                                Colors.red.shade600,
                              );
                            } else {
                              if (mobileNumberOtp.text.isNotEmpty) {
                                _checkNumberifExisting(mobileNumberOtp.text)
                                    .then((value) {
                                  if (!value) {
                                    sendMessOtp
                                        .getOtp(mobileNumberOtp.text)
                                        .then((value) {
                                      if (value > 0) {
                                        setState(() {
                                          successSentOtp = true;
                                        });
                                        _verifyOtp = value.toString();
                                      } else {
                                        BannerNotif.notif(
                                          "Error",
                                          "Something went wrong please try again",
                                          Colors.red.shade600,
                                        );
                                      }
                                    });
                                  } else {
                                    BannerNotif.notif(
                                      "Existing",
                                      "Mobile number is existing or use in different application",
                                      Colors.red.shade600,
                                    );
                                  }
                                });
                              }
                            }
                          },
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey[50],
                        labelStyle: TextStyle(fontSize: 12),
                        contentPadding: EdgeInsets.only(left: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey.shade50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey.shade50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: successSentOtp,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: TextField(
                          controller: otp,
                          maxLength: 12,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Verification Code',
                            suffixIcon: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 15),
                                ),
                                child: Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: HexColor("#155293"),
                                    fontFamily: 'Cairo_SemiBold',
                                  ),
                                ),
                                onPressed: () {
                                  if (otp.text.isEmpty) {
                                    BannerNotif.notif(
                                      "Error",
                                      "Please fill the mobile number field",
                                      Colors.red.shade600,
                                    );
                                  } else {
                                    if (checkOtp(int.parse(otp.text))) {
                                      setState(() {
                                        //show done button
                                        verified = true;
                                        //hide otp widgets
                                        successSentOtp = false;

                                        BannerNotif.notif(
                                          'Verified number',
                                          'Can now proceed to the application',
                                          Colors.green.shade600,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        counter++;
                                      });

                                      //show snackbar that the otp is wrong
                                      BannerNotif.notif(
                                        'Try again',
                                        'Wrong OTP',
                                        Colors.red.shade600,
                                      );

                                      if (counter >= 3) {
                                        setState(() {
                                          successSentOtp = false;
                                        });
                                        //attempted to enter wrong OTP 3 times
                                        BannerNotif.notif(
                                          'WRONG OTP',
                                          'You enter wrong OTP for 3 times, try again in few minutes',
                                          Colors.red.shade600,
                                        );
                                      }
                                    }
                                  }
                                }),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                            labelStyle: TextStyle(fontSize: 12),
                            contentPadding: EdgeInsets.only(left: 15),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.attach_file, color: Colors.white),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Cairo_SemiBold',
                            ),
                          ),
                          label: Text(fileName),
                          onPressed: () {
                            //get the filename and display it
                            pick.pickFile().then((value) {
                              setState(() {
                                fileName = value;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(
          color: Colors.grey,
          thickness: 1,
          indent: 60,
          endIndent: 60,
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: actionTaken == widget.renewLoan ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: const Text(
                "Step 2",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                "SEARCH PRODUCT",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Cairo_Bold', fontSize: 30),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 15),
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: barcode,
                      decoration: InputDecoration(
                         suffixIcon: Icon(Icons.search_rounded),
                        hintText: 'Product Barcode',
                        filled: true,
                        fillColor: Colors.blueGrey[50],
                        labelStyle: TextStyle(fontSize: 10),
                        contentPadding: EdgeInsets.only(left: 10),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey.shade50),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueGrey.shade50),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor("#155293"),
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                                top: 18, bottom: 18, left: 36, right: 36),
                            primary: Colors.white,
                            textStyle: TextStyle(
                                fontFamily: 'Cairo_SemiBold', fontSize: 14),
                          ),
                          child: const Text('Search'),
                          onPressed: () async {
                            if (barcode.text.isEmpty) {
                              BannerNotif.notif(
                                  "Error",
                                  "Please fill the product barcode field",
                                  Colors.red.shade600);
                            } else {
                              _products.whenComplete(() {
                                if (!findProductBarcode(barcode.text)) {
                                  BannerNotif.notif(
                                    'NOT FOUND',
                                    'Product code is not exisiting or type is not a appliances',
                                    Colors.orange,
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //product information result
            productCardInfo()
          ],
        ),
      ],
    );
  }

  bool findProductBarcode(String barcode) {
    bool status = false;

    Mapping.productList
        .where((element) =>
            element.getProductCode == barcode &&
            element.getProdType == widget.appliance)
        .forEach((element) {
      setState(() {
        productCode.text = element.getProductCode;
        productName.text = element.getProductName;
        productPrice.text = element.getProductPrice.toString();
        productType.text = element.getProdType;

        status = true;
      });
    });

    return status;
  }

  Widget productCardInfo() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width) / 2.5,
      height: (MediaQuery.of(context).size.width) / 4,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                productCode.text,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                'Product Code',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ListTile(
              title: Text(
                productName.text,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                'Product name',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ListTile(
              title: Text(
                productPrice.text,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                'Product Price',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ListTile(
              title: Text(
                productType.text,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                'Product Type',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('DONE'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 18,
                      bottom: 18,
                      left: 36,
                      right: 36,
                    ),
                    primary: Colors.blue.shade400,
                    textStyle: TextStyle(
                      fontFamily: 'Cairo_SemiBold',
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (firstname.text.isEmpty ||
                        lastname.text.isEmpty ||
                        mobileNumberOtp.text.isEmpty ||
                        homeAddress.text.isEmpty ||
                        productPrice.text.isEmpty) {
                      BannerNotif.notif("Error", "Please fill all the fields",
                          Colors.red.shade600);
                    } else if (pick.image == null) {
                      BannerNotif.notif(
                          "Error",
                          "Please upload a file (jpg, png, jpeg)",
                          Colors.red.shade600);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PaymentPlanPage(
                            borrowerId: brwID,
                            action: actionTaken,
                            firstname: firstname.text,
                            lastname: lastname.text,
                            mobile: mobileNumberOtp.text,
                            address: homeAddress.text,
                            total: double.parse(productPrice.text),
                            contract: pick.getImageBytes(),
                            productCode: productCode.text,
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkNumberifExisting(String mobile) async {
    bool result = false;
    await sendMessOtp.checkBorrowerNumberIfExisting(mobile).then((value) {
      if (value) {
        if (actionTaken == widget.renewLoan)
          return result = false;
        else
          result = value;
      } else {
        result = value;
      }
    });

    return result;
  }
}
