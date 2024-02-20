import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/constant.dart';
import 'package:messenger_app/widgets/avatar.dart';
import 'package:messenger_app/widgets/circle_elevated_button.dart';
import 'package:messenger_app/widgets/primary_text.dart';
import 'package:intl/intl.dart';

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
CollectionReference chatRef = _firestore.collection('Chat');

String currentUserID = _firebaseAuth.currentUser!.uid;


class ChatPage extends StatelessWidget {
  final String otherUserID;
  final String otherUserName;
  final String otherUserPhoto;

  const ChatPage(this.otherUserID, this.otherUserName, this.otherUserPhoto, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  late List <DocumentSnapshot> docs;
  final DateTime now = DateTime.now();
  late String time =  DateFormat('HH:mm').format(now);

    return Scaffold(
      backgroundColor: defaultAppColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const CustomAppBar(),
          const SizedBox(
            height: 20,
          ),
          HeaderMessage(senderName: otherUserName),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only( left: 20, right: 20),
                      child: StreamBuilder(
                        stream: chatRef.doc(currentUserID).collection(otherUserID).orderBy('time').snapshots(),
                        builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                              
                          try {
                            if (snapshot.hasError) return const Text('Something wrong..');
                              
                            if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator.adaptive();
                            
                            if (!snapshot.hasData) return const LinearProgressIndicator(color: defaultAppColor,);
                            docs = snapshot.data!.docs;
                            
                            if(docs.isEmpty) return Center(child: Text(time));
                            
                            return ListView(
                              children: docs.map((document) {
                                return document['userID'] == currentUserID ? sender(document['message']!, document['time']! ): 
                                    receiver(otherUserName, document['message']!, document['time']!, otherUserPhoto);
                              }).toList(),
                            );
                          } catch (e) {
                            debugPrint(e.toString());
                            return Container();
                          }
                        },
                      ),
                    ),
                  ),
                  MessageInputField(otherUserID: otherUserID,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget sender(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryText(
            text: time.toString().substring(13, 18),
            color: Colors.grey[400]!,
            fontSize: 12,  
          ),
          Container(
            constraints: const BoxConstraints(
              minWidth: 100,
              maxWidth: 260
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: const BoxDecoration(
              color: Color(0xEEeeeef8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), 
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(0)
              ),
            ),
            child: PrimaryText(
              text: message,
              color: Colors.black38,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget receiver(String  userName, String message, String time, String photoUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AvatarWidget(
                userName: userName,
                imagePath: photoUrl,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10,),
              Container(
                constraints: const BoxConstraints(
                  minWidth: 100,
                  maxWidth: 260
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: const BoxDecoration(
                  color: Color(0xF7F7F7F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25), 
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(25)
                  ),
                ),
                child: PrimaryText(
                  text: message,
                  color: Colors.black38,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          PrimaryText(
            text: time.toString().substring(13, 18),
            color: Colors.grey[400]!,
            fontSize: 12,  
          ),
        ],
      ),
    );
  }
}


class MessageInputField extends StatelessWidget {
  final String otherUserID;
  final TextEditingController messageTextField = TextEditingController();
  
  MessageInputField({
    super.key, required this.otherUserID,
  });

  void sendMessage () {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
    
    if (messageTextField.text.isNotEmpty) {  
      try {
        chatRef.doc(currentUserID).collection(otherUserID).add({
          'message': messageTextField.text,
          'userID': currentUserID,
          'time': formattedDate
        }).then((value) {
          chatRef.doc(otherUserID).collection(currentUserID).add({
            'message': messageTextField.text,
            'userID': currentUserID,
            'time': formattedDate
          }).then((value) => messageTextField.clear());
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: TextField(
              controller: messageTextField,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        width: 0, style: BorderStyle.none)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 10),
                hintText: 'Type your message ...',
                hintStyle: TextStyle(
                  color: Colors.grey[500], 
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          CircleElevatedButton(
            height: 50, 
            width: 50, 
            padding: 5, 
            icon: Icons.send,
            backgroundColor: defaultAppColor, 
            onPressed: () => sendMessage()
          )
        ],
      ),
    );
  }
}

class HeaderMessage extends StatelessWidget {
  final String senderName;
  const HeaderMessage({
    super.key, required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: PrimaryText(
              text: senderName,
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          const Row(
            children: [
              CircleElevatedButton(
                height: 45,
                width: 45,
                padding: 5,
                icon: Icons.call,
                onPressed: null
              ),
              SizedBox(
                width: 15,
              ),
              CircleElevatedButton(
                height: 45,
                width: 45,
                padding: 5,
                icon: Icons.videocam,
                onPressed: null
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            child: const PrimaryText(
              text: 'Back',
              color: Colors.white54,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const PrimaryText(
              text: 'Search',
              color: Colors.white54,
            ),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchResults = ['Sofia', 'Estefanie'];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
            splashColor: Colors.indigo[200],
            focusColor: Colors.indigo[200],
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            });
      },
    );
  }
}
