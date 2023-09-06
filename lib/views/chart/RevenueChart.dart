import 'package:DeliveryBoyApp/controllers/RevenueController.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RevenueChart extends StatelessWidget {
  final List<RevenueData>? revenueData;
  final bool? animate;
  final Material.ThemeData? themeData;


  RevenueChart(this.revenueData,this.themeData, {this.animate});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <LineSeries<RevenueData, String>>[
          LineSeries<RevenueData, String>(
            dataSource: revenueData!,
            xValueMapper: (RevenueData sales, _) =>
            sales.dateTime.day.toString() + "/" +
                sales.dateTime.month.toString(),
            yValueMapper: (RevenueData sales, _) => sales.revenue,
            name: 'Sales',
            dataLabelSettings: DataLabelSettings(isVisible: false),
          ),

        ]);

  }
}
