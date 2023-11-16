import 'package:get/get.dart';

class GeneralStatusModel{
  Rx<GeneralStatus> status =GeneralStatus.waiting.obs;
  RxString? errorMsg=''.obs;
  void updateStatus(GeneralStatus newStatus){
    status.value=newStatus;
  }void updateError(String newError){
    errorMsg!.value=newError;
  }
}
enum GeneralStatus{waiting,success,error}