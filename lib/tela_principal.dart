import 'package:flutter/material.dart';
import 'package:receitas/lista_de_receitas.dart';

class TelaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Receitas"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
            ),
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://receitastanahora.com.br/wp-content/uploads/2021/09/receitas-ta-na-hora-logotipo.png"
                  ))
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaDeReceitas()),
                );
              },
              child: Text("Acessar Receitas"),
            ),
          ],
        ),
      ),
    );
  }
}