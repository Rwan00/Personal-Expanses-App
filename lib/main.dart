import 'package:flutter/material.dart';
import 'package:transaction_app/widgets/chart.dart';
import 'package:transaction_app/widgets/new_transaction.dart';
import 'package:transaction_app/widgets/transaction_list.dart';
import 'models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(8, 2, 2, 1),
            secondary: const Color.fromRGBO(115, 187, 201, 1),
          ),
          canvasColor: const Color.fromRGBO(241, 212, 229, 1),
          useMaterial3: false,),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);

    var appBar = AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: const Text("Personal Expenses"),
      actions: <Widget>[
        IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ))
      ],
    );

    final isLandSpace = mq.orientation == Orientation.landscape;

    var txListWidget = SizedBox(
      height:
          (mq.size.height - appBar.preferredSize.height - mq.padding.top) * 0.7,
      child: TransactionList(_userTransaction, _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!isLandSpace)
              SizedBox(
                height: (mq.size.height -
                        appBar.preferredSize.height -
                        mq.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandSpace) txListWidget,
            if (isLandSpace)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Show Chart"),
                  Switch(
                      value: _showChart,
                      onChanged: (newVal) {
                        setState(() {
                          _showChart = newVal;
                        });
                      }),
                ],
              ),
            if (isLandSpace)
              _showChart
                  ? SizedBox(
                      height: (mq.size.height -
                              appBar.preferredSize.height -
                              mq.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => startAddNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
