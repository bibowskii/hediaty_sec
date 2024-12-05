//supposedly done

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get document ID based on attribute
  Future<String?> getDocID(String collection, String attribute, String value) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(collection)
          .where(attribute, isEqualTo: value)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return documentSnapshot.id;
      }
      return null;
    } catch (e) {
      print("Error getting document ID: $e");
      return null;
    }
  }

  // Add data and return the document ID
  Future<String?> addData(String collection, Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = await _db.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      print("Error adding data: $e");
      return null;
    }
  }

  // Get all data from the collection and return a list of maps
  Future<List<Map<String, dynamic>>> getData(String collection) async {
    try {
      QuerySnapshot snapshot = await _db.collection(collection).get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error getting data: $e");
      return [];
    }
  }

  // Query to get a list of documents based on a specific attribute and value
  Future<List<Map<String, dynamic>>> getList(String collection, String attribute, String value) async {
    List<Map<String, dynamic>> documents = [];

    try {
      QuerySnapshot querySnapshot = await _db
          .collection(collection)
          .where(attribute, isEqualTo: value)
          .get();

      for (var doc in querySnapshot.docs) {
        documents.add(doc.data() as Map<String, dynamic>);
      }
      return documents;
    } catch (e) {
      print("Error getting list of documents: $e");
      return [];
    }
  }

  // Query to get a document based on a specific attribute and value (e.g., userId)
  Future<Map<String, dynamic>?> getDocumentByAttribute(String collection, String attribute, String value) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(collection)
          .where(attribute, isEqualTo: value)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting document by attribute: $e");
      return null;
    }
  }

  // Get document by docID
  Future<Map<String, dynamic>?> getDocument(String collection, String documentId) async {
    try {
      DocumentSnapshot doc = await _db.collection(collection).doc(documentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }

  // Update data in a document by its ID
  Future<void> updateData(String collection, String documentId, Map<String, dynamic> data) async {
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
}
