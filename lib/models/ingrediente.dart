class Ingrediente {
  int? id; // nulo até ser salvo no banco
  int receitaId;
  String nome;
  String quantidade;

  Ingrediente({
    this.id,
    required this.receitaId,
    required this.nome,
    required this.quantidade,
  });

  factory Ingrediente.fromMap(Map<String, dynamic> map) {
    return Ingrediente(
      id: map['id'] as int,
      receitaId: map['receita_id'] as int,
      nome: map['nome'] as String,
      quantidade: map['quantidade'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receita_id': receitaId,
      'nome': nome,
      'quantidade': quantidade,
    };
  }
}