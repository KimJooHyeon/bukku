import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/book_model.dart';

class BookRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Helper method to get the current user's book collection
  CollectionReference<Map<String, dynamic>>? _getBooksCollection() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid).collection('books');
  }

  // 1. Get Books Stream (Ordered by CreatedAt Descending)
  Stream<List<Book>> getBooksStream() {
    final collection = _getBooksCollection();
    if (collection == null) return Stream.value([]);

    return collection.orderBy('created_at', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Book.fromDocument(doc)).toList();
    });
  }

  // 2. Add Book
  Future<void> addBook(Book book) async {
    final collection = _getBooksCollection();
    if (collection == null) throw Exception("User not logged in");

    // 저장 시 생성 시간 추가
    final bookToSave = book.copyWith(createdAt: DateTime.now());

    await collection.add(bookToSave.toJson());
  }

  // 3. Update Book
  Future<void> updateBook(Book book) async {
    final collection = _getBooksCollection();
    if (collection == null) throw Exception("User not logged in");
    if (book.id.isEmpty) throw Exception("Book ID is empty");

    await collection.doc(book.id).update(book.toJson());
  }

  // 4. Delete Book
  Future<void> deleteBook(String bookId) async {
    final collection = _getBooksCollection();
    if (collection == null) throw Exception("User not logged in");

    await collection.doc(bookId).delete();
  }

  // 5. Upload Book Cover
  Future<String> uploadBookCover(XFile image) async {
    final user = _auth.currentUser;
    // User must be logged in to upload to their folder
    if (user == null) throw Exception("User not logged in");

    final ref = _storage.ref().child(
      'users/${user.uid}/books/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    // XFile.readAsBytes() works on both web and mobile
    final bytes = await image.readAsBytes();
    final metadata = SettableMetadata(contentType: 'image/jpeg');

    final uploadTask = ref.putData(bytes, metadata);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
