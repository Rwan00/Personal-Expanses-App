import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction(this.addTx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount == null || enteredAmount <= 0) {
      return;
    } else {
      widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    }

    print("Done");

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
              top: 10.0,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(label: Text("Title")),
                controller: _titleController,
              ),
              TextField(
                decoration: const InputDecoration(label: Text("Amount")),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          "Picked Date: ${DateFormat.yMd().format(_selectedDate)}"),
                    ),
                    TextButton(
                        onPressed: _presentDatePicker,
                        child: const Text("Choose Date")),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _submitData, child: const Text("Add Transaction"))
            ],
          ),
        ),
      ),
    );
  }
}
