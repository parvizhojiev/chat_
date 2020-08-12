import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });

      await databaseMethods.searchByName(searchEditingController.text).then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");

        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.documents.length,
      itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot.documents[index].data["userName"],
          searchResultSnapshot.documents[index].data["userEmail"],
        );
      }
    ) : Container();
  }

  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(chatRoomId: chatRoomId,)));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ],
              ),
              Spacer(),
              RaisedButton(
                onPressed: (){
                  sendMessage(userName);
                },
                child: Text('Переписка'),
                color: Colors.green,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              )
            ],
          ),
          SizedBox(height: 8,),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 42,
          padding: EdgeInsets.only(left: 13, bottom: 2,),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
          child: TextField(
            controller: searchEditingController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Поиск пользователей",
              border: InputBorder.none,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              initiateSearch();
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        child: Column(
          children: [
            SizedBox(height: 15,),
            Text('Найденные пользователи', style: TextStyle(fontSize: 20),),
            userList(),
          ],
        ),
      ),
    );
  }
}