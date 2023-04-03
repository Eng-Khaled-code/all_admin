import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Models/doctor/booking_model.dart';
import 'package:middleman_all/Services/main_operations.dart';
import 'package:middleman_all/View/widgets/constant.dart';

import '../../View/utilities/strings.dart';

class DoctorController extends GetxController {
  String url = Strings.appRootUrl + "doctors/";
  RxBool isLoading = false.obs;
  List allBookingList = [];
  List<BookingModel> waitingBookingList = [];
  List<BookingModel> acceptedBookingList = [];
  List<BookingModel> refusedBookingList = [];
  List<BookingModel> finishedBookingList = [];
  List<BookingModel> canceledBookingList = [];

  RxInt firstBookingIndex = (-1).obs; // -1 for no one in the clinick room
  RxInt secondBookingIndex = 0.obs;

  RxInt dayWaitingLength = 0.obs;
  RxInt dayAcceptedLength = 0.obs;
  RxInt dayRefusedLength = 0.obs;
  RxInt dayFinishedLength = 0.obs;
  RxInt dayCanceledLength = 0.obs;

  RxInt allWaitingLength = 0.obs;
  RxInt allAcceptedLength = 0.obs;
  RxInt allRefusedLength = 0.obs;
  RxInt allFinishedLength = 0.obs;
  RxInt allCanceledLength = 0.obs;

  final MainOperation _mainOperation = MainOperation();

  @override
  void onInit() {
    super.onInit();
    getBookingsByDoctor("out");
  }

  setFirstBookingIndex(int index) {
    firstBookingIndex(index);
  }

  setSecondBookingIndex(int index) {
    secondBookingIndex(index);
  }

  Future<void> getBookingsByDoctor(type) async {
    if (type != "in") {
      isLoading(true);
    }
    Map<String, String> postData = {"doc_id": "${Strings.globalUserId}"};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "get_bookings_by_doctor.php");
    if (resultMap["status"] == 1) {
      allBookingList = resultMap['data'];
      loadBookModelCategorization();
    } else {
      Get.snackbar("خطا", errorTranslation(resultMap["message"]));
    }
    if (type != "in") {
      isLoading(false);
    }
  }

  loadBookModelCategorization() {
    waitingBookingList = [];
    acceptedBookingList = [];
    refusedBookingList = [];
    canceledBookingList = [];
    finishedBookingList = [];
    dayWaitingLength = 0.obs;
    dayAcceptedLength = 0.obs;
    dayRefusedLength = 0.obs;
    dayFinishedLength = 0.obs;
    dayCanceledLength = 0.obs;

    allWaitingLength = 0.obs;
    allAcceptedLength = 0.obs;
    allRefusedLength = 0.obs;
    allFinishedLength = 0.obs;
    allCanceledLength = 0.obs;

    DateTime date = DateTime.now();
    String thisDay = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();

    for (var book in allBookingList) {
      if (book['booking_status'] == "WAITING") {
        waitingBookingList.add(BookingModel.fromSnapshot(book));
        allWaitingLength++;
        if (book['req_date'].toString().contains(thisDay)) {
          dayWaitingLength++;
        }
      } else if (book['booking_status'] == "ACCEPTED") {
        acceptedBookingList.add(BookingModel.fromSnapshot(book));
        allAcceptedLength++;
        if (book['booking_final_date'].toString().contains(thisDay)) {
          dayAcceptedLength++;
        }
      } else if (book['booking_status'] == "REFUSED") {
        refusedBookingList.add(BookingModel.fromSnapshot(book));
        allRefusedLength++;
        if (book['response_date'].toString().contains(thisDay)) {
          dayRefusedLength++;
        }
      } else if (book['booking_status'] == "CANCELED") {
        canceledBookingList.add(BookingModel.fromSnapshot(book));
        allCanceledLength++;
        if (book['response_date'].toString().contains(thisDay)) {
          dayCanceledLength++;
        }
      } else if (book['booking_status'] == "FINISHED") {
        finishedBookingList.add(BookingModel.fromSnapshot(book));
        allFinishedLength++;
        if (book['booking_final_date'].toString().contains(thisDay)) {
          dayFinishedLength++;
        }
      }
    }
  }

  search({String? value}) {
    if (value != "") {
      waitingBookingList = [];
      acceptedBookingList = [];
      refusedBookingList = [];
      canceledBookingList = [];
      finishedBookingList = [];

      for (var book in allBookingList) {
        if (book['booking_status'] == 'WAITING' &&
            book['req_date'].toString().contains(value!)) {
          waitingBookingList.add(BookingModel.fromSnapshot(book));
        } else if (book['booking_status'] == 'ACCEPTED' &&
            book['booking_final_date'].toString().contains(value!)) {
          acceptedBookingList.add(BookingModel.fromSnapshot(book));
        } else if (book['booking_status'] == 'REFUSED' &&
            book['response_date'].toString().contains(value!)) {
          refusedBookingList.add(BookingModel.fromSnapshot(book));
        } else if (book['booking_status'] == 'CANCELED' &&
            book['response_date'].toString().contains(value!)) {
          canceledBookingList.add(BookingModel.fromSnapshot(book));
        } else if (book['booking_status'] == 'FINISHED' &&
            book['booking_final_date'].toString().contains(value!)) {
          finishedBookingList.add(BookingModel.fromSnapshot(book));
        }
      }
    } else {
      loadBookModelCategorization();
    }
  }

  Future<void> changeBookStatus(
      {int? bookId = 0,
      String? bookStatus = "",
      String? date = "",
      String? notes = "",
      String? bookType = "كشف",
      String? searchDate = ""}) async {
    isLoading(true);
    Map<String, String> postData = {
      "book_id": "$bookId",
      "doc_id": bookType!,
      "user_id": notes!,
      "type": "change book status",
      "patient_name": bookStatus!,
      "pain_desc": date!
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "main_booking_operatios.php");
    if (resultMap["status"] == 1) {
      Fluttertoast.showToast(
          msg: bookStatus == "ACCEPTED"
              ? "تمت الموافقة بنجاح"
              : bookStatus == "REFUSED"
                  ? "تم الرفض بنجاح"
                  : bookStatus == "CANCELED"
                      ? "تم الالغاء بنجاح"
                      : "تم الانتهاء من الكشف");
      await getBookingsByDoctor("in");
      search(value: searchDate);
    } else {
      Get.snackbar("خطا", errorTranslation(resultMap["message"]));
    }
    isLoading(false);
  }

  Future<void> addBookingFromClinick(
      {String? patientName = "", String? painDesc = ""}) async {
    isLoading(true);
    DateTime date = DateTime.now();
    String thisDay = date.year.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();

    Map<String, String> postData = {
      "book_id": " ",
      "doc_id": "${Strings.globalUserId}",
      "user_id": thisDay,
      "type": "add from clinick",
      "patient_name": patientName!,
      "pain_desc": painDesc!
    };

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "main_booking_operatios.php");
    if (resultMap["status"] == 1) {
      Fluttertoast.showToast(msg: "تم إضافة الحجزبنجاح");
      await getBookingsByDoctor("in");
      search(value: thisDay);
    } else {
      Get.snackbar("خطا", errorTranslation(resultMap["message"]));
    }
    isLoading(false);
  }
}
