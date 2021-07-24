import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
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
        child: Expanded(
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
            } else {
              return ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 180),
                  itemCount: transactionsToday?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Transactions ts = transactionsToday?[index];
                    return GestureDetector(
                        onLongPress: () async {
                          int? selectedID = ts.id;
                          db.deleteTransaction(selectedID);
                          setState(() {
                            reloadTransactionsToday =
                                db.viewTransactionsToday();
                          });
                          await db.viewSpendingsToday();
                          main();
                        },
                        child: Card(
                            margin: EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
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
                                        fontSize: displayWidth(context) * 0.07,
                                        color: Colors.grey[200]),
                                  ),
                                )),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
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
                                        height: displayHeight(context) * 0.01,
                                      ),
                                      Text(
                                        '${ts.type}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[700]),
                                      ),
                                      SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            '${ts.name}',
                                            style: TextStyle(
                                              fontSize:
                                                  displayWidth(context) * 0.07,
                                            ),
                                          )),
                                    ]),
                              ),
                            ])));
                  });
            }
          }),
    ));
  }
}