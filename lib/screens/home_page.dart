
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/screens/chat_page.dart';

import 'package:messenger_app/constant.dart';
import 'package:messenger_app/widgets/avatar.dart';
import 'package:messenger_app/widgets/avatar_stroke_gradient.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
CollectionReference userRef = firebaseFirestore.collection('Users');
CollectionReference chatRef = firebaseFirestore.collection('Chat');

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController pseudoField = TextEditingController();
  final TextEditingController imageUrlField = TextEditingController();

  Future <void> logout() async {
    try {
      firebaseAuth.signOut().then((value) {
        debugPrint('logged out');
      });
    } catch (e) {
      debugPrint('logout: $e');
    }
  }

  void addUser(BuildContext context){
    try{
      if (pseudoField.text.isNotEmpty && imageUrlField.text.isNotEmpty) {
        userRef.add({
          'pseudo': pseudoField.text,
          'imageUrl': imageUrlField.text
        }).then((value) {
          debugPrint(value.id);
          pseudoField.clear();
          imageUrlField.clear();
          Navigator.pop(context);
        });
      }
    } catch (e) {
      debugPrint('addUser: $e');
    }
  }
  
  void showFloatingAction(BuildContext context){
    showModalBottomSheet<void>(
      isScrollControlled:  true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30)
        )
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 15, right: 30, left: 30, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                autofocus: true,
                controller: pseudoField,
                decoration: const InputDecoration(
                  hintText: 'Pseudo'
                ),
              ),
              TextField(
                controller: imageUrlField,
                decoration: const InputDecoration(
                  hintText: 'Photo de profil'
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => addUser(context),
                  child: const Text('Ajouter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      backgroundColor: defaultAppColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        leadingWidth: 0,
        title: const Text('FluttSenger',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {} , 
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton(
            tooltip: 'PopupMenu',
            icon: const Icon(Icons.more_vert),
            offset: const Offset(1.0, 3) ,
            onSelected: (value) {
              if (value == 2) {
                logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('item 1')
              ),
              const PopupMenuItem(
                padding: EdgeInsets.symmetric(horizontal: 15),
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red,),
                    Spacer(),
                    Text('Logout'),
                  ],
                )
              ),
            ],
          )
        ],
      ),
      body: Center(
        //child: SingleChildScrollView(
          child: Column(
            children: [
              //const SizedBox(height: 20,),
              header(),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height - 110,
                  padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30)
                    )
                  ),
                  child: const ListChatSection()
                ),
              )
            ],
          ),
        //),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showFloatingAction(context)
        },
        tooltip: 'Add person',
        backgroundColor: defaultAppColor,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget header(){
    late List <DocumentSnapshot> docs;

    return SizedBox(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 64,
            child: StreamBuilder <QuerySnapshot>(
              stream: userRef.where(FieldPath.documentId, isNotEqualTo: currentUserID).snapshots(),
              builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
                try {
                  
                  if (snapshot.hasError) return const Text('Something wrong..');

                  if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator.adaptive();
                  
                  if (!snapshot.hasData) return const LinearProgressIndicator(color: defaultAppColor,);
                  docs = snapshot.data!.docs;

                  if(docs.isEmpty) return const Center(child: Text('Aucun contact.'));

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: docs.map((DocumentSnapshot document) {
                      return AvatarStrokeGradient(
                        margin: const EdgeInsets.only(left: 10, right: 10), 
                        colors: const [Colors.amber, Colors.orange, Colors.purple], 
                        avatar: AvatarWidget(
                          userName: document['imageUrl'].isEmpty ? document['pseudo'] : null,
                          height: 60,
                          width: 60,
                          imagePath: document['imageUrl']
                        )
                      );
                    }).toList(),
                  );
                } catch (e) {
                  debugPrint(e.toString());
                  return ListView();
                }
              },
            ),
          ) 
        ],
      ),
    );
            
  }
}

void openChat(BuildContext context, String userID, String userName, String userPhoto){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatPage(userID, userName, userPhoto)),
  );
}

class UserLineDesign extends StatelessWidget {
  final String userID;
  final String userName;
  final String userPhoto;
  final String? lastMessage = '';
  final String? lastMessageDateTime ='';
  
  const UserLineDesign(
    this.userID, 
    this.userName, 
    this.userPhoto, 
    {Key? key, lastMessage, lastMessageDateTime}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 65,
      child: ListTile(
        onTap: () => openChat(context, userID, userName, userPhoto),
        leading: AvatarWidget(
          userName: userPhoto.isEmpty ? userName : null,
          height: 56,
          width: 56,
          imagePath: userPhoto,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text( userName,
              style: const TextStyle(
                fontSize: 18
              ),
            ),
            Text('03:54',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400]
              ),
            ),
          ],
        ),
        subtitle: Text(lastMessage!,
          softWrap: true,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            overflow: TextOverflow.ellipsis,
            height: 2
          ),
        ),
      ),
    );
  }
}

class ListChatSection extends StatefulWidget {
  const ListChatSection({ Key? key }) : super(key: key);

  @override
  State<ListChatSection> createState() => _ListChatSectionState();
}

class _ListChatSectionState extends State<ListChatSection> {
  late List<DocumentSnapshot> _docs;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userRef.where(FieldPath.documentId, isNotEqualTo: currentUserID).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) return const Text('Something wrong..');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        
        if (!snapshot.hasData) return const LinearProgressIndicator(color: defaultAppColor,);
        _docs = snapshot.data!.docs;
        
        if(_docs.isEmpty) return const Center(child: Text('Aucun contact.'));
        
        return ListView.builder(
          itemCount: _docs.length,
          itemBuilder: (context, index) {
            return UserLineDesign( _docs[index].id, _docs[index]['pseudo'], _docs[index]['imageUrl']);
          },
        );
      },
    );
  }
}
