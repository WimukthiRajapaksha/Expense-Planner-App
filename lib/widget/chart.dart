import 'package:expense_planner/model/transaction.dart';
import 'package:expense_planner/widget/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> allTransactions;

  Chart(this.allTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double summ = 0.0;
      for (int i = 0; i < this.allTransactions.length; i++) {
        if (this.allTransactions[i].date.day == weekday.day &&
            this.allTransactions[i].date.month == weekday.month &&
            this.allTransactions[i].date.year == weekday.year) {
          summ += this.allTransactions[i].amount;
        }
      }
      return {
        "day": DateFormat.E().format(weekday).substring(0, 1),
        "amount": summ
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, (previousValue, element) {
      return previousValue + (element["amount"] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactions.map((item) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: item["day"].toString(),
                  spending: item["amount"] as double,
                  spendingPercentage: (this.totalSpending == 0.0)
                      ? 0.0
                      : (item["amount"] as double) / this.totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
