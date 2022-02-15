import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:web_store_management/Backend/BorrowerOperation.dart';
import 'package:web_store_management/Backend/GlobalController.dart';
import 'package:web_store_management/Backend/Utility/Mapping.dart';
import 'package:web_store_management/Notification/Snack_notification.dart';
import 'package:web_store_management/Pages/RequestedProducts/ReqManualSearchBorrower.dart';

class RequestedProdScreen extends StatefulWidget {
  @override
  _RequestedProdScreen createState() => _RequestedProdScreen();
}

class _RequestedProdScreen extends State<RequestedProdScreen> {
  var controller = GlobalController();
  var borrower = BorrowerOperation();
  late Future _requested;
  final double textSize = 15;
  final double titleSize = 30;

  @override
  void initState() {
    super.initState();
    controller.fetchBorrowers();
    _requested = controller.fetchRequestedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [          
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor("#155293"),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          icon:
                              Icon(Icons.add_box_rounded, color: Colors.white),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            primary: Colors.white,
                            textStyle: TextStyle(
                                fontSize: 18, fontFamily: 'Cairo_SemiBold'),
                          ),
                          label: Text('NEW REQUEST'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReqManualBorrowerSearch();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15, right: 20),
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Request',
                      suffixIcon: InkWell(
                        child: IconButton(
                          icon: Icon(Icons.qr_code_scanner_outlined),
                          color: Colors.grey,
                          tooltip: 'Search by QR',
                          onPressed: () {},
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      labelStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.only(left: 30),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey.shade50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        FutureBuilder(
          future: _requested,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Fetching requested products',
                ),
              );
            }
            if (snapshot.hasData) {
              return Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  width: (MediaQuery.of(context).size.width),
                  height: (MediaQuery.of(context).size.height),
                  child: GridView.count(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    childAspectRatio: (MediaQuery.of(context).size.width) /
                        (MediaQuery.of(context).size.height) / 2.5,
                    children: _cards(),
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'No requested to show',
                ),
              );
            }
          },
        ),
      ],
    );
  }

  List<Widget> _cards() {
    return List.generate(
      Mapping.requested.length,
      (index) {
        return new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
          shadowColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    'PENDING',
                    style: TextStyle(fontSize: 30, fontFamily: 'Cairo_SemiBold')
                  ),
                  subtitle: Text(
                    'status',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                shadowColor: Colors.black,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 30),
                      child: Text(
                        'Requested \n Product',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Mapping.requested[index].getRequestedProductName,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 56),                        
                      child: Text(
                        'Name',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Mapping.requested[index].toString(),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Padding(
                     padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 46),
                      child: Text(
                        'Address',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Mapping.requested[index].getHomeAddress,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Padding(
                     padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 48),
                      child: Text(
                        'Number',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Mapping.requested[index].getMobileNumber,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Cairo_SemiBold',
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
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
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
                            primary: Colors.white,
                            textStyle: TextStyle(fontSize: 18, fontFamily: 'Cairo_SemiBold')
                          ),
                          child: const Text('IN-STORE'),
                          onPressed: () {
                            updatRequest(
                              Mapping.requested[index].getRequestId,
                              'IN-STORE',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    color: Colors.redAccent.shade400,
                    tooltip: 'DENY REQUEST',
                    onPressed: () {
                      updatRequest(
                        Mapping.requested[index].getRequestId,
                        'DENIED',
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void updatRequest(int id, final String status) {
    borrower.updateRequest(id, status).then((value) {
      if (!value) {
        SnackNotification.notif(
          'Error',
          'Something went wrong while updating the request',
          Colors.redAccent.shade200,
        );
      } else {
        setState(() {
          _requested = controller.fetchRequestedProducts();
        });
      }
    });
  }
}
