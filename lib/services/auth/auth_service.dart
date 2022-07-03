import 'package:blackout/services/auth/auth_user.dart';
import 'package:blackout/services/auth/auth_provider.dart';

class Authservice implements AuthProvider {
  final AuthProvider provider;

  Authservice(this.provider);
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
}
