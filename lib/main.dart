import 'package:WellfareZone/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:WellfareZone/firebase_options.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Configure the initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // ignore: prefer_const_declarations
  final InitializationSettings initializationSettings =
      const InitializationSettings(android: initializationSettingsAndroid);

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp(flutterLocalNotificationsPlugin));
}

class MyApp extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const MyApp(this.flutterLocalNotificationsPlugin, {super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IoT",
      debugShowMaterialGrid: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.greenAccent[700],
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  final Query humi = FirebaseDatabase.instance.ref().child('Humidity');
  final Query temp = FirebaseDatabase.instance.ref().child('Temperature');
  final Query smoke = FirebaseDatabase.instance.ref().child('Smoke');
  final Query gas = FirebaseDatabase.instance.ref().child('LPG');
  final Query co = FirebaseDatabase.instance.ref().child('CO');
  final Query alert = FirebaseDatabase.instance.ref().child('Level');
  final databaseReference = FirebaseDatabase.instance.reference();
  final TextEditingController textController = TextEditingController();
  bool switchMessage = false;

  bool switchFan = false;
  void onsswitchMessageChanged(bool newValue) {
    if (switchMessage != newValue) {
      setState(() {
        switchMessage = newValue;
      });
      databaseReference.child("Message").set(switchMessage.toString());
    }
  }

  void onswitchFanChanged(bool newValue) {
    if (switchFan != newValue) {
      setState(() {
        switchFan = newValue;
      });
      databaseReference.child("Fan").set(switchFan.toString());
    }
  }

  bool notificationDisplayed = false;
  @override
  void dispose() {
    textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Tutorial',
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 250, 255),
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                    child: SafeArea(
                        child: Center(
                            child: Column(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                      child: appBar()),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Container(
                        child: firebaseRenderTemperature(),
                      )),
                      Expanded(
                          child: Container(
                        child: firebaseRenderHumidity(),
                      ))
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Container(
                        child: firebaseRenderSmoke(),
                      )),
                      Expanded(
                          child: Container(
                        child: firebaseRenderGas(),
                      )),
                      Expanded(
                          child: Container(
                        child: firebaseRenderCO(),
                      )),
                    ]),
                  ),
                  Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // ignore: prefer_const_constructors
                                    Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 30),
                                            child: Icon(Icons.wind_power))),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: FlutterSwitch(
                                          width: 40.0,
                                          height: 20.0,
                                          toggleSize: 15.0,
                                          value: switchFan,
                                          borderRadius: 30.0,
                                          padding: 4.0,
                                          activeColor: const Color.fromARGB(
                                              255, 215, 225, 255),
                                          toggleColor: const Color.fromARGB(
                                              255, 37, 102, 220),
                                          inactiveColor: const Color.fromARGB(
                                              255, 215, 225, 255),
                                          inactiveToggleColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                          onToggle: onswitchFanChanged),
                                    )),
                                  ]),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.only(right: 85),
                                child: const Text("Fan",
                                    style: TextStyle(
                                        fontFamily: 'Extra',
                                        fontSize: 15,
                                        height: 1.5,
                                        letterSpacing: 0.5,
                                        color: Colors.black)),
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 55),
                                child: const Text("Cosmos",
                                    style: TextStyle(
                                        fontFamily: 'Bold',
                                        fontSize: 15,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              )
                            ]),
                          )),
                          Expanded(
                              child: StreamBuilder<DatabaseEvent>(
                            stream: alert.onValue,
                            builder: (BuildContext context,
                                AsyncSnapshot<DatabaseEvent> snapshot) {
                              if (snapshot.hasData) {
                                DataSnapshot data = snapshot.data!.snapshot;
                                int alert = int.parse(data.value.toString());

                                if (alert >= 1 && alert <= 6) {
                                  if (!notificationDisplayed) {
                                    NotificationsManager()
                                        .showNotificationEco();
                                    notificationDisplayed = true;
                                  }
                                  return boxEco();
                                } else if (alert == 7) {
                                  if (!notificationDisplayed) {
                                    NotificationsManager()
                                        .showNotificationHot();
                                    notificationDisplayed = true;
                                  }
                                  return boxHot();
                                } else if (alert >= 10 && alert <= 18) {
                                  if (!notificationDisplayed) {
                                    NotificationsManager()
                                        .showNotificationSmoke();
                                    notificationDisplayed = true;
                                  }
                                  return boxSmoke();
                                } else if (alert >= 19 && alert <= 27) {
                                  if (!notificationDisplayed) {
                                    NotificationsManager()
                                        .showNotificationGas();
                                    notificationDisplayed = true;
                                  }
                                  return boxGas();
                                } else if (alert == 28) {
                                  if (!notificationDisplayed) {
                                    NotificationsManager()
                                        .showNotificationDanger();
                                    notificationDisplayed = true;
                                  }
                                  return boxDanger();
                                } else {
                                  return CircularPercentIndicator(radius: 30);
                                }
                              } else {
                                notificationDisplayed =
                                    false; // reset notificationDisplayed
                                return CircularPercentIndicator(radius: 30);
                              }
                            },
                          ))
                        ],
                      )
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.fromLTRB(20, 18, 0, 18),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // ignore: prefer_const_constructors
                            Expanded(
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 110, 0),
                                    child: const Icon(
                                      Icons.message,
                                      size: 25,
                                    ))),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.only(left: 50),
                              child: FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  toggleSize: 15.0,
                                  value: switchMessage,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  activeColor:
                                      const Color.fromARGB(255, 215, 225, 255),
                                  toggleColor:
                                      const Color.fromARGB(255, 37, 102, 220),
                                  inactiveColor:
                                      const Color.fromARGB(255, 215, 225, 255),
                                  inactiveToggleColor:
                                      Color.fromARGB(255, 255, 255, 255),
                                  onToggle: onsswitchMessageChanged),
                            )),
                          ]),
                      Container(
                        child: TypeMessage(),
                      ),
                    ]),
                  ),
                ])))))));
  }

  appBar() {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              constraints: const BoxConstraints(minWidth: 0),
              onPressed: () {},
              elevation: 2.0,
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.menu_rounded,
                  color: Colors.black87, size: 25),
            ),
            const Text(
              "Hello 👋",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Bold',
                fontSize: 17,
                letterSpacing: 1,
                color: Colors.black87,
              ),
            ),
          ],
        ));
  }

  firebaseRenderHumidity() {
    return StreamBuilder<DatabaseEvent>(
        stream: humi.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot != null && snapshot.data != null) {
            DataSnapshot data = snapshot.data!.snapshot;
            var value = int.parse(data.value.toString());
            return CircularPercentIndicator(
              radius: 60,
              lineWidth: 5,
              percent: value / 100,
              center: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: '$value%',
                        style: const TextStyle(
                            fontFamily: 'Extra',
                            fontSize: 21,
                            height: 1.2,
                            letterSpacing: 1,
                            color: Colors.black)),
                    const TextSpan(
                        text: ' \nHumidity',
                        style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 11,
                            height: 1.5,
                            letterSpacing: 0.5,
                            color: Colors.black)),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Color.fromARGB(255, 37, 102, 220),
              backgroundColor: const Color.fromARGB(255, 215, 225, 255),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(60),
            );
          }
        });
  }

  firebaseRenderTemperature() {
    return StreamBuilder<DatabaseEvent>(
        stream: temp.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot != null && snapshot.data != null) {
            DataSnapshot data = snapshot.data!.snapshot;
            var value = int.parse(data.value.toString());
            return CircularPercentIndicator(
              radius: 60,
              lineWidth: 5,
              percent: value / 100,
              center: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: '$value°C',
                        style: const TextStyle(
                            fontFamily: 'Extra',
                            fontSize: 21,
                            height: 1.2,
                            letterSpacing: 1,
                            color: Colors.black)),
                    const TextSpan(
                        text: ' \nTemperature',
                        style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 11,
                            height: 1.5,
                            letterSpacing: 0.5,
                            color: Colors.black)),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Color.fromARGB(255, 37, 102, 220),
              backgroundColor: const Color.fromARGB(255, 215, 225, 255),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(60),
            );
          }
        });
  }

  firebaseRenderSmoke() {
    return StreamBuilder<DatabaseEvent>(
        stream: smoke.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.data != null) {
            DataSnapshot data = snapshot.data!.snapshot;
            var value = double.parse(data.value.toString());
            return Column(children: [
              const Icon(
                Icons.whatshot,
                size: 25,
              ),
              Text('${value.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 13,
                      height: 2,
                      letterSpacing: 0.5,
                      color: Colors.black))
            ]);
          } else {
            return Container(
              margin: EdgeInsets.all(25),
            );
          }
        });
  }

  firebaseRenderGas() {
    return StreamBuilder<DatabaseEvent>(
        stream: gas.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.data != null) {
            DataSnapshot data = snapshot.data!.snapshot;
            var value = double.parse(data.value.toString());
            return Column(children: [
              const Icon(
                Icons.gas_meter,
                size: 25,
              ),
              Text('${value.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 13,
                      height: 2,
                      letterSpacing: 0.5,
                      color: Colors.black))
            ]);
          } else {
            return Container(
              margin: EdgeInsets.all(25),
            );
          }
        });
  }

  firebaseRenderCO() {
    return StreamBuilder<DatabaseEvent>(
        stream: co.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.data != null) {
            DataSnapshot data = snapshot.data!.snapshot;
            var value = double.parse(data.value.toString());
            return Column(children: [
              const Icon(
                Icons.co2,
                size: 25,
              ),
              Text('${value.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 13,
                      height: 2,
                      letterSpacing: 0.5,
                      color: Colors.black))
            ]);
          } else {
            return Container(
              margin: EdgeInsets.all(25),
            );
          }
        });
  }

  TypeMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 25, 30, 8),
      child: TextField(
        maxLines: null,
        maxLength: 32,
        controller: textController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 245, 250, 255),
          hintText: 'Type your message here',
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(1),
            fontFamily: 'Bold',
            fontSize: 13,
            height: 1,
            letterSpacing: 0.5,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 37, 102, 220)),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send,
                color: Color.fromARGB(255, 37, 102, 220)),
            onPressed: () {
              databaseReference.child("Text").set(textController.text);
              textController.clear();
            },
          ),
        ),
      ),
    );
  }

  boxEco() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Expanded(
                  child: Icon(
                Icons.eco,
                size: 40,
                color: Colors.green,
              )),
            ]),
        Container(
          margin: const EdgeInsets.fromLTRB(3, 11, 3, 11),
          child: const Text("ECO",
              style: TextStyle(
                  fontFamily: 'Extra',
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: Colors.black)),
        ),
      ]),
    );
  }

  boxHot() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Expanded(
                    child: Icon(
                  Icons.warning,
                  size: 40,
                  color: Colors.white,
                )),
              ]),
          Container(
            margin: const EdgeInsets.fromLTRB(3, 5, 3, 5),
            child: const Text("Temperature is to Hot",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Extra',
                    fontSize: 15,
                    letterSpacing: 0.6,
                    color: Colors.white)),
          )
        ]));
  }

  boxDanger() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Expanded(
                    child: Icon(
                  Icons.warning,
                  size: 40,
                  color: Colors.white,
                )),
              ]),
          Container(
            margin: const EdgeInsets.fromLTRB(3, 11, 3, 11),
            child: const Text("Fire Alert!",
                style: TextStyle(
                    fontFamily: 'Extra',
                    fontSize: 18,
                    letterSpacing: 0.6,
                    color: Colors.white)),
          )
        ]));
  }

  boxSmoke() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Expanded(
                    child: Icon(
                  Icons.warning,
                  size: 40,
                  color: Colors.white,
                )),
              ]),
          Container(
            margin: const EdgeInsets.fromLTRB(3, 6, 3, 6),
            child: const Text("Contaminated Smoke",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Extra',
                    fontSize: 14,
                    letterSpacing: 0.6,
                    color: Colors.white)),
          )
        ]));
  }

  boxGas() {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Expanded(
                    child: Icon(
                  FontAwesomeIcons.biohazard,
                  size: 40,
                  color: Colors.white,
                )),
              ]),
          Container(
            margin: const EdgeInsets.fromLTRB(3, 6, 3, 6),
            child: const Text("Contaminated Gas",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Extra',
                    fontSize: 14,
                    letterSpacing: 0.6,
                    color: Colors.white)),
          )
        ]));
  }
}



// penggolongan
// eco level 1
// hot level 7
// contaminated with gas level 10 - 18
// contaminated with smoke level 19 - 27
// fire alert level 28