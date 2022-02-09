import 'package:flutter/material.dart';

import 'package:pub/app/models/establishment.dart';
import 'package:pub/app/models/message.dart';
import 'package:pub/app/models/user.dart';
import 'package:pub/app/view_models/room_view_model.dart';

import '../config/app_colors.dart';

class MessageBoxWidget extends StatelessWidget{
  Establishment establishment;
  User user;

  MessageBoxWidget(this.establishment, this.user);

  TextEditingController _messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
   return Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: TextField(
                    controller:_messageController,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                        hintText: "Digite uma mensagem...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                backgroundColor: AppColors.brown,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                mini: true,
                onPressed: RoomViewModel.instance.sendMessage(
                    this.establishment,
                    _messageController.text,
                    Message(),
                    this.user),
              )
            ],
          ),
        );

  }
}
