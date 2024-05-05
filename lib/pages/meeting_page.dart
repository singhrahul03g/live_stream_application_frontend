
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:frontend/utils/user.utils.dart';
import 'package:frontend/widgets/remote_connection.dart';
import "../models/meeting_details.dart";
import '../widgets/control_ppanel.dart';
import 'home_screen.dart';

class MeetingPage extends StatefulWidget{

  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  const MeetingPage({Key?key, this.meetingId, this.name, required this.meetingDetail}):super(key:key);
  @override
  State<MeetingPage> createState() => _MeetingPageState();


}

class _MeetingPageState extends State<MeetingPage>{

  final _localRenderer = RTCVideoRenderer();
  final Map<String,dynamic> mediaConstraints = {"audio":true, "video":true};
  WebRTCMeetingHelper? meetingHelper ;
  bool isConnectionFailed = false;

  //  ControlPanel(){
  //
  // }


  @override
  void startMeeting() async {
    final String? userId = await loadUserId();

    meetingHelper = WebRTCMeetingHelper(
        url: "http://localhost:4000",
        meetingId: widget.meetingDetail.id,
        userId: userId,
        name: widget.name
    );
    MediaStream _localStream = await navigator.mediaDevices.getUserMedia(
        mediaConstraints);
    _localRenderer.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on("open",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );
    meetingHelper!.on("connection",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );
    meetingHelper!.on("user-left",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );
    meetingHelper!.on("video-toggle",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );
    meetingHelper!.on("audio-toggle",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );
    meetingHelper!.on("meeting-ended",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );
    meetingHelper!.on("connection-setting-changed",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );

    meetingHelper!.on("stream-changed",
        context,
            (ev, Context) {
          setState(() {
            isConnectionFailed == false;
          });
        }
    );

    setState(() {

    });
  }


  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      body:_buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle:onAudioToggle,
        onVideoToggle:onVideoToggle,
      videoEnabled:isVideoEnabled(),
      audioEnabled:isAudioEnabled(),
      isConnectionFailed:isConnectionFailed,
      onReconnect:handleReconnect,
      onMeetingEnd:onMeetingEnd,
    ),
    );
  }

    void onMeetingEnd(){
    if(meetingHelper != null){
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePage();
    }

    }
    
    goToHomePage(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const HomeScreen() ));
    }

   Future<dynamic> initRenderers  () async {
    await _localRenderer.initialize();
    }

    @override
  void initState(){
    super.initState();
    initRenderers();
    startMeeting();
    }

  @override
  void deactivate(){
    super.deactivate();
   _localRenderer.dispose();
    if(meetingHelper!= null){
      meetingHelper!.destroy();
      meetingHelper!=null;
    }
  }

   _buildMeetingRoom(){
    return Stack(
  children: [
    meetingHelper != null && meetingHelper!.connections.isNotEmpty ?
        GridView.count(crossAxisCount: meetingHelper!.connections.length <3 ? 1: 2,
    children:List.generate(meetingHelper!.connections.length, (index) {
      return Padding(
        padding: const EdgeInsets.all(1),
        child: RemoteConnection(
          renderer: meetingHelper!.connections[index].renderer,
          connection: meetingHelper!.connections[index],
        ),
      );
    }),
        )

  : const Center(
      child:Padding(
  padding: EdgeInsets.all(10),
  child:Text("waiting for the participants to join the meeting",
  style:TextStyle(color: Colors.grey,
  fontSize: 24) ,
  )
  )
      ),
  Positioned(
  bottom:10,
  right:0,
  child:SizedBox(
  width: 150,
  height: 200,
  child:RTCVideoView(
  _localRenderer
  ),
  )
  )
  ],
    );
}

  void onAudioToggle(){
    if(meetingHelper!=null){
      setState(() {
        meetingHelper!.toggleAudio();
      }
      );
    }
  }

  void onVideoToggle(){

  if(meetingHelper!=null){

    setState(() {
      meetingHelper!.toggleVideo();
    }
    );
  }
  }

  // void isConnectionFailed(){
  //
  //
  // }

  bool isVideoEnabled(){
    return meetingHelper!= null ? meetingHelper!.videoEnabled! : false;
  }

  bool isAudioEnabled(){
    return meetingHelper!= null ? meetingHelper!.audioEnabled! : false;
  }

  void handleReconnect(){
if(meetingHelper!= null){
  meetingHelper!.reconnect();
}
  }

}