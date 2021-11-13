import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';

List<dynamic>? transactionsToday;

class piggytodayList extends StatefulWidget {
  const piggytodayList({Key? key}) : super(key: key);

  @override
  _piggytodayListState createState() => _piggytodayListState();
}

// ignore: camel_case_types
class _piggytodayListState extends State<piggytodayList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: displayHeight(context) * 0.54,
      child: FutureBuilder<List>(
          future: db.viewTransactionsToday(),
          builder: (context, snapshot) {
            transactionsToday = snapshot.data;
            if (snapshot.data == null) {
              return Container(
                padding: EdgeInsets.only(top: 150),
                child: Text(
                  "Nothing!",
                  style: TextStyle(fontSize: 18, color: Colors.brown),
                ),
              );
            }
            if (transactionsToday?.isEmpty == true) {
              return Container(
                padding: EdgeInsets.only(top: displayHeight(context) * 0.2),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Go do something about it...\n                Swipe Up!",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    )),
              );
            } else {
              return Container(
                  height: displayHeight(context) * 0.45,
                  child: Column(children: [
                    Container(
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.08,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Piggy Today, $date!",
                            style: TextStyle(fontSize: 17),
                          )),
                    ),
                    Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 5),
                            itemCount: transactionsToday?.length,
                            itemBuilder: (BuildContext context, int index) {
                              Transactions ts = transactionsToday?[index];
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
                                                    BorderRadius.circular(40.0),
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
                                                                fontSize: 20,
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
                                                                          borderRadius:
                                                                              new BorderRadius.circular(30.0),
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
                                                                      editTitleTxt
                                                                              .text =
                                                                          "${ts.name}";
                                                                      editAmtTxt
                                                                              .text =
                                                                          "${ts.cost}";
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierColor: Colors
                                                                              .black26,
                                                                          builder:
                                                                              (context) {
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
                                                                                              style: TextStyle(color: Colors.brown, fontSize: 25),
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
                                                                        Icon(Icons
                                                                            .edit),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          "Edit",
                                                                          style:
                                                                              TextStyle(fontSize: 18),
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
                                                                          borderRadius:
                                                                              new BorderRadius.circular(30.0),
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
                                                                        Icon(Icons
                                                                            .delete),
                                                                        SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                          "Delete",
                                                                          style:
                                                                              TextStyle(fontSize: 18),
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
                                          width: displayWidth(context) * 0.2,
                                          height: 55,
                                          child: Center(
                                              child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              "${ts.cost}",
                                              style: TextStyle(
                                                  fontSize:
                                                      displayWidth(context) *
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
                                          width: displayWidth(context) * 0.55,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${ts.type}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[700]),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      '${ts.name}',
                                                      style: TextStyle(
                                                        fontSize: displayWidth(
                                                                context) *
                                                            0.07,
                                                      ),
                                                    )),
                                              ]),
                                        ),
                                      ])));
                            }))
                  ]));
            }
          }),
    );
  }
}
