import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterchat/widget/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('Chat')
                .orderBy('CreatedAt', descending: true)
                .snapshots(),
            builder: (ctx, chatsnapShot) {
              print(chatsnapShot);
              if (chatsnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatsnapShot.data.documents;
              return ListView.builder(
                itemCount: chatDocs.length,
                reverse: true,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index]['Text'],
                  futureSnapshot.data.uid == chatDocs[index]['userId'],
                  chatDocs[index]['userName'],
                  chatDocs[index]['userImage'],
                  key: ValueKey(chatDocs[index].documentID),
                ),
              );
            });
      },
    );
  }
}
