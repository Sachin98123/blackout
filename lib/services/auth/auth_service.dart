import 'package:blackout/services/auth/auth_user.dart';
import 'package:blackout/services/auth/auth_provider.dart';
import 'package:blackout/services/auth/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice implements AuthProvider {
  final AuthProvider provider;

  Authservice(this.provider);
  factory Authservice.firebase() => Authservice(FirebaseAuthProvider());
  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String password, required String email}) =>
      provider.logIn(password: password, email: email);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
