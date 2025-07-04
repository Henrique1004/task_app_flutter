import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroView extends StatefulWidget {

  const CadastroView({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();

}

class _CadastroScreenState extends State<CadastroView> {
  
  final telefoneFormatter = MaskTextInputFormatter(
  mask: '(##) #####-####',
  filter: { "#": RegExp(r'[0-9]') },
  );
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  void _cadastrar(String nome, String email, String telefone, String senha) {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha)
          .then((res) {
        FirebaseFirestore.instance.collection('users').add({
          "uid": res.user!.uid.toString(),
          "nome": nome,
          "email": email,
          "telefone": telefone,
        });
        exibirSucesso();
        Navigator.pop(context);
      }).catchError((e) {
          exibirErro();
      });
    }  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um e-mail';
                  }
                  final emailRegex = RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                  );

                  if (!emailRegex.hasMatch(value)) {
                    return 'E-mail inválido';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Celular'),
                keyboardType: TextInputType.phone,
                inputFormatters: [telefoneFormatter],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o celular';
                  } else if (!telefoneFormatter.isFill()) {
                    return 'Celular incompleto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }

                  final hasUppercase = value.contains(RegExp(r'[A-Z]'));
                  final hasLowercase = value.contains(RegExp(r'[a-z]'));
                  final hasDigit = value.contains(RegExp(r'\d'));
                  final hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                  if (!(hasUppercase && hasLowercase && hasDigit && hasSpecialChar)) {
                    return 'Senha fraca. Use letras maiúsculas, minúsculas, números \ne caracteres especiais.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmarSenhaController,
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (value) => value != _senhaController.text
                    ? 'As senhas não coincidem'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {_cadastrar(_nomeController.text, _emailController.text, _telefoneController.text, 
                _senhaController.text);},
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void exibirSucesso() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cadastro realizado com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  void exibirErro() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Houve um erro ao realizar cadastro.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
