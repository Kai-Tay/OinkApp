import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

//Input Text Controllers
TextEditingController titleTxt = TextEditingController();
TextEditingController amtTxt = TextEditingController();
TextEditingController typeTxt = TextEditingController();

//Input Variables
bool isListening = false;
stt.SpeechToText _speech = stt.SpeechToText();

//SQL Database Variables
String date = DateFormat("d MMM").format(DateTime.now());
String month = DateFormat("MMM").format(DateTime.now());
String databaseDate = DateFormat("yMd").format(DateTime.now());
String databaseMonth = DateFormat("MMM").format(DateTime.now());
String databaseYear = DateFormat("y").format(DateTime.now());
String iconDay = DateFormat("d").format(DateTime.now());
String iconMonth = DateFormat("MMM").format(DateTime.now());
String selectedMonth = databaseMonth;
String selectedYear = databaseYear;
var convertDate = DateTime.now();

var db = new Database();
var reloadTransactionsToday = db.viewTransactionsToday();
dynamic spendingToday;
double spendingTodayUI = 0;
dynamic spendingMonthly;
double spendingMonthlyUI = 0;
dynamic incomeMonthly;
dynamic savingsMonthly;
dynamic savingsMonthlyUI;

//Receipt

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//Starts SQL Database
  await db.databaseHelper();

//Check for Spendings for the day/month. Return 0 if value is null
  await db.viewSpendingsToday();
  if (await db.spendingToday == null) {
    spendingToday = 0;
    spendingTodayUI = 0;
  } else {
    spendingToday = await db.spendingToday;
    spendingTodayUI = double.parse((spendingToday).toStringAsFixed(2));
  }

  await db.viewSpendingsMonthly();
  if (await db.spendingMonthly == null) {
    spendingMonthly = 0;
    spendingMonthlyUI = 0;
  } else {
    spendingMonthly = await db.spendingMonthly;
    spendingMonthlyUI = double.parse((spendingMonthly).toStringAsFixed(2));
  }

  await db.viewIncomeMonthly();
  incomeMonthly = await db.incomeMonthly;
  if (incomeMonthly != null) {
    savingsMonthly = await incomeMonthly - await spendingMonthly;
    savingsMonthlyUI = double.parse((savingsMonthly).toStringAsFixed(2));
  } else {
    savingsMonthlyUI = "-";
  }
//Start app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark));
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
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.brown[600],
            primarySwatch: Colors.brown,
            fontFamily: "ProductSansBold"),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                        style:
                            TextStyle(fontSize: 25, color: Colors.brown[600]),
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
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: "ProductSansBold",
                          ),
                          tabs: [
                            Tab(
                              text: "  $iconDay\n$iconMonth",
                            ),
                            Tab(
                                icon: Icon(
                              Icons.savings_outlined,
                              size: 26,
                            )),
                            Tab(
                              icon: Icon(Icons.settings_outlined, size: 26),
                            )
                          ],
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey[600],
                          //indicatorSize: TabBarIndicatorSize.tab,
                          indicator: ShapeDecoration(
                            shape: CircleBorder(),
                            color: Colors.brown,
                          ),
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
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with AutomaticKeepAliveClientMixin<Main> {
  dynamic dropdownValue = "Income";

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.only(bottom: 16.0),
            child: Stack(children: [
              Container(
                  child: TabBarView(
                children: [
                  TodayPiggy(),
                  MonthPiggy(),
                  Center(
                      child: Text(
                    "Oink!\n Nothing to see here for now...",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: displayWidth(context) * 0.04),
                    textAlign: TextAlign.center,
                  )),
                ],
              )),
              Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 20),
                  child: Container(
                      height: displayHeight(context) * 0.85,
                      child: SnappingSheet(
                          lockOverflowDrag: true,
                          snappingPositions: [
                            SnappingPosition.pixels(
                                positionPixels: 60,
                                snappingCurve: Curves.elasticOut,
                                snappingDuration: Duration(milliseconds: 800)),
                            SnappingPosition.pixels(
                                positionPixels: 370,
                                snappingCurve: Curves.elasticOut,
                                snappingDuration: Duration(milliseconds: 800)),
                          ],
                          // TODO: Add your content that is placed
                          // behind the sheet. (Can be left empty)
                          sheetBelow: SnappingSheetContent(
                            draggable: true,
                            // TODO: Add your sheet content here
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    borderRadius: BorderRadius.circular(30)),
                                child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.brown,
                                                  ),
                                                  child: Icon(Icons.credit_card,
                                                      color: Colors.white,
                                                      size: 20)),
                                              SizedBox(width: 5),
                                              Container(
                                                  child: Text(
                                                "Add to Piggy",
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.brown),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        child: CustomRadioButton(
                                          enableButtonWrap: true,
                                          width: 110,
                                          height: 35,
                                          elevation: 0,
                                          absoluteZeroSpacing: false,
                                          unSelectedColor: Color.fromARGB(
                                              255, 240, 240, 240),
                                          buttonLables: [
                                            'Income',
                                            'Expense',
                                          ],
                                          buttonValues: [
                                            "Income",
                                            "Expense",
                                          ],
                                          buttonTextStyle: ButtonTextStyle(
                                              selectedColor: Colors.white,
                                              unSelectedColor: Colors.brown,
                                              textStyle:
                                                  TextStyle(fontSize: 18)),
                                          radioButtonValue: (value) {
                                            dropdownValue = value;
                                          },
                                          selectedColor: Colors.brown,
                                          unSelectedBorderColor:
                                              Colors.transparent,
                                          defaultSelected: "Income",
                                          enableShape: true,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: displayWidth(context) * 0.85,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Color.fromARGB(
                                                    255, 225, 225, 225)),
                                            child: Row(children: [
                                              Flexible(
                                                child: TextField(
                                                  controller: titleTxt,
                                                  readOnly: false,
                                                  decoration:
                                                      new InputDecoration(
                                                    hintText:
                                                        "Name/Description",
                                                    filled: false,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
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
                                                  showTwoGlows: false,
                                                  animate: isListening,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.mic_rounded),
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
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: displayWidth(context) * 0.85,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Color.fromARGB(
                                                    255, 225, 225, 225)),
                                            child: Row(children: [
                                              Flexible(
                                                child: TextField(
                                                  controller: amtTxt,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,2}')),
                                                  ],
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  readOnly: false,
                                                  decoration:
                                                      new InputDecoration(
                                                    hintText: "(\$) Amount",
                                                    filled: false,
                                                    border:
                                                        new OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
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
                                      SizedBox(height: 5),
                                      Barcode(),
                                      SizedBox(height: 5),
                                      Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              await db.insertTransaction(
                                                  transaction);
                                              titleTxt.clear();
                                              amtTxt.clear();
                                              setState(() {
                                                reloadTransactionsToday =
                                                    db.viewTransactionsToday();
                                              });
                                              main();
                                            },
                                            child: const Text('+ Add',
                                                style: TextStyle(fontSize: 22)),
                                          ),
                                        ],
                                      ))
                                    ])),
                          ))))
            ])));
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
                                "$spendingTodayUI",
                                style: TextStyle(
                                    fontFamily: "ProductSans",
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
                                    "$spendingMonthlyUI",
                                    style: TextStyle(
                                        fontFamily: "ProductSans",
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
                        height: 19,
                      ),
                      Container(
                        child: Container(
                            height: displayHeight(context) * 0.044,
                            width: displayWidth(context) * 0.30,
                            child: Row(children: [
                              Container(
                                  height: displayHeight(context) * 0.044,
                                  width: displayWidth(context) * 0.25,
                                  child: AutoSizeText(
                                    "$savingsMonthlyUI",
                                    style: TextStyle(
                                        fontFamily: "ProductSans",
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
                        "Saved in $month",
                        style: TextStyle(
                          fontSize: displayWidth(context) * 0.035,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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

class _MonthPiggyState extends State<MonthPiggy>
    with AutomaticKeepAliveClientMixin<MonthPiggy> {
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      SizedBox(height: 20),
      Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
              width: displayWidth(context) * 0.6,
              child: Column(children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Transactions",
                        style: TextStyle(
                            fontSize: displayWidth(context) * 0.075))),
                SizedBox(
                  height: 3,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "$selectedMonth $selectedYear",
                      style: TextStyle(fontSize: displayWidth(context) * 0.04),
                      textAlign: TextAlign.left,
                    ))
              ])),
          SizedBox(
              height: displayHeight(context) * 0.063,
              width: displayWidth(context) * 0.32,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown,
                    shadowColor: Colors.transparent,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined),
                        SizedBox(width: 8),
                        Text("Change\n Month"),
                      ]),
                  onPressed: () {
                    showMonthPicker(
                      context: context,
                      initialDate: convertDate,
                      locale: Locale("en"),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selectedMonth = DateFormat("MMM").format(date);
                          convertDate = date;
                          selectedYear = DateFormat("y").format(date);
                          main();
                        });
                      }
                    });
                  }))
        ],
      ),
      SizedBox(height: displayHeight(context) * 0.01),
      piggyMonth(),
    ]));
  }
}
