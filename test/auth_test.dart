import 'package:blackout/services/auth/auth_exception.dart';
import 'package:blackout/services/auth/auth_provider.dart';
import 'package:blackout/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('should not be initialized to begin with ', () {
      expect(provider.isInitialized, false);
    });
    test('cannot log out ', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('should be abe to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('user should be null after initialization', () {
      expect(provider.currentUser, null);
    });
    test('should be able to initialize within two second ', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('create user should be deligated to login function', () {
      final badEmailUser = provider.createUser(
          email: 'foobar@gmail.com', password: 'anypassword');
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFound>()));
      final badPasswordUser =
          provider.createUser(email: 'foobar@gamil.com', password: 'foobar');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
    });
    test('logged in user should be able to get verified', () async {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('should be able to log in and log out', () async {
      await provider.logIn(email: 'email', password: 'password');
      await provider.logOut();
      final user = provider.currentUser;
      expect(user,null);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String password, required String email}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foobar@gmail.com') throw UserNotFound();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFound();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFound();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
