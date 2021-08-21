import 'package:expense_planner/model/transaction.dart';
import 'package:expense_planner/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function deleteTrans;
  TransactionList(this._transactions, this.deleteTrans);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, cons) {
              return Column(
                children: [
                  Text(
                    "No transactions added yet!",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: cons.maxHeight * 0.6,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionItem(
                key: ValueKey(_transactions[index].id),
                  transaction: _transactions[index], deleteTrans: deleteTrans);
            },
            itemCount: _transactions.length,
          );
    // ),
  }
}
