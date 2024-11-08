import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return widget.transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) => Column(
              children: <Widget>[
                const Text(
                  "No Transactions Added Yet !",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: widget.transactions.length,
            itemBuilder: (ctx, index) {
              final item = widget.transactions[index].title;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Dismissible(
                  key: Key(item),
                  confirmDismiss: (DismissDirection dir) async {
                    if (dir == DismissDirection.startToEnd) {
                      final bool? res = await showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            content:
                            Text("Are You Sure You Want To Delete $item ?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    widget.deleteTx(widget.transactions[index].id);
                                    Navigator.of(ctx).pop();
                                  });

                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      return res;
                    }
                    return null;
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          "Delete",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 5,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(8, 2, 2, 1),
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: FittedBox(
                              child: Text("\$" "${widget.transactions[index].amount}")),
                        ),
                      ),
                      title: Text(
                        widget.transactions[index].title,
                        style: const TextStyle(fontSize: 22),
                      ),
                      subtitle:
                      Text(DateFormat.yMMMd().format(widget.transactions[index].date)),
                    ),
                  ),
                ),
              )

                /*Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromRGBO(8, 2, 2, 1),
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                          child: Text("\$" "${transactions[index].amount}")),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: const TextStyle(fontSize: 22),
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: IconButton(
                    onPressed: () => deleteTx(transactions[index].id),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              )*/;
            });
  }
}
