import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';
import 'package:fl_chart/fl_chart.dart';

class EstatisticasView extends StatelessWidget {
  final UsuarioDTO usuario;

  const EstatisticasView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ListasBD>(
          builder: (context, listasBD, child) {
            final listas = listasBD.getListasDoUsuario(usuario.uid);

            int totalListas = listas.length;
            int totalTarefas = 0;
            int tarefasConcluidas = 0;

            for (var lista in listas) {
              final atividades = List<Map<String, dynamic>>.from(lista['lista_atividades'] ?? []);
              totalTarefas += atividades.length;
              tarefasConcluidas += atividades.where((a) => a['concluida'] == true).length;
            }

            double porcentagemConclusao = totalTarefas > 0
                ? (tarefasConcluidas / totalTarefas) * 100
                : 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      'Estatísticas Gerais',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Total de listas: $totalListas'),
                Text('Total de tarefas: $totalTarefas'),
                Text('Tarefas concluídas: $tarefasConcluidas'),
                Text('Progresso geral: ${porcentagemConclusao.toStringAsFixed(0)}%'),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      'Progresso por Lista',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: 100,
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, _) {
                              if (value < listas.length) {
                                final nome = listas[value.toInt()]['nome'] ?? 'Lista';
                                return Text(
                                  nome.length > 5 ? '${nome.substring(0, 5)}...' : nome,
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: listas.asMap().entries.map((entry) {
                        final index = entry.key;
                        final lista = entry.value;
                        final atividades = List<Map<String, dynamic>>.from(lista['lista_atividades'] ?? []);
                        final total = atividades.length;
                        final concluidas = atividades.where((a) => a['concluida'] == true).length;
                        final double progresso = total > 0 ? (concluidas / total) * 100.0 : 0.0;

                        return BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                            toY: progresso,
                            color: Colors.blue,
                            width: 14,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
