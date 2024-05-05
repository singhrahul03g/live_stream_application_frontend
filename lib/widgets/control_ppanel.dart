import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'dart:ui';


class ControlPanel extends StatelessWidget{


  // const ControlPanel({Key?key}):super(key:key);
  final bool ? videoEnabled;
  final bool ? audioEnabled;
  final bool ? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  ControlPanel({
    this.videoEnabled,
    this.audioEnabled,
    this.onAudioToggle,
    this.onVideoToggle,
    this.onReconnect,
    this.onMeetingEnd,
    this.isConnectionFailed
});

  @override
  Widget build(BuildContext context){
  return Container(
    color: Colors.blueGrey[900],
    height: 60.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buildControls(),
    ),
  );
  }
  List<Widget> buildControls(){
    if(!isConnectionFailed!){
      return <Widget>[
        IconButton(
            onPressed: onVideoToggle,
            icon: Icon(videoEnabled! ? Icons.videocam: Icons.videocam_off),
            color:Colors.white,
            iconSize: 32.0),
        IconButton(
            onPressed: onAudioToggle,
            icon: Icon(audioEnabled! ? Icons.mic: Icons.mic_off),
            color:Colors.white,
            iconSize: 32.0),
        const SizedBox(
          width:25,
        ),
        Container(
          width:70,
          decoration:const BoxDecoration(
            shape: BoxShape.circle
          ),
          color: Colors.red,
          child:IconButton(
            icon:const Icon(
              Icons.call_end,
              color:Colors.white,
            ),
            onPressed:onMeetingEnd!,
          ),
        ),

      ];
    }
    else{
      return <Widget>[
        FormHelper.submitButton(
          "Reconnect",
          onReconnect!,
          btnColor: Colors.red,
          borderRadius: 10,
          width: 200,
          height: 40,
        )
      ];
    }
  }
}