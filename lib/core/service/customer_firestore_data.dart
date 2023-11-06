import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerFirestoreData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference? ref;
  String donation = 'donation';
  String subscription = 'subscription';
  String token = 'token';

  CustomerFirestoreData() {
    ref = _db.collection("update later");
  }

  Future<QuerySnapshot>? getDataCollection() {
    return ref?.get();
  }

  Stream<QuerySnapshot>? streamDataCollection() {
    return ref?.snapshots();
  }

  Future<DocumentSnapshot>? getCustomerId(String userId) {
    return ref?.doc(userId).get();
  }

  Future? removeDocument(String id) {
    return ref?.doc(id).delete();
  }

  Future? addCustomer(var data, var docId) {
    return ref?.doc(docId).set(data);
  }

  Future? addCustomerDonation(var data, var docId) {
    return ref?.doc(docId).collection(donation).doc().set(data);
  }

  Future? addCustomerSubscription(var data, var docId) {
    return ref?.doc(docId).collection(subscription).doc().set(data);
  }
  Future? addCustomerToken(var data, var docId) {
    return ref?.doc(docId).collection(token).doc().set(data);
  }

  Future? updateDocument(Map data, String id) {
    return ref?.doc(id).set(data, SetOptions(merge: true));
  }
}
