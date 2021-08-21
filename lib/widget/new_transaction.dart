import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransaction;

  NewTransaction(this.newTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    if (this.titleController.text.isEmpty ||
        this.amountController.text.isEmpty ||
        double.parse(this.amountController.text) <= 0 ||
        (this._selectedDate == null)) {
      return;
    } else {
      widget.newTransaction(titleController.text,
          double.parse(amountController.text), this._selectedDate);
      Navigator.of(context).pop();
    }
  }

  void presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          this._selectedDate = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: titleController,
                onSubmitted: (_) => this.submitData(),
                // onChanged: (value) {
                //   title = value;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => this.submitData(),
                // onChanged: (value) {
                //   amount = value;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text((this._selectedDate == null)
                          ? "No date chosen!"
                          : "Picked date: ${DateFormat.yMd().format(this._selectedDate!)}"),
                    ),
                    (Platform.isIOS)
                        ? CupertinoButton(
                            onPressed: this.presentDatePicker,
                            child: Text(
                              "Choose date",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        : FlatButton(
                            onPressed: this.presentDatePicker,
                            child: Text(
                              "Choose date",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            textColor: Theme.of(context).primaryColor,
                          )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: this.submitData,
                child: Text("Add Transaction"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
