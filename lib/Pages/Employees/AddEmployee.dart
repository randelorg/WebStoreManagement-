import 'package:flutter/material.dart';
import 'package:web_store_management/Notification/Snack_notification.dart';
import '../../Helpers/FilePicker_helper.dart';
import '../../Helpers/Hashing_helper.dart';
import '../../Backend/EmployeeOperation.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployee createState() => _AddEmployee();
}

class _AddEmployee extends State<AddEmployee> {
  //classess
  var pick = Picker();
  var hash = Hashing();
  var emp = EmployeeOperation();
  var image;

  //dipslay the image name
  String fileName = 'Select account image';
  //getting the text in the field
  final username = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final mobileNumber = TextEditingController();
  final homeAddress = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

//for dropdown list
  String collector = 'Collector';
  String storeAttendant = 'Store Attendant';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.all(20),
      title: Text(
        'Add Employee',
        softWrap: true,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
          color: Colors.blue,
          overflow: TextOverflow.fade,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: <Widget>[
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text('Select roll for the employee account'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Container(
                width: 320,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueGrey.shade50,
                    style: BorderStyle.solid,
                    width: 0.80,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: collector,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.blue.shade700),
                    onChanged: (value) {
                      setState(() {
                        collector = value!;
                      });
                    },
                    items: <String>['Collector', 'Store Attendant']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  labelStyle: TextStyle(fontSize: 10),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: 155,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: TextField(
                          controller: firstname,
                          decoration: InputDecoration(
                            hintText: 'Firstname',
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
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      width: 155,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: TextField(
                          controller: lastname,
                          decoration: InputDecoration(
                            hintText: 'Lastname',
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
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: mobileNumber,
                decoration: InputDecoration(
                  hintText: 'Mobile number',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  labelStyle: TextStyle(fontSize: 10),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: homeAddress,
                decoration: InputDecoration(
                  hintText: 'Home address',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  labelStyle: TextStyle(fontSize: 10),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  labelStyle: TextStyle(fontSize: 10),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: TextField(
                controller: confirmPassword,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    if (value.length > 0) {
                      if (value == password.text) {
                        error = 'Password match';
                      } else {
                        error = 'Password did not match';
                      }
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  filled: true,
                  fillColor: Colors.blueGrey[50],
                  labelStyle: TextStyle(fontSize: 10),
                  contentPadding: EdgeInsets.only(left: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey.shade50),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Text(
              error,
              style: TextStyle(fontSize: 10),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: TextButton.icon(
                onPressed: () {
                  pick.pickFile().then((value) {
                    setState(() {
                      fileName = value;
                    });
                  });
                },
                icon: Icon(Icons.file_upload),
                label: Text(fileName),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15, bottom: 15),
                            primary: Colors.white,
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            if (username.text.isEmpty) {
                              SnackNotification.notif(
                                'Error',
                                'Please supply all fields.',
                                Colors.red.shade600,
                              );
                            } else {
                              //creation of employee method
                              emp
                                  .createEmployeeAccount(
                                      collector.replaceAll(' ', '').toString(),
                                      firstname.text,
                                      lastname.text,
                                      mobileNumber.text,
                                      homeAddress.text,
                                      username.text,
                                      hash.encrypt(password.text),
                                      pick.getImageBytes())
                                  .then((value) {
                                if (value) {
                                  Navigator.pop(context);
                                  SnackNotification.notif(
                                    'Success',
                                    'Employee account is created',
                                    Colors.green.shade600,
                                  );
                                }
                              });
                            }
                          },
                          child: const Text('CONFIRM'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
