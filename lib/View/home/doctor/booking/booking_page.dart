import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/doctor_controller.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_text.dart';
import 'booking_card.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController searchController = TextEditingController();
  String selectedType = "الانتظار";
  List<String> types = ["الانتظار", "المقبول", "المرفوض", "الملغي", "تم الكشف"];
  DoctorController doctorController = Get.find();

  @override
  Widget build(BuildContext context) {
    doctorController.search(value: searchController.text);

    return SafeArea(
      child: Column(
        children: [
          _buildSearchTextfieldWidget(),
          _typesWidget(),
          _dataWidget(),
        ],
      ),
    );
  }

  _dataWidget() {
    int itemCount = selectedType == "الانتظار"
        ? doctorController.waitingBookingList.length
        : selectedType == "المقبول"
            ? doctorController.acceptedBookingList.length
            : selectedType == "المرفوض"
                ? doctorController.refusedBookingList.length
                : selectedType == "الملغي"
                    ? doctorController.canceledBookingList.length
                    : selectedType == "تم الكشف"
                        ? doctorController.finishedBookingList.length
                        : 0;

    return Expanded(
        child: Obx(
      () => RefreshIndicator(
        onRefresh: () async {
          await doctorController.getBookingsByDoctor("out");
          setState(() {});
        },
        child: doctorController.isLoading.value
            ? Align(alignment: Alignment.topCenter, child: loadingWidget())
            : selectedType == "الانتظار" &&
                    doctorController.waitingBookingList.isEmpty
                ? noDataCard(
                    text: "لا توجد حجوزات في قائمة الانتظار",
                    icon: Icons.library_books)
                : selectedType == "المقبول" &&
                        doctorController.acceptedBookingList.isEmpty
                    ? noDataCard(
                        text: "لا توجد حجوزات مقبولة",
                        icon: Icons.library_books)
                    : selectedType == "المرفوض" &&
                            doctorController.refusedBookingList.isEmpty
                        ? noDataCard(
                            text: "لا توجد حجوزات مرفوضه",
                            icon: Icons.library_books)
                        : selectedType == "الملغي" &&
                                doctorController.canceledBookingList.isEmpty
                            ? noDataCard(
                                text: "لا توجد حجوزات ملغية",
                                icon: Icons.library_books)
                            : selectedType == "تم الكشف" &&
                                    doctorController.finishedBookingList.isEmpty
                                ? noDataCard(
                                    text: "لا توجد حجوزات تمالكشف عليها بالفعل",
                                    icon: Icons.library_books)
                                : SizedBox(
                                    child: ListView.builder(
                                        itemCount: itemCount,
                                        itemBuilder: (context, position) {
                                          switch (selectedType) {
                                            case "الانتظار":
                                              return BookingCard(
                                                  model: doctorController
                                                          .waitingBookingList[
                                                      position],
                                                  doctorController:
                                                      doctorController);
                                            case "المقبول":
                                              return BookingCard(
                                                  model: doctorController
                                                          .acceptedBookingList[
                                                      position],
                                                  doctorController:
                                                      doctorController);
                                            case "تم الكشف":
                                              return BookingCard(
                                                  model: doctorController
                                                          .finishedBookingList[
                                                      position],
                                                  doctorController:
                                                      doctorController);
                                            case "المرفوض":
                                              return BookingCard(
                                                  model: doctorController
                                                          .refusedBookingList[
                                                      position],
                                                  doctorController:
                                                      doctorController);
                                            case "الملغي":
                                              return BookingCard(
                                                  model: doctorController
                                                          .canceledBookingList[
                                                      position],
                                                  doctorController:
                                                      doctorController);
                                            default:
                                              return Container();
                                          }
                                        }),
                                  ),
      ),
    ));
  }

  _typesWidget() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: types.length,
          itemBuilder: (context, position) {
            return InkWell(
                onTap: () => setState(() => selectedType = types[position]),
                child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: selectedType == types[position]
                            ? primaryColor
                            : Colors.transparent),
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                        text: types[position],
                        color: selectedType == types[position]
                            ? Colors.white
                            : primaryColorDark)));
          }),
    );
  }

  Widget _buildSearchTextfieldWidget() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 2,
          color: Colors.white,
          shape: const StadiumBorder(),
          child: TextField(
            onTap: () => _showDatePacker(),
            onChanged: (value) {},
            style: const TextStyle(color: Colors.grey, fontSize: 14),
            controller: searchController,
            readOnly: true,
            decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: " بحث بالتاريخ...",
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () async {
                      searchController.text = "";
                      setState(() {});
                    }),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
          ),
        ));
  }

  _showDatePacker() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2021, 1, 1),
        initialDate: DateTime.now(),
        lastDate: DateTime(2050, 1, 1));

    if (picked != null) {
      String value = picked.year.toString() +
          "-" +
          picked.month.toString() +
          "-" +
          picked.day.toString();
      doctorController.search(value: value);
      searchController.text = value;
      setState(() {});
    }
  }
}
