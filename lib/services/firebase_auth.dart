import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv/services/firestore_service.dart';
import 'package:vtv/utils/global.dart';

class FirebaseAuthServices {
  final FirestoreServices _services = FirestoreServices();
  Future<String?> register(
      String emailAddress, String password, String url) async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      if (credential.user == null) return null;
      // fireuserId = credential.user!.uid;
      cacher.setUID(credential.user!.uid);
      await _services.addUser(credential.user!.uid, url);
      return url;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "Le mot de passe fourni est trop faible.");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Fluttertoast.showToast(msg: "Le compte existe déjà pour cet e-mail.");
      } else {
        Fluttertoast.showToast(
            msg: "Une erreur d'authentification non définie s'est produite.");
      }

      return null;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Une erreur inattendue est apparue.");
      return null;
    }
  }

  Future<String?> login(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      final User? user = credential.user;
      if (user == null) return null;
      // fireuserId = credential.user!.uid;
      cacher.setUID(credential.user!.uid);
      String? url = await _services.getUrl(user.uid);
      return url;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('User not found');
        Fluttertoast.showToast(msg: "Utilisateur non trouvé.");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Fluttertoast.showToast(msg: "Mot de passe incorrect");
      }
      return null;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Une erreur inattendue est apparue.");
      return null;
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
