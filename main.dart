import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'barcode.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:intl/intl.dart';
import 'piggyToday.dart';
import 'piggyMonth.dart';
import 'database.dart';
import 'data.dart';
import 'package:auto_size_text/auto_size_text.dart';

//Input Text Controllers
TextEditingController titleTxt = TextEditingController();
TextEditingController amtTxt = TextEditingController();
TextEditingController typeTxt = TextEditingController();

//Input Variables
bool isListening = false;
stt.SpeechToText _speech = stt.SpeechToText();

//SQL Database Variables
String databaseDate = DateFormat("yMd").format(DateTime.now());
String databaseMonth = DateFormat("MMM").format(DateTime.now());
String databaseYear = DateFormat("y").format(DateTime.now());

var db = new Database();
var reloadTransactionsToday = db.viewTransactionsToday();
dynamic spendingToday;
dynamic spendingMonthly;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//Starts SQL Database
  await db.databaseHelper();

//Check for Spendings for the day/month. Return 0 if value is null
  await db.viewSpendingsToday();
  if (await db.spendingToday == null) {
    spendingToday = 0;
  } else {
    spendingToday = await db.spendingToday;
  }

  await db.viewSpendingsMonthly();
  if (await db.spendingMonthly == null) {
    spendingMonthly = 0;
  } else {
    spendingMonthly = await db.spendingMonthly;
  }

//Start app
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color.fromARGB(255, 240, 240, 240)));
}

//sizes
Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.white, fontFamily: "Alata"),
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  title: Container(
                      padding: EdgeInsets.only(left: 5, top: 10),
                      child: Row(children: [
                        Image(
                          image: new AssetImage("images/Icon.png"),
                          height: 40,
                        ),
                        SizedBox(width: 2),
                        Text(
                          "",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Alata",
                              color: Colors.brown[600]),
                        ),
                      ])),
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: SafeArea(
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(100),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TabBar(
                            tabs: [
                              Tab(icon: Icon(Icons.savings_outlined)),
                              Tab(icon: Icon(Icons.calendar_today_outlined)),
                              Tab(
                                  icon: Icon(
                                      Icons.account_balance_wallet_outlined)),
                            ],
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey[600],
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.brown),
                            isScrollable: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: new Main()),
          ),
        ),
      );
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  dynamic dropdownValue;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      maxHeight: 500,
      minHeight: 68,
      panelBuilder: (ScrollController sc) => _scrollingList(sc),
      boxShadow: [BoxShadow(blurRadius: 0, color: Colors.transparent)],
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      color: Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: TabBarView(
          children: [
            TodayPiggy(),
            MonthPiggy(),
            Center(
                child: Text(
              "Still Coding on it...\n Actually I also DK what this is for ah...",
              style: TextStyle(fontSize: displayWidth(context) * 0.04),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          width: displaySize(context).width * 0.2,
          height: displaySize(context).height * 0.007,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 30),
          child: Align(
            alignment: Alignment(-0.8, 0),
            child: Text(
              "+ Add to Piggy",
              style: TextStyle(
                  color: Colors.brown, fontSize: displayWidth(context) * 0.045),
            ),
          ),
        ),
        Expanded(
            child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                hint: Text(
                  "Select Expense/Income",
                  style: TextStyle(color: Colors.brown[600]),
                ),
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 24,
                style: const TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                ),
                underline: Container(
                  height: 0,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>[
                  'Income',
                  'Expense',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: displayWidth(context) * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 230, 230, 230)),
                  child: Row(children: [
                    Flexible(
                      child: TextField(
                        controller: titleTxt,
                        readOnly: false,
                        decoration: new InputDecoration(
                          hintText: "Name/Description",
                          filled: false,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    AvatarGlow(
                        glowColor: Colors.grey,
                        repeat: false,
                        showTwoGlows: true,
                        animate: isListening,
                        child: IconButton(
                          icon: const Icon(Icons.mic_rounded),
                          color: Colors.brown,
                          onPressed: () {
                            listen();
                          },
                        ),
                        endRadius: 30)
                  ]),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: displayWidth(context) * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 230, 230, 230)),
                  child: Row(children: [
                    Flexible(
                      child: TextField(
                        controller: amtTxt,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        readOnly: false,
                        decoration: new InputDecoration(
                          hintText: "(\$) Amount",
                          filled: false,
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            SizedBox(height: 15),
            Barcode(),
            SizedBox(height: 25),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onPrimary: Colors.brown,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      String type = dropdownValue;
                      var transaction = Transactions(
                        name: titleTxt.text,
                        cost: num.parse(amtTxt.text),
                        type: type,
                        date: databaseDate,
                        month: databaseMonth,
                        year: databaseYear,
                      );
                      await db.insertTransaction(transaction);
                      titleTxt.clear();
                      amtTxt.clear();
                      setState(() {
                        dropdownValue = null;
                      });
                      setState(() {
                        reloadTransactionsToday = db.viewTransactionsToday();
                      });
                      main();
                    },
                    child: const Text('+ Add', style: TextStyle(fontSize: 22)),
                  ),
                ],
              ),
            )
          ],
        )),
      ],
    ));
  }

  void listen() async {
    if (!isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          listenFor: Duration(seconds: 8),
          cancelOnError: true,
          onResult: (val) => setState(() {
            titleTxt.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }
}

class TodayPiggy extends StatefulWidget {
  const TodayPiggy({Key? key}) : super(key: key);

  @override
  _TodayPiggyState createState() => _TodayPiggyState();
}

class _TodayPiggyState extends State<TodayPiggy> {
  final String date = DateFormat("d MMM").format(DateTime.now());
  final String month = DateFormat("MMM").format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: displaySize(context).height * 0.03,
          ),
          Container(
            width: displaySize(context).width * 0.93,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              border: Border.all(
                color: Color.fromARGB(255, 240, 240, 240),
                width: displaySize(context).width * 0.05,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today, $date",
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.045,
                          )),
                      SizedBox(
                        height: displayHeight(context) * 0.01,
                      ),
                      Container(
                          height: displayHeight(context) * 0.09,
                          width: displayWidth(context) * 0.28,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: AutoSizeText(
                                "$spendingToday",
                                style: TextStyle(
                                    fontSize: displayWidth(context) * 0.5),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      Text(
                        "Spent",
                        style:
                            TextStyle(fontSize: displayWidth(context) * 0.045),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.brown),
                    ),
                  ),
                  SizedBox(
                    width: displayWidth(context) * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Container(
                            height: displayHeight(context) * 0.044,
                            width: displayWidth(context) * 0.30,
                            child: Row(children: [
                              Container(
                                  height: displayHeight(context) * 0.044,
                                  width: displayWidth(context) * 0.25,
                                  child: AutoSizeText(
                                    "$spendingMonthly",
                                    style: TextStyle(
                                        fontSize: displayWidth(context) * 0.5),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Container(
                                  padding: EdgeInsets.only(top: 20, left: 10),
                                  child: Text(
                                    "",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ])),
                      ),
                      Text(
                        "Spent in $month",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text("-", style: TextStyle(fontSize: 40)),
                            Container(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Text(
                                  "",
                                  style: TextStyle(fontSize: 15),
                                )),
                          ],
                        ),
                      ),
                      Text(
                        "Saved in $month",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              child: Text(
                  "Here's what you have in your Piggy on $date!\n -Long Press to Delete!-",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: displayWidth(context) * 0.035))),
          SizedBox(
            height: 15,
          ),
          piggytodayList(),
        ],
      ),
    );
  }
}

class MonthPiggy extends StatefulWidget {
  const MonthPiggy({Key? key}) : super(key: key);

  @override
  _MonthPiggyState createState() => _MonthPiggyState();
}

class _MonthPiggyState extends State<MonthPiggy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(children: [
            SizedBox(
              width: 20,
            ),
            Text("Transactions",
                style: TextStyle(fontSize: displayWidth(context) * 0.08)),
          ]),
          Row(children: [
            SizedBox(
              width: 20,
            ),
            Text("$databaseMonth $databaseYear",
                style: TextStyle(fontSize: displayWidth(context) * 0.05))
          ]),
          SizedBox(height: 10),
          piggyMonth(),
        ],
      ),
    );
  }
}
