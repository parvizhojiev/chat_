import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Chat extends StatefulWidget {
  final String chatRoomId;
  String username;

  Chat({this.chatRoomId, this.username});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ScrollController sc = ScrollController();

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages(){
    return Expanded(
        child: StreamBuilder(
        stream: chats,
        builder: (context, snapshot){
          return snapshot.hasData ?  ListView.builder(
            controller: sc,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }
          ) : Center(child: Text('Сообщений нет'),);
        },
      ),
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      messageEditingController.clear();

      var timer = Timer(Duration(milliseconds: 200), () => sc.animateTo(sc.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease));
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: actionBar(context, 'Сообщения'),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            chatMessages(),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          onTap: (){
                            print('dfgdfgdfgdfgdfgdfgdgdfg');
                            var timer = Timer(Duration(milliseconds: 350), () => sc.animateTo(sc.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease));
                          },
                          controller: messageEditingController,
                          style: simpleText(),
                            decoration: InputDecoration(
                            hintText: "Сообщение",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: () {
                        addMessage();
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe ? BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30)
          ) :
          BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
          color: sendByMe ? Colors.red : Colors.blueGrey,
        ),
        child: Column(
          children: [
            // Text(
            //   sendByMe ? Constants.myName : widget.username,
            //   textAlign: sendByMe ? TextAlign.left : TextAlign.right,
            //   style: TextStyle(
            //     color: Colors.white.withOpacity(0.4)
            //   )
            // ),
            Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w300)
            ),
          ],
        ),
      ),
    );
  }
}