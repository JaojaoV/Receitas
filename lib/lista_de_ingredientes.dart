import 'package:flutter/material.dart';
import 'models/ingrediente.dart';
import 'models/receita.dart';
import 'services/banco_service.dart';

class ListaDeIngredientes extends StatefulWidget {
  final Receita receita;

  const ListaDeIngredientes({super.key, required this.receita});

  @override
  State<StatefulWidget> createState() {
    return _ListaDeIngredientesState();
  }
}

class _ListaDeIngredientesState extends State<ListaDeIngredientes> {
  final _service = BancoService();
  var _nomeController = TextEditingController();
  var _qtdController = TextEditingController();

  List<Ingrediente> _ingredientes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _qtdController.dispose();
    super.dispose();
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  Future<void> _carregar() async {
    try {
      var lista = await _service.listarIngredientes(widget.receita.id);
      if (!mounted) return;
      setState(() {
        _ingredientes = lista;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      _mostrarMensagem("Erro ao carregar ingredientes: $e");
    }
  }

  Future<void> _adicionar() async {
    var nome = _nomeController.text.trim();
    var qtd = _qtdController.text.trim();
    if (nome.isEmpty || qtd.isEmpty) {
      _mostrarMensagem("Preencha todos os campos");
      return;
    }
    try {
      var salvo = await _service.adicionarIngrediente(
        Ingrediente(receitaId: widget.receita.id, nome: nome, quantidade: qtd),
      );
      if (!mounted) return;
      setState(() {
        _ingredientes.add(salvo);
      });
      _nomeController.clear();
      _qtdController.clear();
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem("Erro ao salvar ingrediente: $e");
    }
  }

  Future<void> _remover(Ingrediente ingrediente) async {
    try {
      await _service.removerIngrediente(ingrediente.id!);
      if (!mounted) return;
      setState(() {
        _ingredientes.remove(ingrediente);
      });
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem("Erro ao remover ingrediente: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.receita.nome),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Nome do ingrediente"),
                hintText: "Ex. Farinha de trigo",
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _qtdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Quantidade"),
                      hintText: "Ex. 2 xícaras",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: _adicionar,
                  child: Text("Adicionar Ingredientes"),
                ),
              ),
            ],
          ),
          Expanded(
            child: _carregando
                ? Center(child: CircularProgressIndicator())
                : _ingredientes.isEmpty
                    ? Center(child: Text("Nenhum ingrediente cadastrado"))
                    : ListView.builder(
                        itemCount: _ingredientes.length,
                        itemBuilder: (context, index) {
                          var ingrediente = _ingredientes[index];
                          return ListTile(
                            leading: Icon(Icons.restaurant),
                            title: Text(ingrediente.nome),
                            subtitle: Text(ingrediente.quantidade),
                            trailing: IconButton(
                              onPressed: () => _remover(ingrediente),
                              icon: Icon(Icons.delete),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}