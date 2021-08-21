import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spending;
  final double spendingPercentage;

  const ChartBar(
      {required this.label,
      required this.spending,
      required this.spendingPercentage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (conte, constra) {
      return Column(
        children: [
          Container(
            child:
                FittedBox(child: Text("\$${this.spending.toStringAsFixed(0)}")),
            height: constra.maxHeight * 0.15,
          ),
          SizedBox(
            height: constra.maxHeight * 0.05,
          ),
          Container(
            height: constra.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
                FractionallySizedBox(
                  heightFactor: this.spendingPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constra.maxHeight * 0.05,
          ),
          Container(
            child: Text(this.label),
            height: constra.maxHeight * 0.15,
          )
        ],
      );
    });
  }
}
