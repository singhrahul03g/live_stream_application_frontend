
import 'package:flutter/material.dart';
import 'package:frontend/models/meeting_details.dart';
import 'package:frontend/pages/meeting_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class JoinScreen extends StatefulWidget{
  final String? meetingId;
  final MeetingDetail? meetingDetail;

  const JoinScreen({Key?key, this.meetingId, this.meetingDetail}): super(key:key);

  @override
  State<JoinScreen> createState ()=> _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen>{
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = "";

  @override
  Widget build(BuildContext context){
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
                  userName = onSaved;
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
                  Flexible(
                      child: FormHelper.submitButton("join", () {
                    if(validateAndsave()){
                     Navigator.pushReplacement(context, MaterialPageRoute(builder:
                     ((context){
                       return MeetingPage(meetingId: widget.meetingDetail!.id,
                         name:userName,
                         meetingDetail:widget.meetingDetail!
                       );
                     })

                     ));
                    }

                  })),

                ],

              )

            ],
          ),
        )
    );
  }

  bool validateAndsave() {
    final form =  globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    return false;


  }


}

