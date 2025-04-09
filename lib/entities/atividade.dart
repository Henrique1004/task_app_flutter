class Atividade {
  
  String nome;
  bool concluida;

  Atividade(this.nome, [this.concluida = false]);

  void editar(nome) {
    this.nome = nome;
  }

}
