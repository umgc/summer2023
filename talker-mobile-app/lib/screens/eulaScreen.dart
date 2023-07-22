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
              new Expanded(
                flex: 1,
                child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: new Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus mauris a diam maecenas sed enim ut sem viverra. Lorem donec massa sapien faucibus et molestie ac. Posuere morbi leo urna molestie. Lectus magna fringilla urna porttitor rhoncus dolor. Ullamcorper malesuada proin libero nunc consequat interdum varius sit. Dictum sit amet justo donec enim diam. Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Sed vulputate odio ut enim blandit volutpat. Pellentesque pulvinar pellentesque habitant morbi tristique senectus. Sit amet nulla facilisi morbi tempus. Risus in hendrerit gravida rutrum.\n\n"
                    "Sit amet venenatis urna cursus eget nunc scelerisque viverra. Ipsum suspendisse ultrices gravida dictum fusce ut placerat. Magna sit amet purus gravida. Maecenas volutpat blandit aliquam etiam erat. Tincidunt tortor aliquam nulla facilisi cras fermentum odio eu feugiat. Dictum sit amet justo donec enim. Non consectetur a erat nam at. Id semper risus in hendrerit gravida. Id semper risus in hendrerit gravida rutrum quisque non. Ut faucibus pulvinar elementum integer enim neque volutpat. Eu ultrices vitae auctor eu. Nisl tincidunt eget nullam non nisi est sit amet facilisis. Venenatis tellus in metus vulputate eu scelerisque. In ornare quam viverra orci sagittis eu volutpat. Blandit libero volutpat sed cras ornare arcu dui. Sed faucibus turpis in eu mi bibendum. Lectus sit amet est placerat in egestas erat imperdiet sed. Quisque egestas diam in arcu cursus euismod quis viverra nibh.\n\n"
                    "Sagittis id consectetur purus ut faucibus pulvinar elementum integer enim. Vulputate mi sit amet mauris commodo quis. Risus at ultrices mi tempus. Tellus at urna condimentum mattis pellentesque id. Quisque non tellus orci ac auctor augue mauris augue neque. A arcu cursus vitae congue mauris. Sed egestas egestas fringilla phasellus faucibus scelerisque eleifend. Morbi tincidunt ornare massa eget egestas purus. In tellus integer feugiat scelerisque varius morbi enim nunc. Nibh tellus molestie nunc non blandit massa enim. Bibendum enim facilisis gravida neque convallis a cras. Neque egestas congue quisque egestas diam in arcu. Ut tortor pretium viverra suspendisse potenti nullam ac tortor. Ultricies lacus sed turpis tincidunt. Nunc lobortis mattis aliquam faucibus purus in massa tempor. Id porta nibh venenatis cras sed felis eget.\n\n"
                    "Eu volutpat odio facilisis mauris. Aliquet bibendum enim facilisis gravida neque convallis a cras semper. Non odio euismod lacinia at. Nullam vehicula ipsum a arcu cursus vitae congue mauris rhoncus. Urna duis convallis convallis tellus id interdum velit laoreet id. Orci eu lobortis elementum nibh tellus molestie nunc non blandit. Amet mattis vulputate enim nulla aliquet. Enim eu turpis egestas pretium aenean. Nisl nunc mi ipsum faucibus vitae aliquet nec ullamcorper. Augue lacus viverra vitae congue eu consequat. Donec massa sapien faucibus et molestie ac. Mauris augue neque gravida in fermentum et sollicitudin ac orci.\n\n"
                    "Penatibus et magnis dis parturient montes nascetur ridiculus mus mauris. Pellentesque dignissim enim sit amet venenatis urna cursus. Blandit volutpat maecenas volutpat blandit. Vestibulum rhoncus est pellentesque elit ullamcorper. Aliquam faucibus purus in massa tempor nec. Lorem ipsum dolor sit amet consectetur adipiscing elit. Ac ut consequat semper viverra nam. Neque sodales ut etiam sit amet. Tellus cras adipiscing enim eu turpis egestas. Diam donec adipiscing tristique risus. Condimentum id venenatis a condimentum vitae. Tortor consequat id porta nibh venenatis cras sed. Nulla porttitor massa id neque aliquam vestibulum morbi. Quisque id diam vel quam elementum pulvinar etiam non quam. Pellentesque eu tincidunt tortor aliquam. In tellus integer feugiat scelerisque. Vel turpis nunc eget lorem dolor sed viverra ipsum. Velit egestas dui id ornare. Dui nunc mattis enim ut tellus.",
                    style:
                        TextStyle(color: Colors.white, fontSize: 20, height: 1.5),
                  )
                )
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
