import 'package:flutter/material.dart';

class RecuperacaoSenhaView extends StatefulWidget {
  
  const RecuperacaoSenhaView({super.key});

  @override
  _RecuperacaoSenhaViewState createState() => _RecuperacaoSenhaViewState();
}

class _RecuperacaoSenhaViewState extends State<RecuperacaoSenhaView> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _recuperarSenha() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Instruções enviadas para o e-mail informado!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recuperar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Informe seu e-mail cadastrado para receber as instruções de recuperação.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? 'Informe um e-mail válido'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _recuperarSenha,
                child: Text('Recuperar Senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
