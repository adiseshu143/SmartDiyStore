abstract class ProductRepository {
  Future<List<Map<String, dynamic>>> getProducts({String? category});
  Future<Map<String, dynamic>?> getProductById(String id);
  Future<void> updateProductStock(String id, int quantity);
}
