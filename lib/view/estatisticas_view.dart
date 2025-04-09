import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app_flutter/database/listas_bd.dart';
import 'package:task_app_flutter/entities/usuario.dart';
import 'package:fl_chart/fl_chart.dart';

class EstatisticasView extends StatelessWidget {

  final Usuario usuario;

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
            final listas = ListasBD.listas
                .where((lista) => lista.criador.email == usuario.email)
                .toList();

            int totalListas = listas.length;
            int totalTarefas = 0;
            int tarefasConcluidas = 0;

            for (var lista in listas) {
              totalTarefas += lista.listaAtividades.length;
              tarefasConcluidas += lista.listaAtividades
                  .where((atividade) => atividade.concluida)
                  .length;
            }

            double porcentagemConclusao = totalTarefas > 0 ? (tarefasConcluidas / totalTarefas) * 100 : 0;

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
                      maxY: 100, // fixa o eixo Y até 100%
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, _) {
                              if (value < listas.length) {
                                return Text(
                                  listas[value.toInt()].nome.length > 5
                                      ? '${listas[value.toInt()].nome.substring(0, 5)}...'
                                      : listas[value.toInt()].nome,
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: listas.asMap().entries.map((entry) {
                        final index = entry.key;
                        final lista = entry.value;
                        final total = lista.listaAtividades.length;
                        final concluidas = lista.listaAtividades
                            .where((a) => a.concluida)
                            .length;
                        final double progresso = total > 0 ? (concluidas / total) * 100 : 0;

                        return BarChartGroupData(x: index, barRods: [
                          BarChartRodData(
                            toY: progresso,
                            color: Colors.blue,
                            width: 14,
                            borderRadius: BorderRadius.circular(6),
                          )
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
