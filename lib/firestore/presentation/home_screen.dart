import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toca_do_rato_jogos/firestore_jogo/presentation/jogo_screen.dart';
import '../models/jogos_first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../authentication/component/show_senha_confirmacao_dialog.dart';
import '../../authentication/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Jogos> listJogos = [
    //A LISTA DE JOGOS COM O CONTEUDO DE CADA JOGO
    // Jogos(id: "Salen 1602",
    //     nome: "Salen 1602",
    //     complexidade: "3 - medio",
    //     idioma: "pt-br",
    //     img: "https://67287.cdn.simplo7.net/static/67287/sku/jogos-de-tabuleiro-e-cardgames-salem-1692-colecao-cidades-sombrias-2-1625147524756.jpg",
    //     link: "",
    //     qtdplayers: "4-8",
    //     valor: 10),
    // Jogos(id: "Salen 1602",
    //     nome: "Salen 1602",
    //     complexidade: "3 - medio",
    //     idioma: "pt-br",
    //     img: "https://67287.cdn.simplo7.net/static/67287/sku/jogos-de-tabuleiro-e-cardgames-salem-1692-colecao-cidades-sombrias-2-1625147524756.jpg",
    //     link: "",
    //     qtdplayers: "4-8",
    //     valor: 10),                MODELOS DE TESTE ANTES DE IMPLEMENTAR O BANCO DE DADOS
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text("Remover conta"),
              onTap: () {
                showSenhaConfirmacaoDialog(context: context, email: "");
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
              onTap: () {
                fecharListaSelecionada();
                AuthService().deslogar();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Nosso acervo de Jogos",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //BOTÃO PARA ATUALUZAR A LISTA DE JOGOS
        onPressed: () {
          refresh();
        },
        child: const Icon(Icons.refresh_sharp),
      ),
      body: (listJogos.isEmpty)
          ? const Center(
              child: Text(
                "Nada para mostrar aqui ainda",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              children: List.generate(
                listJogos.length,
                (index) {
                  Jogos model = listJogos[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JogoScreen(jogo: model),
                        ),
                      );
                    },
                    leading: Image(
                        image: NetworkImage(model.img),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover),
                    title: Text(
                      model.nome,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text("Para ${model.qtdplayers} Jogadores"),
                  );
                },
              ),
            ),
    );
  }

  refresh() async {
    List<Jogos> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("jogos").get();

    for (var doc in snapshot.docs) {
      temp.add(Jogos.fromMap(doc.data()));
    }
    setState(() {
      listJogos = temp;
    });
  }
  fecharListaSelecionada() async{
    for (Jogos jogo in listJogos){
      jogo.isDisponivel = true;

      await firestore
          .collection("jogos")
          .doc(jogo.id).update({"disponivel" : jogo.isDisponivel});
    }
  }
}
