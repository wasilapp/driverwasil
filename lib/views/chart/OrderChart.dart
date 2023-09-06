import 'package:DeliveryBoyApp/controllers/RevenueController.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderChart extends StatelessWidget {
  final List<OrderData>? orderData;
  final bool? animate;
  final Material.ThemeData? themeData;

  OrderChart(this.orderData, this.themeData, {this.animate});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <LineSeries<OrderData, String>>[
          LineSeries<OrderData, String>(
            dataSource: orderData!,
            xValueMapper: (OrderData sales, _) =>
            sales.dateTime.day.toString() + "/" +
                sales.dateTime.month.toString(),
            yValueMapper: (OrderData sales, _) => sales.order,
            name: 'Sales',
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),

        ]);
  }
}
