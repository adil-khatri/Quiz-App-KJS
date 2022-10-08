import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_workers_app/screens/Complete_profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_workers_app/authentication/firebase_auth_service.dart';
import 'loginPage.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  // void initState() {
  //   // isBroker = false;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final isWorker = Provider.of<bool>(context);
    return SideDrawer(worker: isWorker);
  }
}

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

class SideDrawer extends StatefulWidget {
  final bool worker;
  SideDrawer({required this.worker});
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  var setdata;
  var email;
  var status;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user1 => _auth.currentUser;
  void initState() {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');
    users
        .doc(user1?.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      final newPet = (documentSnapshot.data() as Map<String, dynamic>);
      print(newPet["isWorker"]);
      setState(() {
        setdata = newPet["isWorker"];
        email = newPet["email"];
      });

      
      // if (newPet["status"]=="free") {
      //   isSelected = [true, false];
      // } else {
      //   isSelected = [false, true];
      //   // Fluttertoast.showToast(msg: "Sign in successful!");
      // }
    });
    final CollectionReference workers =
        FirebaseFirestore.instance.collection('Worker');
    workers
        .doc(user1?.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      final data = (documentSnapshot.data() as Map<String, dynamic>);
      print(data["status"]);
      setState(() {
        
        status = data["status"];
      });
      });
    super.initState();
  }

  Widget copyrightWidget() {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Text(
          "© Workers App - All rights reserved",
          style: TextStyle(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                String tc = "https://hasnain-sayyed.me/";
                launch(tc);
              },
              child: Text(
                "Terms & Conditions",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseAuthService>(context).currentUser();
    final authUser = Provider.of<FirebaseAuthService>(context).getCurrentUser();
    Widget _drawerNameWidget() {
      return user != null
          ? CircleAvatar(
              radius: 200,
              backgroundColor: Colors.white30,
              child: ClipOval(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        user.photoUrl ??
                            "https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805_960_720.png",
                      ),
                    ),
                  ),
                ),
              ),
            )
          : CircleAvatar(
              radius: 200,
              // backgroundColor: Colors.white,
              child: Image.asset("assets/images/splash.png"),
            );
    }

    return Drawer(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: _drawerNameWidget(),
            ),
            user != null
                ? Column(
                    children: [
                      DrawerLabel(
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        text: user.displayName ?? '',
                        email: user.email,
                        onTap: () {
                          Navigator.popAndPushNamed(context, "/myProfile");
                        },
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(
              height: 1,
              child: Container(color: Colors.white30),
            ),
            DrawerLabel(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              text: "Home",
              onTap: () {
                Navigator.popAndPushNamed(context, "/home");
              },
            ),
            // ignore: unrelated_type_equality_checks
            (status!="100"?
            ((setdata == true )

                ? DrawerLabel(
                    icon: Icon(
                      Icons.work,
                      color: Colors.white,
                    ),
                    text: "Complete Workers Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                               Complete_profile(email: email),
                          // Pass the arguments as part of the RouteSettings. The
                          // DetailScreen reads the arguments from these settings.
                        ),
                      );
                    },
                  )
                : SizedBox()):SizedBox()),
            user != null && widget.worker
                ? DrawerLabel(
                    icon: Icon(
                      Icons.people_alt_outlined,
                      color: Colors.white,
                    ),
                    text: "Exclusive Workers",
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/");
                    },
                  )
                : SizedBox(),
            DrawerLabel(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              text: "About us",
              onTap: () {
                Navigator.popAndPushNamed(context, "/about");
              },
            ),
            DrawerLabel(
              icon: Icon(
                Icons.mail_outline,
                color: Colors.white,
              ),
              text: "Contact us",
              onTap: () {
                Navigator.popAndPushNamed(context, "/contact");
              },
            ),
            SizedBox(
              height: 1,
              child: Container(color: Colors.white30),
            ),
            user != null
                ? DrawerLabel(
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
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 10),
                                    // ignore: deprecated_member_use
                                    child: FlatButton(
                                      child: Text("Yes"),
                                      onPressed: () {
                                        authUser.signOutUser();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/",
                                            (Route<dynamic> route) => false);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 10),
                                    // ignore: deprecated_member_use
                                    child: FlatButton(
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
                                  child: FlatButton(
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
                : DrawerLabel(
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    text: "Login / SignUp",
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
            SizedBox(
              height: 1,
              child: Container(color: Colors.white30),
            ),
            copyrightWidget(),
          ],
        ),
      ),
    );
  }
}
Footer
