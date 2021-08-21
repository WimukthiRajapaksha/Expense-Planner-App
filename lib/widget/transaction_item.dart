import 'package:expense_planner/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required Transaction transaction,
    required this.deleteTrans,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction _transaction;
  final Function deleteTrans;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(child: Text("\$${_transaction.amount}")),
          ),
        ),
        title: Text(
          _transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(DateFormat.yMMMd().format(_transaction.date)),
        trailing: (MediaQuery.of(context).size.width > 450)
            ? FlatButton.icon(
                onPressed: () => this.deleteTrans(this._transaction.id),
                icon: Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                label: Text(
                  "Delete",
                ))
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => this.deleteTrans(this._transaction.id)),
      ),
    );
  }
}
