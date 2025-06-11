import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';
import 'package:task_app_flutter/firebase_options.dart';

import 'package:task_app_flutter/view/ad_lista_view.dart';
import 'package:task_app_flutter/view/cadastro_view.dart';
import 'package:task_app_flutter/view/detalhe_lista_view.dart';
import 'package:task_app_flutter/view/estatisticas_view.dart';
import 'package:task_app_flutter/view/listas_concluidas_view.dart';
import 'package:task_app_flutter/view/listas_view.dart';
import 'package:task_app_flutter/view/login_view.dart';
import 'package:task_app_flutter/view/recuperacao_view.dart';
import 'package:task_app_flutter/view/sobre_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => 
        ChangeNotifierProvider(
          create: (context) => ListasBD(),
          child: const MainApp(),
        ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'sobre': (context) => const SobreView(),
        'cadastro': (context) => const CadastroView(),
        'recuperacaoSenha': (context) => const RecuperacaoSenhaView(),

        'listas': (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as UsuarioDTO;
          return TodoListsView(usuario: usuario);
        },

        'adicionaLista': (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as UsuarioDTO;
          return AdListaView(usuario: usuario);
        },

        'verLista': (context) {
          final lista = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return DetalheListaView(lista: lista);
        },

        'listasConcluidas': (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as UsuarioDTO;
          return ListasConcluidasView(usuario: usuario);
        },

        'estatisticas': (context) {
          final usuario = ModalRoute.of(context)!.settings.arguments as UsuarioDTO;
          return EstatisticasView(usuario: usuario);
        },
      },
    );
  }
}
