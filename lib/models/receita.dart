class Receita {
  int id;
  String nome;
  int quantidadeIngredientes;

  Receita({
    required this.id,
    required this.nome,
    this.quantidadeIngredientes = 0,
  });

  // Aceita tanto { id, nome } quanto { id, nome, ingredientes: [{count: 3}] }
  factory Receita.fromMap(Map<String, dynamic> map) {
    var contagem = 0;
    final ing = map['ingredientes'];
    if (ing is List && ing.isNotEmpty) {
      contagem = ing[0]['count'] as int;
    }
    return Receita(
      id: map['id'] as int,
      nome: map['nome'] as String,
      quantidadeIngredientes: contagem,
    );
  }
}