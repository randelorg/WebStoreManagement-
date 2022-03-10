import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_store_management/Backend/EmployeeOperation.dart';
import 'package:web_store_management/Backend/GlobalController.dart';
import 'package:web_store_management/Backend/Session.dart';
import 'package:web_store_management/Backend/Utility/Mapping.dart';
import 'package:web_store_management/Notification/Snack_notification.dart';
import '../ViewProfile.dart';
import '../AddAccount.dart';
import '../UpdateProfile.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  _ProfileDrawer createState() => _ProfileDrawer();
}

class _ProfileDrawer extends State<ProfileDrawer> {
  var controller = GlobalController();
  var emp = EmployeeOperation();

  bool _isAuthorized = false;
  bool _isEmployee = true;

  String _getTodayDate() {
    var _formatter = new DateFormat('yyyy-MM-dd hh:mm:ss a');
    var _now = new DateTime.now();
    String formattedDate = _formatter.format(_now);
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    controller.fetchAllEmployees();
    if (Mapping.userRole == "Administrator") {
      setState(() {
        _isAuthorized = true;
        _isEmployee = false;
      });
    }
  }

  void timeIn(String id, String date) {
    emp.timeIn(id, date).then(
          (value) => SnackNotification.notif(
            'Success',
            'Time-in $date',
            Colors.green.shade900,
          ),
        );
  }

  void timeOut(String id, String date) {
    emp.timeOut(id, date).then(
          (value) => SnackNotification.notif(
            'Success',
            'Time-out $date',
            Colors.green.shade900,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "My Profile",
      offset: const Offset(0, 45.0),
      elevation: 2,
      child: Icon(Icons.person, color: HexColor("#155293")),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    child: Text(
                      'Profile Management',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 20),
                    child: TextButton.icon(
                      icon: Icon(
                        Icons.visibility,
                        color: HexColor("#155293"),
                      ),
                      label: Text(
                        'View Profile',
                        style: TextStyle(
                          fontFamily: 'Cairo_SemiBold',
                          color: HexColor("#155293"),
                        ),
                        softWrap: true,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ViewProfile();
                          },
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: this._isAuthorized,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 6),
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.create_rounded,
                              color: HexColor("#155293"),
                            ),
                            label: Text(
                              'Update Profile',
                              style: TextStyle(
                                fontFamily: 'Cairo_SemiBold',
                                color: HexColor("#155293"),
                              ),
                              softWrap: true,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return UpdateProfile();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 24),
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.person_add,
                              color: HexColor("#155293"),
                            ),
                            label: Text(
                              ' Add Admin',
                              style: TextStyle(
                                fontFamily: 'Cairo_SemiBold',
                                color: HexColor("#155293"),
                              ),
                              softWrap: true,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddAccount();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: this._isEmployee,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          child: Text(
                            'Attendance',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: Session.getTimeIn(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: snapshot.data == true,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 20),
                                  child: TextButton.icon(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    label: Text(
                                      'Time-in',
                                      style: TextStyle(
                                        fontFamily: 'Cairo_SemiBold',
                                        color: HexColor("#155293"),
                                      ),
                                      softWrap: true,
                                    ),
                                    onPressed: () {
                                      print("timeIn: " + _getTodayDate());
                                      timeIn(
                                        Mapping.employeeLogin[0].getEmployeeID,
                                        _getTodayDate(),
                                      );
                                      //set the time in button to invisible
                                      setState(() {
                                        //set the visbility to false -> timeIn
                                        Session.setTimeIn(false);
                                        Session.setTimeOut(true);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                ' ',
                              ),
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: Session.getTimeOut(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: snapshot.data == true,
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 13),
                                  child: TextButton.icon(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      'Time-out',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'Cairo_SemiBold',
                                        color: HexColor("#155293"),
                                      ),
                                      softWrap: true,
                                    ),
                                    onPressed: () {
                                      print("timeOut: " + _getTodayDate());
                                      timeOut(
                                        Mapping.employeeLogin[0].getEmployeeID,
                                        _getTodayDate(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                ' ',
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
