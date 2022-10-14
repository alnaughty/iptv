import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<String?> addUser(String docRefId, String url) async {
    // Call the user's CollectionReference to add a new user
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('user-data');

      users.doc(docRefId).set({"url": url});
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUrl(String docRefId) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('user-data');
      final DocumentSnapshot docu = await users.doc(docRefId).get();
      return docu.get("url");
    } catch (e) {
      return null;
    }
  }
}
