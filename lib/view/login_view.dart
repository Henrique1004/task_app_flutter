import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_app_flutter/entities/usuario.dart';

class LoginView extends StatefulWidget {

  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

void _login(String email, String senha) {
  FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: senha)
      .then((res) async {
    final uid = res.user!.uid;

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final data = doc.data();
      final nome = data['nome'] ?? 'Usuário';

      UsuarioDTO usuario = UsuarioDTO(
        uid,
        nome,
      );

      exibirSucesso(nome);
      Navigator.pushReplacementNamed(
        context,
        'listas',
        arguments: usuario,
      );
    } else {
      UsuarioDTO usuario = UsuarioDTO(uid, 'Usuário');
      exibirSucesso(usuario.nome);
      Navigator.pushReplacementNamed(
        context,
        'listas',
        arguments: usuario,
      );
    }
  }).catchError((e) {
    exibirErro();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagens/logo.png',
                    height: 120,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu e-mail';
                      }

                      final emailRegex = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                      );

                      if (!emailRegex.hasMatch(value)) {
                        return 'Insira um e-mail válido';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {_login(_emailController.text, _senhaController.text);},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Entrar'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'cadastro');
                        },
                        child: Text('Criar conta'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'recuperacaoSenha');
                        },
                        child: Text('Esqueceu a senha?'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'sobre');
                        },
                        child: Text('Sobre'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void exibirSucesso(String nome) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bem-vindo ${nome}!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  void exibirErro() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuário ou senha inválidos'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

}
