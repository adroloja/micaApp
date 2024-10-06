import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mica/controller/auth/Authenticate.dart';
import 'package:mica/controller/auth/google/GoogleController.dart';
import 'package:mica/controller/auth/keycloak/CheckUserController.dart';
import 'package:mica/dto/UserGoogleInfo.dart';
import 'package:mica/screens/main_screen.dart';
import 'package:mica/utils/constants.dart';
import 'package:mica/utils/secure_storage.dart';
import 'package:mica/widget/loggin/apple_button.dart';
import 'package:mica/widget/loggin/google_button.dart';
import 'package:mica/widget/loggin/facebook_button.dart';

const List<String> scopes = <String>[
  'email',
  'profile',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isExternalServiceAuth = false;
  bool _isPasswordVisible = false;
  late StreamSubscription<GoogleSignInAccount?> _subscription;
  String? typeLogin;

  @override
  void initState() {
    super.initState();
    getTypeLogin();
    _subscription = _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      if (account != null) {
        account.authentication.then((GoogleSignInAuthentication auth) {
          String? accessToken = auth.accessToken;
          if (accessToken != null) {
            validateInfo(accessToken);
          }
        }).catchError((error) {
          print('Error during Google authentication: $error');
        });
      }
    });

    try {
      _clearFormData();
    } catch (err) {
      print(err);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  getTypeLogin() async {
    typeLogin = await SecureStorage.read(key: "type");
  }

  Future<void> _clearFormData() async {
    await SecureStorage.delete(key: 'sign_firstName');
    await SecureStorage.delete(key: 'sign_lastName');
    await SecureStorage.delete(key: 'sign_number');
    await SecureStorage.delete(key: 'sign_email');
    await SecureStorage.delete(key: 'sign_password');
    await SecureStorage.delete(key: 'sign_password2');
    await SecureStorage.delete(key: 'sign_isAcceptTerms');
    await SecureStorage.delete(key: 'sign_isAcceptPriv');
    await SecureStorage.delete(key: 'selfieImageBase64');
  }

  Future<void> validateInfo(String accessToken) async {
    GoogleController googleController = GoogleController();
    UserGoogleInfo? user = await googleController.getUserInfo(accessToken);

    if (user != null) {
      setState(() {
        isExternalServiceAuth = true;
      });
      CheckUserController checkUserController = CheckUserController();
      try {
        bool userExists = await checkUserController.check(user.email);
        if (userExists) {
          // intentar con default password y si no con el que este guardado
          _loginWithExternal();
        } else {
          Navigator.of(context).pushNamed('/signup_google');
        }
      } catch (err) {
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_LONG,
            msg: "\n ${err.toString()} \n");
      }
    } else {
      Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          msg:
              "\n Error al validar la identidad, por favor utilice otro método, gracias. \n");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.69;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 55),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.23,
                  child: ImageIcon(
                    const AssetImage('assets/logotipo.png'),
                    size: iconSize,
                  ),
                ),
                SizedBox(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Introduce un correo',
                      labelText: 'Correo',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce un username';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Introduce la contraseña',
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce una contraseña';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/recovery');
                  },
                  child: const Text("Olvidé la contraseña"),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: FacebookSignInButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("/splash");
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: GoogleSignInButton(
                        onPressed: () async {
                          await _googleSignIn
                              .signOut(); // Sign out before sign in to ensure new sign in
                          await _googleSignIn.signIn();
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: AppleSignInButton(
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Entrar'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "¿Aún no te has registrado?",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(
                  height: 4,
                ),
                TextButton(
                  onPressed: _isLoading ? null : _goToSignupScreen,
                  child: const Text('Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      // print("El password que paso desde el login es: $password");
      final bool isValid =
          await Authenticate().auth(username.trim().toLowerCase(), password);

      if (isValid) {
        await SecureStorage.write(key: username, value: password);
        await SecureStorage.write(key: 'username', value: username);
        Credentials.email = username;
        Credentials.isExternal = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          msg:
              '\n Error al iniciar sesión, compruebe que su correo esta verificado y/o la contraseña sea la correcta \n',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
        msg:
            '\n Usuario y/o contraseña incorrectos. Por favor, inténtelo de nuevo \n',
      );
    } finally {
      try {
        setState(() {
          _isLoading = false;
        });
      } catch (e) {}
    }
  }

  Future<void> _loginWithExternal() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String? username = await SecureStorage.read(key: "username");

      // if (passwordStored != null && passwordStored != defaultPassword) {
      //   print("pass : $passwordStored");
      //   pass = passwordStored;
      //   Credentials.password = pass;
      // }

      // if (passwordStored == null) {
      //   await SecureStorage.write(key: username!, value: "W9z!6Pq#Vt8Lx7");
      //   pass = defaultPassword;
      //   Credentials.password = pass;
      // }

      final bool isValid =
          await Authenticate().auth(username!, "W9z!6Pq#Vt8Lx7");

      if (isValid) {
        Credentials.isExternal = true;
        await SecureStorage.write(key: 'password', value: "W9z!6Pq#Vt8Lx7");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        Fluttertoast.showToast(
          msg:
              '\n Error al iniciar sesión, compruebue que su correo esta verificado y/o la contraseña sea la correcta \n',
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
        msg:
            '\n Usuario y/o contraseña incorrectos. Por favor, inténtelo de nuevo \n',
      );
    } finally {
      try {
        setState(() {
          _isLoading = false;
        });
      } catch (e) {}
    }
  }

  void _goToSignupScreen() {
    Navigator.of(context).pushNamed('/signup');
  }
}
