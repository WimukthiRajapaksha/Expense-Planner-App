import 'dart:io';

import 'package:expense_planner/model/transaction.dart';
import 'package:expense_planner/widget/chart.dart';
import 'package:expense_planner/widget/new_transaction.dart';
import 'package:expense_planner/widget/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  // [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expense Planner",
      theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  void _addNewTransaction(String title, double amount, DateTime dateSelected) {
    setState(() {
      this._transactions.add(Transaction(
          id: DateTime.now().toString(),
          title: title,
          amount: amount,
          date: dateSelected));
    });
  }

  final List<Transaction> _transactions = [
    // Transaction(
    //     id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "New shirt", amount: 43.82, date: DateTime.now()),
    // Transaction(
    //     id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "New shirt", amount: 43.82, date: DateTime.now()),
    // Transaction(
    //     id: "t1", title: "New shoes", amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "New shirt", amount: 43.82, date: DateTime.now())
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((element) {
      return (element.date.isAfter(DateTime.now().subtract(Duration(days: 7))));
    }).toList();
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      this._transactions.removeWhere((element) {
        return (element.id == id);
      });
    });
  }

  List<Widget> _buildLandscape(
      MediaQueryData _mediaQuery, AppBar appBar, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "show chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  this._showChart = value;
                });
              })
        ],
      ),
      (_showChart)
          ? Container(
              child: Container(
                child: Chart(_recentTransactions),
                height: (_mediaQuery.size.height -
                        appBar.preferredSize.height -
                        _mediaQuery.padding.top) *
                    0.7,
              ),
            )
          : txList,
    ];
  }

  List<Widget> _buildPortrait(
      MediaQueryData _mediaQuery, AppBar appBar, Widget txList) {
    return [
      Container(
        child: Container(
          child: Chart(_recentTransactions),
          height: (_mediaQuery.size.height -
                  appBar.preferredSize.height -
                  _mediaQuery.padding.top) *
              0.3,
        ),
      ),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final isLandscape = _mediaQuery.orientation == Orientation.landscape;
    final appBar =
        // Platform.isIOS
        //     ? CupertinoNavigationBar(
        //         middle: Text(
        //           "Expense Planner",
        //         ),
        //         trailing: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             GestureDetector(
        //               onTap: () => _startAddNewTransaction(context),
        //               child: Icon(CupertinoIcons.add),
        //             )
        //           ],
        //         ),
        //       )
        //     :
        AppBar(
      title: Text(
        "Expense Planner",
      ),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add))
      ],
    );

    final txList = Container(
      child: TransactionList(_transactions, this._deleteTransaction),
      height: (_mediaQuery.size.height -
              appBar.preferredSize.height -
              _mediaQuery.padding.top) *
          0.7,
    );

    final _body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isLandscape) ..._buildLandscape(_mediaQuery, appBar, txList),
            if (!isLandscape) ..._buildPortrait(_mediaQuery, appBar, txList),
          ],
        ),
      ),
    );
    // return (Platform.isIOS)
    //     ? CupertinoPageScaffold(
    //         child: _body,
    //         navigationBar: appBar,
    //       )
    return Scaffold(
        appBar: appBar,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (Platform.isIOS)
            ? Container()
            : FloatingActionButton(
                onPressed: () => _startAddNewTransaction(context),
                child: Icon(Icons.add),
              ),
        body: _body);
  }
}
