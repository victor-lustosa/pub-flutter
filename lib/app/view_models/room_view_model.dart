
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:pub/app/models/message.dart';
import 'package:pub/app/models/user.dart';
import 'package:pub/app/shared/config/app_routes.dart';
// import 'package:rx_notifier/rx_notifier.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../models/room.dart';
import '../states/room_state.dart';


abstract class IRoomViewModel{
  // sendMessage();
}

class RoomViewModel extends ChangeNotifier implements IRoomViewModel{

  final _socketResponse = StreamController<Room>.broadcast();
  late final Socket socket;
  final Random randomNumber = new Random();
  final Room room;
  final User user;
  final focusNode = FocusNode();

  List<dynamic> _usersList = [];
  List<dynamic> _messagesList = [];
 get getUsersList => _usersList;

  set usersList(List<dynamic> value) {
    _usersList = value;
  }

  ScrollController scrollController = ScrollController();
  Stream<Room> get getResponse => _socketResponse.stream;

  RoomViewModel(this.room, this.user){
    room.addUsers(this.user);
    _initClientServer();
  }

  _initClientServer(){
    // Dart client
    socket = io(urlServer, OptionBuilder().setTransports(['websocket']).build());
    socket.connect();
    socket.onConnect((_){
      socket.emit('enter_room',{'room':this.room.getRoomName,'nickName':this.user.getNickname});
    });
    socket.on('message',(data){
      final event = Room.fromJson(data);
      _socketResponse.sink.add(event);
      notifyListeners();
    });
  }


  final textController = TextEditingController(text: '');
  sizeBoxMessage(String value){
    if(value.length < 30) {
      return 1;
    } else if(value.length < 60){
      return 2;
    } else if(value.length < 100){
      return 3;
    } else{
      return 5;
    }
  }

  void sendMessage() {
    String textMessage = textController.text;
    if (textMessage.isNotEmpty) {
      this.user.setIdUser(0);

      List jsonCodeUsersList = [];

      for(int i = 0; i < room.getUsersList.length; i++){
        jsonCodeUsersList.add(room.getUsersList[i].toMap());
        print('lista usuarios: ${jsonCodeUsersList[i]}');
      }

      final event = Room(
          idRoom:randomNumber.nextInt(100),
          roomName:room.getRoomName,
          userNickName: user.getNickname,
          isPublic: true,
          usersList: jsonCodeUsersList,
          message: Message(
              createdAt: DateTime.now().toString(),
              idMessage: randomNumber.nextInt(100),
              textMessage: textMessage,
              user: this.user.getNickname).toMap(),
          type: 'message');

      socket.emit('message', event.toMap());
      _socketResponse.sink.add(event);
      textController.clear();
      focusNode.requestFocus();
      notifyListeners();
    }
  }

  void dispose(){
    _socketResponse.close();
    socket.clearListeners();
    socket.dispose();
    textController.dispose();
    focusNode.dispose();
  }

  void getData(AsyncSnapshot<Room> snapshot) {

    setMessagesList(jsonDecode(snapshot.data!.getMessage));
    notifyListeners();
    Timer(Duration(microseconds: 100 ), (){scrollController.jumpTo(scrollController.position.maxScrollExtent);});
  }

  get getMessagesList => _messagesList;

  setMessagesList(List<dynamic> messagesList) => _messagesList = messagesList;

}