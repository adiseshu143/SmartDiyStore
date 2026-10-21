import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;

  AuthRepositoryImpl({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  @override
  Stream<String?> get authStateChanges =>
      _firebaseService.auth.authStateChanges().map((user) => user?.uid);

  @override
  String? get currentUserId => _firebaseService.auth.currentUser?.uid;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseService.auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseService.auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (credential.user != null) {
      await _firebaseService.usersCollection.doc(credential.user!.uid).set({
        'id': credential.user!.uid,
        'email': email.trim(),
        'createdAt': DateTime.now().toIso8601String(),
        'isAdmin': false,
      });
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseService.auth.signOut();
  }
}
