import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EulaScreen extends StatefulWidget {
  const EulaScreen({Key? key}) : super(key: key);

  @override
  State<EulaScreen> createState() => _EulaScreenState();
}

class _EulaScreenState extends State<EulaScreen> {
  var prefs;

  @override
  void initState() {
    super.initState();
    _getFirstLoadSetting();
  }

  Future<void> _getFirstLoadSetting() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<bool> _onBackPressed() async {
    var agreedToEula = prefs.getBool('agreedToEula');
    if (agreedToEula != null && agreedToEula == true) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("ConvoBuddy"),
            centerTitle: true,
            backgroundColor: Colors.black),
        body: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            key: const Key('colEULA'),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Lorem ipsum dolor sit amet, "
                "consectetur adipiscing elit, "
                "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
                "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
                "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                style:
                    TextStyle(color: Colors.white, fontSize: 20, height: 1.5),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: TextButton(
                      key: const Key('btnDisagree'),
                      onPressed: () async {
                        prefs.setBool('agreedToEula', false);
                        SystemNavigator.pop();
                      },
                      style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(
                              width: 1, color: Color(0xFF8900F8)),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      child: const Text(
                        'Disagree',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF8900F8)),
                      ),
                    ),
                  ),
                  TextButton(
                    key: const Key('btnAgree'),
                    onPressed: () async {
                      prefs.setBool('agreedToEula', true);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFF8900F8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    child: const Text(
                      'Agree',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
