import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:badges/badges.dart';
import 'package:moivoice/provider/auth_provider.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import 'package:moivoice/globals.dart' as globals;
import '../directPosts.dart';

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
                left: 10.0, bottom: 0.0, right: 10.0, top: 5.0),
            child: Column(children: [
              //profile content
              Visibility(
                visible: profileVisibility,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, bottom: 0.0, right: 10.0, top: 2.0),
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
                          size: Size.fromRadius(60),
                          child: Icon(Icons.person),
                        ),
                        badgeColor: Colors.green,
                        position: BadgePosition.bottomEnd(),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                      child: Row(children: [
                        Text("Name:  ${AuthProvider.userName}"),
                      ]),
                    ),
                    SizedBox(
                      height: 30.0,
                      child: Row(children: [
                        Text("Adm. No.:  ${AuthProvider.userAdmission}"),
                      ]),
                    ),
                    SizedBox(
                      height: 20.0,
                      child: Row(children: [
                        Text("Phone :  ${AuthProvider.userPhone.toString()}"),
                      ]),
                    ),
                    Text("Posts sent Directly to admin"),
                    SizedBox(
                      height: 600.0,
                      child: Expanded(
                        child: SingleChildScrollView(
                          child: Stack(
                            children: const <Widget>[directPosts()],
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
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
