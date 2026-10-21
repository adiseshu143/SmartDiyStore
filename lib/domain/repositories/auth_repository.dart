abstract class AuthRepository {
  Stream<String?> get authStateChanges;
  Future<void> signInWithEmailAndPassword({required String email, required String password});
  Future<void> signUpWithEmailAndPassword({required String email, required String password});
  Future<void> signOut();
  String? get currentUserId;
}
