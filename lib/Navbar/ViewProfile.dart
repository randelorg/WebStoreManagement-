import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatelessWidget {
  const ViewProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: <Widget>[
        Column(children: [
          Icon(
            Icons.account_circle,
            size: 200,
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Update Profile',
              style: TextStyle(
                fontSize: 10,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            shadowColor: Colors.black,
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 60),
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  'Michael Jacinto',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            shadowColor: Colors.black,
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 50),
                  child: Text(
                    'User Level',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            shadowColor: Colors.black,
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 20),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Change Password',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                Text('***********'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
                          left: 30, right: 30, top: 20, bottom: 20),
                      primary: Colors.white,
                      textStyle: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {},
                    child: const Text('Add Account'),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
