
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import '../api/meeting_api.dart';
import '../models/meeting_details.dart';
import './join_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key?key}): super(key:key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class  _HomeScreenState extends State<HomeScreen>{

  static final GlobalKey <FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Meeting"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key:globalKey,
        child:formUI(),
      ),
    );
  }

  formUI() {
    return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 20),
              FormHelper.inputFieldWidget(
                context,
                "meetingId",
                "Enter Your Name",
                    (val) {
                  if (val.isEmpty) {
                    return "Name can't be Empty";
                  }
                  return null;
                },
                    (onSaved) {
                  meetingId = onSaved;
                },
                borderRadius: 10,
                borderFocusColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                hintColor: Colors.grey,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child: FormHelper.submitButton("join meeting", () {
                    if(validateAndSave()){
                      validateMeeting(meetingId);
                    }

                  })),
                  Flexible(child: FormHelper.submitButton("start meeting", () async {
                    try{
                      var response = await startMeeting();
                      final body = json.decode(response!.body);
                      final meetingId = body['data'];
                    }catch(e){
                      print("start meeting error $e");
                    }
                  }))
                ],

              )

            ],
          ),
        )
    );
  }

  void validateMeeting(String meetingId) async{
    try{
      var response = await JoinMeeting(meetingId);
      var data = json.decode(response!.body);
      final meetingDetails = MeetingDetail.fromJson(data["data"]);
      // goTOJoinScreen
      goToJoinScreen(meetingDetails);
    }catch(err){

      FormHelper.showSimpleAlertDialog(
          context,
          "Meeting App",
          "Invalid Meeting Id",
          "OK",
              (){
            Navigator.of(context).pop();
          }
      );
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> JoinScreen(
        meetingId:meetingDetail.id,
        meetingDetail:meetingDetail
    )));
  }

  bool validateAndSave() {
    final form =  globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;
  }

}

