import '../../domain/repositories/product_repository.dart';
import '../datasources/firebase_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseService _firebaseService;

  ProductRepositoryImpl({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  @override
  Future<List<Map<String, dynamic>>> getProducts({String? category}) async {
    var query = _firebaseService.productsCollection.limit(50);
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  @override
  Future<Map<String, dynamic>?> getProductById(String id) async {
    final doc = await _firebaseService.productsCollection.doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...?doc.data()};
  }

  @override
  Future<void> updateProductStock(String id, int quantity) async {
    await _firebaseService.productsCollection.doc(id).update({'stock': quantity});
  }
}
