import 'package:flutter/material.dart';
import 'lista_de_ingredientes.dart';
import 'models/receita.dart';
import 'services/banco_service.dart';

class ListaDeReceitas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListaDeReceitasState();
  }
}

class _ListaDeReceitasState extends State<ListaDeReceitas> {
  final _service = BancoService();
  var _nomeController = TextEditingController();

  List<Receita> _receitas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _carregar() async {
    try {
      var lista = await _service.listarReceitas();
      if (!mounted) return;
      setState(() {
        _receitas = lista;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      _mostrarMensagem("Erro ao carregar receitas: $e");
    }
  }

  Future<void> _adicionarReceita() async {
    var nome = _nomeController.text.trim();
    if (nome.isEmpty) {
      _mostrarMensagem("Digite o nome da receita");
      return;
    }
    try {
      var nova = await _service.criarReceita(nome);
      if (!mounted) return;
      setState(() {
        _receitas.add(nova);
      });
      _nomeController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem("Erro ao salvar receita: $e");
    }
  }

  Future<void> _removerReceita(Receita receita) async {
    var confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Apagar receita"),
        content: Text(
            "Deseja apagar \"${receita.nome}\" e todos os seus ingredientes?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Apagar"),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    try {
      await _service.removerReceita(receita.id);
      if (!mounted) return;
      setState(() {
        _receitas.remove(receita);
      });
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem("Erro ao apagar receita: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Lista de Receitas"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _nomeController,
                    onSubmitted: (_) => _adicionarReceita(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Nome da receita"),
                      hintText: "Ex. Strogonoff de frango",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: _adicionarReceita,
                  child: Text("Adicionar Receita"),
                ),
              ),
            ],
          ),
          Expanded(
            child: _carregando
                ? Center(child: CircularProgressIndicator())
                : _receitas.isEmpty
                    ? Center(child: Text("Nenhuma receita cadastrada"))
                    : RefreshIndicator(
                        onRefresh: _carregar,
                        child: ListView.builder(
                          itemCount: _receitas.length,
                          itemBuilder: (context, index) {
                            var receita = _receitas[index];
                            return ListTile(
                              leading: Icon(Icons.menu_book),
                              title: Text(receita.nome),
                              subtitle: Text(
                                  "${receita.quantidadeIngredientes} ingredientes"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _removerReceita(receita),
                                    icon: Icon(Icons.delete),
                                  ),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ListaDeIngredientes(receita: receita),
                                  ),
                                );
                                _carregar();
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}