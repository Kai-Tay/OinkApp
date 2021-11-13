import 'package:first_app/data.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

List<dynamic>? transactionsMonthly;
List<dynamic>? transactionsIncomeMonthly;
dynamic selectedValue = "Income";

// ignore: camel_case_types
class piggyMonth extends StatefulWidget {
  const piggyMonth({Key? key}) : super(key: key);

  @override
  _piggyMonthState createState() => _piggyMonthState();
}

class _piggyMonthState extends State<piggyMonth> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: displayHeight(context) * 0.66,
        child: Column(children: [
          Container(
            child: CustomRadioButton(
              enableButtonWrap: true,
              width: 110,
              height: 38,
              elevation: 0,
              absoluteZeroSpacing: false,
              unSelectedColor: Color.fromARGB(255, 240, 240, 240),
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
                  textStyle: TextStyle(fontSize: 18)),
              radioButtonValue: (value) {
                selectedValue = value;
                main();
              },
              selectedColor: Colors.brown,
              unSelectedBorderColor: Colors.transparent,
              defaultSelected: "Income",
              enableShape: true,
            ),
          ),
          Visibility(
            visible: (selectedValue == "Expense"),
            child: Container(
              child: FutureBuilder<List>(
                  future: db.viewTransactionsMonthly(),
                  builder: (context, snapshot) {
                    transactionsMonthly = snapshot.data;
                    if (snapshot.data == null) {
                      return Container(
                        padding: EdgeInsets.only(top: 150),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 18, color: Colors.brown),
                        ),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Flexible(
                          child: Container(
                              child: Column(children: [
                        Container(
                          width: displayWidth(context) * 0.9,
                          height: displayHeight(context) * 0.01,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 200),
                          child: Text(
                            "It's Empty\nKeep Saving Your Shit!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ])));
                    } else {
                      return Flexible(
                          child: Container(
                              child: Column(children: [
                        Container(
                          width: displayWidth(context) * 0.9,
                          height: displayHeight(context) * 0.01,
                        ),
                        Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 00),
                                itemCount: transactionsMonthly?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Transactions ts = transactionsMonthly?[index];
                                  return GestureDetector(
                                      onLongPress: () async {
                                        showDialog(
                                            context: context,
                                            barrierColor: Colors.black26,
                                            builder: (context) {
                                              return Dialog(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40.0),
                                                  ),
                                                  child: Container(
                                                      height: 120,
                                                      child: Container(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                            Text("Options",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .brown)),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 50,
                                                                    width: 120,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors.lightGreen,
                                                                            onPrimary: Colors.white,
                                                                            shadowColor: Colors.transparent,
                                                                            shape: new RoundedRectangleBorder(
                                                                              borderRadius: new BorderRadius.circular(30.0),
                                                                            )),
                                                                        onPressed: () async {
                                                                          int?
                                                                              selectedID =
                                                                              ts.id;
                                                                          db.selectTransaction(
                                                                              selectedID);
                                                                          TextEditingController
                                                                              editTitleTxt =
                                                                              TextEditingController();
                                                                          TextEditingController
                                                                              editAmtTxt =
                                                                              TextEditingController();
                                                                          editTitleTxt.text =
                                                                              "${ts.name}";
                                                                          editAmtTxt.text =
                                                                              "${ts.cost}";
                                                                          showDialog(
                                                                              context: context,
                                                                              barrierColor: Colors.black26,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  elevation: 0,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(30.0),
                                                                                  ),
                                                                                  child: Container(
                                                                                    height: 300,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                                                                            child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  "Edit",
                                                                                                  style: TextStyle(color: Colors.brown, fontSize: 23),
                                                                                                ))),
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(left: 30, bottom: 5),
                                                                                            child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  "Name/Description",
                                                                                                  style: TextStyle(fontSize: 15),
                                                                                                ))),
                                                                                        Container(
                                                                                          width: displayWidth(context) * 0.7,
                                                                                          child: TextField(
                                                                                            controller: editTitleTxt,
                                                                                            decoration: new InputDecoration(
                                                                                              fillColor: Colors.grey[200],
                                                                                              filled: true,
                                                                                              hintText: "Name/Description",
                                                                                              border: new OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  width: 0,
                                                                                                  style: BorderStyle.none,
                                                                                                ),
                                                                                                borderRadius: BorderRadius.circular(30),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(left: 30, bottom: 5),
                                                                                            child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  "(\$) Amount",
                                                                                                  style: TextStyle(fontSize: 15),
                                                                                                ))),
                                                                                        Container(
                                                                                          width: displayWidth(context) * 0.7,
                                                                                          child: TextField(
                                                                                            inputFormatters: [
                                                                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                                                                            ],
                                                                                            controller: editAmtTxt,
                                                                                            decoration: new InputDecoration(
                                                                                              fillColor: Colors.grey[200],
                                                                                              filled: true,
                                                                                              hintText: "(\$)Amount",
                                                                                              border: new OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  width: 0,
                                                                                                  style: BorderStyle.none,
                                                                                                ),
                                                                                                borderRadius: BorderRadius.circular(30),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            primary: Colors.transparent,
                                                                                            onPrimary: Colors.brown,
                                                                                            shadowColor: Colors.transparent,
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            var transaction = Transactions(
                                                                                              id: ts.id,
                                                                                              name: editTitleTxt.text,
                                                                                              cost: num.parse(editAmtTxt.text),
                                                                                              type: ts.type,
                                                                                              date: ts.date,
                                                                                              month: ts.month,
                                                                                              year: ts.year,
                                                                                            );
                                                                                            await db.updateTransaction(transaction, ts.id);
                                                                                            setState(() {
                                                                                              reloadTransactionsToday = db.viewTransactionsToday();
                                                                                            });
                                                                                            editAmtTxt.clear();
                                                                                            editTitleTxt.clear();
                                                                                            Navigator.pop(context);
                                                                                            Navigator.pop(context);
                                                                                            main();
                                                                                          },
                                                                                          child: const Text('+ Edit', style: TextStyle(fontSize: 22)),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.edit),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              "Edit",
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ))),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                SizedBox(
                                                                    height: 50,
                                                                    width: 120,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors.red,
                                                                            onPrimary: Colors.white,
                                                                            shadowColor: Colors.transparent,
                                                                            shape: new RoundedRectangleBorder(
                                                                              borderRadius: new BorderRadius.circular(30.0),
                                                                            )),
                                                                        onPressed: () async {
                                                                          int?
                                                                              selectedID =
                                                                              ts.id;
                                                                          db.deleteTransaction(
                                                                              selectedID);
                                                                          setState(
                                                                              () {
                                                                            reloadTransactionsToday =
                                                                                db.viewTransactionsToday();
                                                                          });
                                                                          await db
                                                                              .viewSpendingsToday();
                                                                          Navigator.pop(
                                                                              context);
                                                                          main();
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.delete),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              "Delete",
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        )))
                                                              ],
                                                            )
                                                          ]))));
                                            });
                                      },
                                      child: Card(
                                          margin: EdgeInsets.only(bottom: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          color: Colors.grey[200],
                                          shadowColor: Colors.transparent,
                                          child: Row(children: <Widget>[
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width:
                                                  displayWidth(context) * 0.2,
                                              height: 55,
                                              child: Center(
                                                  child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "${ts.cost}",
                                                  style: TextStyle(
                                                      fontSize: displayWidth(
                                                              context) *
                                                          0.07,
                                                      color: Colors.grey[200]),
                                                ),
                                              )),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.brown[500]),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              height: 70,
                                              width:
                                                  displayWidth(context) * 0.55,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(children: [
                                                      Container(
                                                          width: displayWidth(
                                                                  context) *
                                                              0.33,
                                                          child: Text(
                                                            '${ts.type}',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey[700]),
                                                          )),
                                                      Text(
                                                        '${ts.date}',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey[700]),
                                                      )
                                                    ]),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          '${ts.name}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                displayWidth(
                                                                        context) *
                                                                    0.07,
                                                          ),
                                                        )),
                                                  ]),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ])));
                                }))
                      ])));
                    }
                  }),
            ),
          ),
          //VIEW MONTHLY INCOME
          Visibility(
            visible: (selectedValue == "Income"),
            child: Container(
              child: FutureBuilder<List>(
                  future: db.viewTransactionsIncomeMonthly(),
                  builder: (context, snapshot) {
                    transactionsIncomeMonthly = snapshot.data;
                    if (snapshot.data == null) {
                      return Container(
                        padding: EdgeInsets.only(top: 150),
                        child: Text(
                          "",
                          style: TextStyle(fontSize: 18, color: Colors.brown),
                        ),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Flexible(
                          child: Container(
                              child: Column(children: [
                        Container(
                          width: displayWidth(context) * 0.9,
                          height: displayHeight(context) * 0.01,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 200),
                          child: Text(
                            "Add Your Income Now!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ])));
                    } else {
                      return Flexible(
                          child: Container(
                              child: Column(children: [
                        Container(
                          width: displayWidth(context) * 0.9,
                          height: displayHeight(context) * 0.01,
                        ),
                        Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, bottom: 0),
                                itemCount: transactionsIncomeMonthly?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Transactions ts =
                                      transactionsIncomeMonthly?[index];
                                  return GestureDetector(
                                      onLongPress: () async {
                                        showDialog(
                                            context: context,
                                            barrierColor: Colors.black26,
                                            builder: (context) {
                                              return Dialog(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40.0),
                                                  ),
                                                  child: Container(
                                                      height: 120,
                                                      child: Container(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                            Text("Options",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .brown)),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 50,
                                                                    width: 120,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors.lightGreen,
                                                                            onPrimary: Colors.white,
                                                                            shadowColor: Colors.transparent,
                                                                            shape: new RoundedRectangleBorder(
                                                                              borderRadius: new BorderRadius.circular(30.0),
                                                                            )),
                                                                        onPressed: () async {
                                                                          int?
                                                                              selectedID =
                                                                              ts.id;
                                                                          db.selectTransaction(
                                                                              selectedID);
                                                                          TextEditingController
                                                                              editTitleTxt =
                                                                              TextEditingController();
                                                                          TextEditingController
                                                                              editAmtTxt =
                                                                              TextEditingController();
                                                                          editTitleTxt.text =
                                                                              "${ts.name}";
                                                                          editAmtTxt.text =
                                                                              "${ts.cost}";
                                                                          showDialog(
                                                                              context: context,
                                                                              barrierColor: Colors.black26,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  elevation: 0,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(30.0),
                                                                                  ),
                                                                                  child: Container(
                                                                                    height: 300,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                                                                            child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  "Edit",
                                                                                                  style: TextStyle(color: Colors.brown, fontSize: 23),
                                                                                                ))),
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(left: 30, bottom: 5),
                                                                                            child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  "Name/Description",
                                                                                                  style: TextStyle(fontSize: 15),
                                                                                                ))),
                                                                                        Container(
                                                                                          width: displayWidth(context) * 0.7,
                                                                                          child: TextField(
                                                                                            controller: editTitleTxt,
                                                                                            decoration: new InputDecoration(
                                                                                              fillColor: Colors.grey[200],
                                                                                              filled: true,
                                                                                              hintText: "Name/Description",
                                                                                              border: new OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  width: 0,
                                                                                                  style: BorderStyle.none,
                                                                                                ),
                                                                                                borderRadius: BorderRadius.circular(30),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Container(
                                                                                            padding: EdgeInsets.only(left: 30, bottom: 5),
                                                                                            child: Align(
                                                                                                alignment: Alignment.centerLeft,
                                                                                                child: Text(
                                                                                                  "(\$) Amount",
                                                                                                  style: TextStyle(fontSize: 15),
                                                                                                ))),
                                                                                        Container(
                                                                                          width: displayWidth(context) * 0.7,
                                                                                          child: TextField(
                                                                                            inputFormatters: [
                                                                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                                                                            ],
                                                                                            controller: editAmtTxt,
                                                                                            decoration: new InputDecoration(
                                                                                              fillColor: Colors.grey[200],
                                                                                              filled: true,
                                                                                              hintText: "(\$)Amount",
                                                                                              border: new OutlineInputBorder(
                                                                                                borderSide: BorderSide(
                                                                                                  width: 0,
                                                                                                  style: BorderStyle.none,
                                                                                                ),
                                                                                                borderRadius: BorderRadius.circular(30),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 20,
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(
                                                                                            primary: Colors.transparent,
                                                                                            onPrimary: Colors.brown,
                                                                                            shadowColor: Colors.transparent,
                                                                                          ),
                                                                                          onPressed: () async {
                                                                                            var transaction = Transactions(
                                                                                              id: ts.id,
                                                                                              name: editTitleTxt.text,
                                                                                              cost: num.parse(editAmtTxt.text),
                                                                                              type: ts.type,
                                                                                              date: ts.date,
                                                                                              month: ts.month,
                                                                                              year: ts.year,
                                                                                            );
                                                                                            await db.updateTransaction(transaction, ts.id);
                                                                                            setState(() {
                                                                                              reloadTransactionsToday = db.viewTransactionsToday();
                                                                                            });
                                                                                            editAmtTxt.clear();
                                                                                            editTitleTxt.clear();
                                                                                            Navigator.pop(context);
                                                                                            Navigator.pop(context);
                                                                                            main();
                                                                                          },
                                                                                          child: const Text('+ Edit', style: TextStyle(fontSize: 22)),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.edit),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              "Edit",
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ))),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                SizedBox(
                                                                    height: 50,
                                                                    width: 120,
                                                                    child: ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors.red,
                                                                            onPrimary: Colors.white,
                                                                            shadowColor: Colors.transparent,
                                                                            shape: new RoundedRectangleBorder(
                                                                              borderRadius: new BorderRadius.circular(30.0),
                                                                            )),
                                                                        onPressed: () async {
                                                                          int?
                                                                              selectedID =
                                                                              ts.id;
                                                                          db.deleteTransaction(
                                                                              selectedID);
                                                                          setState(
                                                                              () {
                                                                            reloadTransactionsToday =
                                                                                db.viewTransactionsToday();
                                                                          });
                                                                          await db
                                                                              .viewSpendingsToday();
                                                                          Navigator.pop(
                                                                              context);
                                                                          main();
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Icon(Icons.delete),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              "Delete",
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        )))
                                                              ],
                                                            )
                                                          ]))));
                                            });
                                      },
                                      child: Card(
                                          margin: EdgeInsets.only(bottom: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          color: Colors.grey[200],
                                          shadowColor: Colors.transparent,
                                          child: Row(children: <Widget>[
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width:
                                                  displayWidth(context) * 0.2,
                                              height: 55,
                                              child: Center(
                                                  child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "${ts.cost}",
                                                  style: TextStyle(
                                                      fontSize: displayWidth(
                                                              context) *
                                                          0.07,
                                                      color: Colors.grey[200]),
                                                ),
                                              )),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.brown[500]),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              height: 70,
                                              width:
                                                  displayWidth(context) * 0.55,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(children: [
                                                      Container(
                                                          width: displayWidth(
                                                                  context) *
                                                              0.33,
                                                          child: Text(
                                                            '${ts.type}',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .grey[700]),
                                                          )),
                                                      Text(
                                                        '${ts.date}',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .grey[700]),
                                                      )
                                                    ]),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Text(
                                                          '${ts.name}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                displayWidth(
                                                                        context) *
                                                                    0.07,
                                                          ),
                                                        )),
                                                  ]),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                          ])));
                                }))
                      ])));
                    }
                  }),
            ),
          ),
        ]));
  }
}

class EditDialog extends StatefulWidget {
  const EditDialog({Key? key}) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 400,
      ),
    );
  }
}
