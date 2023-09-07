import 'dart:developer';

import 'package:DeliveryBoyApp/api/api_util.dart';


class MyResponse<T>{

  bool success=false;
  T? data;
  List<dynamic> errors=[];
  String errorText="";
  int? responseCode;


  MyResponse(this.responseCode);

  setError(Map<String,dynamic> jsonObject){

    try{
    String? error = jsonObject['error'];
    if(error!=null){
      this.errors = [error];
      this.errorText = getFormattedError(this.errors);
      return;
    }
    List<dynamic>? errors = jsonObject['errors'];
    if(errors!=null){
      log("i am here");
      this.errors = errors;
      this.errorText = getFormattedError(errors);
      log("i am kk");
      log(this.errors.toString());
      log(this.errorText.toString());
      return;
    }

    this.errorText="Something wrong";

    }catch(e){
        this.errors=[];
    this.errorText="Something wrong";
    }

  }

    setErrorForRegister(Map<String,dynamic> jsonObject){
       log("1");
    var errors = jsonObject['errors'];
   

    if (errors is List){
      log("in");
      this.errorText = errors.toString();
      return;
    }
       log("2");
    if (errors != null) {
         log("3");
      this.errors = [];
      log("4");
      this.errorText = jsonObject['errors']["email"] !=null ? jsonObject['errors']["email"].toString() : jsonObject['errors']["mobile"] !=null ? jsonObject['errors']["mobile"].toString(): "Invalid Data"  ;
      log("5");
      return;
    }
    this.errorText = "Something wrong";

  }

  

  

  static String getFormattedError(List<dynamic> errors){
    String errorText = "";
    for(int i=0;i<errors.length;i++){
      errorText += "- " + errors[i] + (i+1<errors.length ? "\n" : "" );
    }
    return errorText;
  }




  static makeInternetConnectionError<T>(){
    MyResponse<T> myResponse = MyResponse(ApiUtil.INTERNET_NOT_AVAILABLE_CODE);
    myResponse.errorText = "Please turn on internet";
    return myResponse;
  }

  static makeServerProblemError<T>(){
    MyResponse<T> myResponse = MyResponse(ApiUtil.SERVER_ERROR_CODE);
    myResponse.errorText = "Server Problem! Please try again later";
    return myResponse;
  }
}