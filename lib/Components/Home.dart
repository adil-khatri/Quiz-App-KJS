import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app_kjs/Components/Authentication.dart';

class DrawerLabel extends StatefulWidget {
  final String text;
  final Icon icon;
  final void Function() onTap;
  final String? email;
  DrawerLabel(
      {required this.text,
      required this.icon,
      required this.onTap,
      this.email});

  @override
  _DrawerLabelState createState() => _DrawerLabelState();
}

class _DrawerLabelState extends State<DrawerLabel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            onTap: widget.onTap,
            leading: widget.icon,
            title: Text(
              widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz App'),
        ),
        drawer: Drawer(
          child: Material(
            color: Theme.of(context).primaryColor,
            child: ListView(padding: EdgeInsets.zero, children: [
              DrawerLabel(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                text: "Logout",
                onTap: () {
                  try {
                    
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Logout"),
                            content: Text("Do you really want to logout ?"),
                            actions: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                // ignore: deprecated_member_use
                                child: TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    _firebaseAuth.signOut();
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        "/", (Route<dynamic> route) => false);
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                // ignore: deprecated_member_use
                                child: TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          );
                        });
                  } catch (e) {
                    print(e);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Logout Error"),
                          content: Text(
                              "Some error occurred!\nYou are still Logged In"),
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              // ignore: deprecated_member_use
                              child: TextButton(
                                child: Text("Try Again"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              )
            ]),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Text('Hello World'),
              ),
            ],
          ),
        ));
  }
}
