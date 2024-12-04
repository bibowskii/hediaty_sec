import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // get document ID
  Future<String?> getDocID(
      String collection, String attribute, String value) async {
    QuerySnapshot querySnapshot = await _db
        .collection(collection)
        .where(attribute, isEqualTo: value)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.id;
    }
    return null;
  }

  // Add data and return the document ID
  Future<String?> addData(String collection, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = await _db.collection(collection).add(data);
      return docRef.id; // Return the document ID
    } catch (e) {
      print("Error adding data: $e");
      return null; // Return null in case of failure
    }
  }

  // Get data from the collection and return a list of maps
  Future<List<Map<String, dynamic>>> getData(String collection) async {
    try {
      QuerySnapshot snapshot = await _db.collection(collection).get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error getting data: $e");
      return []; // Return an empty list in case of failure
    }
  }

  // Get a single document by its ID
  Future<Map<String, dynamic>?> getDocument(
      String collection, String documentId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection(collection).doc(documentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print("Error getting document: $e");
      return null; // Return null if document doesn't exist or error occurs
    }
  }

  // Update data in a document by its ID
  Future<void> updateData(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collection).doc(documentId).update(data);
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  // Delete a document by its ID
  Future<void> deleteData(String collection, String documentId) async {
    try {
      await _db.collection(collection).doc(documentId).delete();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  Future<void> deleteDataByAtt(String collection, String documentId) async {
    try {
      await _db.collection(collection).doc(documentId).delete();
    } catch (e) {
      print("Error deleting data: $e");
    }
  }


  Future<List<Map<String, dynamic>>> getList(String collection,
      String attribute, String value) async {
    List<Map<String, dynamic>> documents = []; // Initialize an empty list

    try {
      QuerySnapshot querySnapshot = await _db
          .collection(collection)
          .where(attribute, isEqualTo: value)
          .get();

      for (var doc in querySnapshot.docs) {
        documents.add(doc.data() as Map<String, dynamic>); // Add to the list
      }
      return documents;
    } catch (e) {
      print(e.toString());
    }

    return documents; // Return the populated list
  }
}
