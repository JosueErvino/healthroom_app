import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/auth/cadastro_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/services/dialog.dart';
import 'package:healthroom_app/services/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void handleLogin() {
      final email = _emailController.text;
      final senha = _senhaController.text;

      AuthService.login(email, senha).catchError((onError) {
        SnackBarService.showSnackbarError(context, onError.toString());
      });
    }

    void handleCadastro() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CadastroScreen()),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 30,
              children: [
                const Image(
                  image: AssetImage('assets/img/logo.png'),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 20),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
                TextButton(
                  onPressed: handleCadastro,
                  child: const Text('Cadastre-se aqui!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
