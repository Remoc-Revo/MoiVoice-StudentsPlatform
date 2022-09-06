import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:badges/badges.dart';
import 'package:moivoice/provider/auth_provider.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import 'package:moivoice/globals.dart' as globals;

var isAnonymous = false;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static bool isSwitched = false;
  static var anonymousDefinitionVisibility = false;
  static var profileVisibility = true;

  @override
  Widget build(BuildContext context) {
    print("userAdmission :${AuthProvider.userAdmission}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.backgroundColor,
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 30,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'home',
            color: globals.TextIconColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MyHomePage(title: 'MoiVoice');
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'profile',
            color: Colors.green,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ProfilePage(title: 'MoiVoice');
              }));
            },
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: globals.backgroundColor),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 50.0, bottom: 0.0, right: 50.0, top: 50.0),
            child: Column(children: [
              //description of anonymous mode
              Visibility(
                visible: anonymousDefinitionVisibility,
                child: Column(
                  children: [
                    Material(
                      shape: CircleBorder(),
                      color: Colors.white,
                      child: Image.asset("../../assets/img/anonymous.png"),
                    ),
                    Text(
                      '''\n\n\nYou are anonymous, your comments and posts can't be traced back to you.You can :\n~post anaonymously\n~comment anonymously

                          ''',
                      style: TextStyle(
                        color: globals.TextIconColor,
                      ),
                    ),
                  ],
                ),
              ),
              //profile content
              Visibility(
                visible: profileVisibility,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, bottom: 0.0, right: 10.0, top: 50.0),
                  child: Column(children: [
                    Material(
                      shape: CircleBorder(),
                      color: Colors.grey,
                      child: Badge(
                        badgeContent: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.photo_camera),
                        ),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(80),
                          child: Icon(Icons.person),
                        ),
                        badgeColor: Colors.green,
                        position: BadgePosition.bottomEnd(),
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                      child: Row(children: [
                        Text("Name:  ${AuthProvider.userName}"),
                      ]),
                    ),
                    SizedBox(
                      height: 70.0,
                      child: Row(children: [
                        Text("Adm. No.:  ${AuthProvider.userAdmission}"),
                      ]),
                    ),
                    SizedBox(
                      height: 70.0,
                      child: Row(children: [
                        Text("Phone :  ${AuthProvider.userPhone.toString()}"),
                      ]),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(children: [
                  Text(
                    "Turn Anonymous mode",
                    style: TextStyle(
                      color: globals.TextIconColor,
                    ),
                  ),
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        if (isSwitched == true) {
                          anonymousDefinitionVisibility = true;
                          profileVisibility = false;
                          globals.backgroundColor = Colors.black;
                          globals.TextIconColor = Colors.white;
                          isAnonymous = true;
                        } else {
                          globals.backgroundColor = Colors.white;
                          anonymousDefinitionVisibility = false;
                          profileVisibility = true;
                          globals.TextIconColor = Colors.black;
                          isAnonymous = false;
                        }
                      });
                    },
                    activeColor: globals.TextIconColor,
                  ),
                ]),
              )
            ]),
          )
        ]),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          //GetStorage box = GetStorage();
          //box.remove('email');
          AuthProvider.signin_authMessage = '';
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        },
        icon: const Icon(Icons.logout),
        tooltip: 'logout',
      ),
    );
  }
}
