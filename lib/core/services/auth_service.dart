import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Получение текущего пользователя
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Поток изменений состояния аутентификации
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Вход по email и паролю
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок аутентификации
      throw Exception(e.message);
    }
  }

  // Регистрация по email и паролю
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок аутентификации
      throw Exception(e.message);
    }
  }

  // Выход из системы
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Возможно, добавьте другие методы, например, сброс пароля, обновление профиля и т.д.
}