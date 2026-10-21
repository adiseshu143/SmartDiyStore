import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase data sources and caching orchestration layer for SmartDiyStore.
class FirebaseService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : auth = auth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  // Collection References
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get productsCollection =>
      firestore.collection('products');

  CollectionReference<Map<String, dynamic>> get ordersCollection =>
      firestore.collection('orders');

  CollectionReference<Map<String, dynamic>> get tutorialsCollection =>
      firestore.collection('tutorials');

  CollectionReference<Map<String, dynamic>> get servicesCollection =>
      firestore.collection('services');
}
