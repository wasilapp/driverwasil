import 'package:DeliveryBoyApp/api/api_util.dart';
import 'package:DeliveryBoyApp/api/currency_api.dart';
import 'package:DeliveryBoyApp/controllers/AuthController.dart';
import 'package:DeliveryBoyApp/controllers/TransactionController.dart';
import 'package:DeliveryBoyApp/models/MyResponse.dart';
import 'package:DeliveryBoyApp/models/Transaction.dart';
import 'package:DeliveryBoyApp/services/AppLocalizations.dart';
import 'package:DeliveryBoyApp/utils/SizeConfig.dart';
import 'package:DeliveryBoyApp/views/LoadingScreens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import '../../utils/colors.dart';
import '../auth/authControllernew.dart';


class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {

  //ThemeData
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;

  //Global Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = new GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  AuthControllerr authControllerr=Get.put(AuthControllerr());

  //Other Variables
  bool isInProgress = false;
  late double totalPayToAdmin,totalTakeFromAdmin;

  //Transactions
  List<Transaction>? transactions;


  initState() {
    super.initState();
    _loadTransactionData();
  }

  Future<void> _refresh() async {
    if (!isInProgress) _loadTransactionData();
  }

  _loadTransactionData() async {
    if(mounted) {
      setState(() {
        isInProgress = true;
      });
    }

    MyResponse<List<Transaction>> myResponse = await TransactionController.getTransactions();
    if (myResponse.success) {
      transactions = myResponse.data;
      totalPayToAdmin = TransactionController.getTotalPayToAdmin(transactions!);
      totalTakeFromAdmin = TransactionController.getTotalTakeFromAdmin(transactions!);
    } else {
      //ApiUtil.checkRedirectNavigation(context, myResponse.responseCode);
      showMessage(message: myResponse.errorText);
    }

    if(mounted) {
      setState(() {
        isInProgress = false;
      });
    }
  }
  TextEditingController? datePicker;
  String dateString="";
  String  timeString = "";
  Widget build(BuildContext context) {
    _buildBody(){
      if(true){
        return ListView(

          children: [

            Expanded(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: Spacing.all(16),
                decoration: BoxDecoration(
                  color: customAppTheme.bgLayer1,
                  border: Border.all(color: customAppTheme.bgLayer4,width: 1),
                  borderRadius: BorderRadius.all(
                      Radius.circular(MySize.size8!)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(' From'),
                        InkWell(
                          // onTap: () async{
                          //   print(dateString);
                          //   DateTime? pickedDate = await showOmniDateTimePicker(context: context);
                          //
                          //   dateString = DateFormat('dd-MM-yyyy').format(pickedDate!);
                          //   timeString = DateFormat('HH:mm').format(pickedDate);
                          //   datePicker?.text = dateString + "-" + timeString;
                          //   setState(() {
                          //     dateString = DateFormat('dd-MM-yyyy').format(pickedDate!);
                          //     timeString = DateFormat('HH:mm').format(pickedDate);
                          //   });
                          //
                          // },
                          child:

                          Container(



                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(10)
                              ),

                              child: Text(dateString.isEmpty?'From':dateString)
                            // TextField
                            //   (decoration: InputDecoration(
                            //   border: InputBorder.none
                            // ),
                            //   style: TextStyle(color: Colors.black),
                            //   controller: datePicker,readOnly: true,onTap: () async{
                            //   DateTime? pickedDate = await showOmniDateTimePicker(context: context);
                            //   dateString = DateFormat('dd-MM-yyyy').format(pickedDate!);
                            //   timeString = DateFormat('HH:mm').format(pickedDate);
                            //   datePicker?.text = dateString + "-" + timeString;
                            // },),
                          ),
                        ),
                        Container(   color: Color(0xff48a080),width:2,height: 30),
                        Text(' To'),   InkWell(
                          onTap: () async{
                            print(dateString);
                            // DateTime? pickedDate = await showOmniDateTimePicker(context: context);
                            //
                            // dateString = DateFormat('dd-MM-yyyy').format(pickedDate!);
                            // timeString = DateFormat('HH:mm').format(pickedDate);
                            // datePicker?.text = dateString + "-" + timeString;
                            // setState(() {
                            //   dateString = DateFormat('dd-MM-yyyy').format(pickedDate!);
                            //   timeString = DateFormat('HH:mm').format(pickedDate);
                          },


                          child:

                          Container(



                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(10)
                              ),

                              child: Text(dateString.isEmpty?'To':dateString)
                            // TextField
                            //   (decoration: InputDecoration(
                            //   border: InputBorder.none
                            // ),
                            //   style: TextStyle(color: Colors.black),
                            //   controller: datePicker,readOnly: true,onTap: () async{
                            //   DateTime? pickedDate = await showOmniDateTimePicker(context: context);
                            //   dateString = DateFormat('dd-MM-yyyy').format(pickedDate!);
                            //   timeString = DateFormat('HH:mm').format(pickedDate);
                            //   datePicker?.text = dateString + "-" + timeString;
                            // },),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),

            Container(
              margin: Spacing.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: Spacing.all(16),
                      decoration: BoxDecoration(
                        color: customAppTheme.bgLayer1,
                        border: Border.all(color: customAppTheme.bgLayer4,width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(MySize.size8!)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: Spacing.all(16),
                            decoration: BoxDecoration(
                              color: customAppTheme.colorError.withAlpha(40),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(MySize.size4)),
                            ),
                            child: Icon(
                              MdiIcons.accountArrowRightOutline,
                              color: customAppTheme.colorError,
                            ),
                          ),
                          Container(
                              margin: Spacing.top(8),
                              child: Text(
                                CurrencyApi.getSign()+CurrencyApi.doubleToString(totalPayToAdmin),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    fontWeight: 700),
                                textAlign: TextAlign.center,
                              )),
                          Container(
                              margin: Spacing.top(2),
                              child: Text(
                                Translator.translate("pay_to_admin"),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    fontWeight: 500),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: MySize.size24,),
                  Expanded(
                    child: Container(
                      padding: Spacing.all(16),
                      decoration: BoxDecoration(
                        color: customAppTheme.bgLayer1,
                        border: Border.all(color: customAppTheme.bgLayer4,width: 1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(MySize.size8!)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: Spacing.all(16),
                            decoration: BoxDecoration(
                              color: themeData.colorScheme.primary.withAlpha(40),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(MySize.size4)),
                            ),
                            child: Icon(
                              MdiIcons.accountArrowLeftOutline,
                              color: themeData.colorScheme.primary,
                            ),
                          ),
                          Container(
                              margin: Spacing.top(8),
                              child: Text(
                                CurrencyApi.getSign()+CurrencyApi.doubleToString(totalTakeFromAdmin),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    fontWeight: 700),
                                textAlign: TextAlign.center,
                              )),
                          Container(
                              margin: Spacing.top(2),
                              child: Text(
                                Translator.translate("take_from_admin"),
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2,
                                    fontWeight: 500),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:
              Spacing.only(top: 16, bottom: 16),
              child: Center(
                child: Text("More on transactions are coming soon...",
                    style: AppTheme.getTextStyle(
                      themeData.textTheme.bodyText2,
                      letterSpacing: 0.5,
                      fontWeight: 500,
                    )),
              ),
            )
          ],
        );
      }else if(isInProgress){
        return LoadingScreens.getRevenueLoadingScreen(context, themeData, customAppTheme);
      }else{
        return Center(child: Text("Something wrong"),);
      }
    }

    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeMode = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeMode);
        customAppTheme = AppTheme.getCustomAppTheme(themeMode);
        return MaterialApp(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
          home: Scaffold(
              key: _scaffoldKey,
              backgroundColor: customAppTheme.bgLayer1,
              appBar: AppBar(
                backgroundColor: customAppTheme.bgLayer1,
                leading: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(MdiIcons.chevronLeft,color: themeData.colorScheme.onBackground,size: MySize.size20,),
                ),
                elevation: 0,
                centerTitle: true,
                title: Text(
                  Translator.translate("transactions"),
                  style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                      color: themeData.colorScheme.onBackground,
                      fontWeight: 600),
                ),
              ),
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  RefreshIndicator(
                    onRefresh: _refresh,
                    backgroundColor: customAppTheme.bgLayer1,
                    color: themeData.colorScheme.primary,
                    key: _refreshIndicatorKey,
                    child: Column(
                      children: [
                        Container(
                          height: MySize.size3,
                          child: isInProgress
                              ? LinearProgressIndicator(
                            minHeight: MySize.size3,
                          )
                              : Container(
                            height: MySize.size3,
                          ),
                        ),
                        Expanded(
                          child: _buildBody(),
                        ),
                      ],
                    ),
                  ),

                ],
              )),
        );
      },
    );

  }




  void showMessage({String message = "Something wrong", Duration? duration}) {
    if (duration == null) {
      duration = Duration(seconds: 3);
    }
    _scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: duration,
        content: Text(message,
            style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
                letterSpacing: 0.4, color: themeData.colorScheme.onPrimary)),
        backgroundColor: themeData.colorScheme.primary,
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
