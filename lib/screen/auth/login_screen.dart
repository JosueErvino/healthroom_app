import 'package:flutter/material.dart';
import 'package:healthroom_app/screen/auth/cadastro_screen.dart';
import 'package:healthroom_app/services/auth.dart';
import 'package:healthroom_app/services/dialog.dart';

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

      AuthService().login(email, senha).catchError((onError) {
        DialogService().showAlertDialog(context, '', onError.toString());
      });
    }

    void handleCadastro() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CadastroScreen()),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ElevatedButton(
              onPressed: handleLogin,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: handleCadastro,
              child: const Text('Cadastre-se aqui!'),
            ),
          ],
        ),
      ),
    );
  }
}
