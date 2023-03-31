// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middleman_all/Controller/data/admin_controller.dart';
import 'package:middleman_all/Models/mps/missed_model.dart';
import 'package:middleman_all/View/home/admin/search_field.dart';
import 'package:middleman_all/View/home/home_files/home_page.dart';
import 'package:middleman_all/View/widgets/constant.dart';
import 'package:middleman_all/View/widgets/custom_selection_list.dart';
import 'missed_card.dart';
class MissedPage extends StatefulWidget {

   MissedPage({Key? key}) : super(key: key);

  @override
  State<MissedPage> createState() => _MissedPageState();
}
String selectedMissedStatus="انتظار";

class _MissedPageState extends State<MissedPage> {
  final List<String> _missedStatusList=["انتظار","مقبول","مرفوض"];
  final AdminController _adminController=Get.find();
  @override
  Widget build(BuildContext context) {
    return  Column(
    children: [
      _searchWidget(),
      _missedStatusWidget(),
      _dataWidget(),
      ],);}


  _dataWidget(){
    bool
    _messedIndex=currentIndex==3,
    _foundIndex=currentIndex==4,
    _waiting=selectedMissedStatus=="انتظار",
    _accepted=selectedMissedStatus=="مقبول",
    _refused=selectedMissedStatus=="مرفوض",
    _missedWaiting=_waiting&&_messedIndex,
    _missedAccepted=_accepted&&_messedIndex,
    _missedRefused=_refused&&_messedIndex,
    _foundWaiting=_waiting&&_foundIndex,
    _foundAccepted=_accepted&&_foundIndex,
    _foundRefused=_refused&&_foundIndex;

    List<MissedModel>
    _acceptedMissedList=_adminController.acceptedMissedList,
    _refusedMissedList=_adminController.refusedMissedList,
    _acceptedFoundList=_adminController.acceptedFoundList,
    _refusedFoundList=_adminController.refusedFoundList;



    return Expanded(
        child: RefreshIndicator(
          onRefresh: ()async{
            await _adminController.operations(moduleName: "mps",operationType: "load");
          },
          child:Obx(()=>
          _adminController.isLoading.value
              ?
          loadingWidget()
              :
          _missedWaiting && _adminController.waitingMissedList.isEmpty ? noDataCard(text: "لا توجد تبليغات عن مفقودين قائمة الانتظار",icon: Icons.library_books)
              :
          _missedAccepted && _acceptedMissedList.isEmpty ? noDataCard(text: "لا توجد تبليغات عن مفقودين مقبولة",icon: Icons.library_books)
              :
          _missedRefused && _refusedMissedList.isEmpty ? noDataCard(text: "لا توجد تبليغات عن مفقودين  مرفوضه",icon: Icons.library_books)
              :
          _foundWaiting && _adminController.waitingFoundList.isEmpty ? noDataCard(text: "لا توجد تبليغات إيجاد  قائمة الانتظار",icon: Icons.library_books)
              :
          _foundAccepted && _acceptedFoundList.isEmpty ? noDataCard(text: "لا توجد تبليغات إيجاد مقبولة",icon: Icons.library_books)
              :
          _foundRefused && _refusedFoundList.isEmpty?noDataCard(text: "لا توجد تبليغات إيجاد مرفوضه",icon: Icons.library_books)

              :
          SizedBox(
            child:
            ListView.builder(
                itemCount:_missedWaiting?  _adminController.waitingMissedList.length
                    :
                _missedAccepted? _acceptedMissedList.length
                    :
                _missedRefused?  _refusedMissedList.length
                    :
                _foundWaiting?_adminController.waitingFoundList.length
                    :
                _foundAccepted?_acceptedFoundList.length
                    :
                _foundRefused ? _refusedFoundList.length
                    : 0,
                itemBuilder: (context,position){

                      return
                      MissedCard(
                          model:_missedWaiting
                              ?
                          _adminController.waitingMissedList[position]
                              :
                          _missedAccepted
                              ?
                          _acceptedMissedList[position]
                              :
                          _missedRefused
                              ?
                          _refusedMissedList[position]
                              :
                          _foundWaiting
                              ?
                          _adminController. waitingFoundList[position]
                              :
                          _foundAccepted
                              ?
                          _acceptedFoundList[position]
                              :
                          _refusedFoundList[position],adminController:_adminController);
                   }

            ),
          )),
        ));
  }


  CustomSelectionList _missedStatusWidget() {
    return
      CustomSelectionList(list:_missedStatusList,listType: "missed_status",onTap:  (String? text){
      setState(()=> selectedMissedStatus=text!);
      });

  }

  SearchField _searchWidget() {
    return SearchField(lable: "بحث بآخر مكان وجد به المريض",onChange: (value){
      _adminController.mpsSearch(value: value);
      setState((){});
    },);
  }

}