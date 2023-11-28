import 'package:flutter/material.dart';
import 'package:toca_do_rato_jogos/firestore/models/jogos_first.dart';

class ListTileJogo extends StatelessWidget {
  final Jogos jogo;
  final bool isDisponivel;
  final Function iconClick;

  const ListTileJogo({
    super.key,
    required this.jogo,
    required this.isDisponivel,
    required this.iconClick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          iconClick(jogo);
        },
        icon: Icon(
          (isDisponivel) ? Icons.add : Icons.delete, color: Colors.green,
        ),
      ),
      title: Text(
        jogo.nome,
      ),
      subtitle: Text(
        (jogo.valor == null)
            ? "Clique para adicionar preço"
            : "R\$ ${jogo.valor.toStringAsFixed(2)}",
      ),
    );
  }
}
