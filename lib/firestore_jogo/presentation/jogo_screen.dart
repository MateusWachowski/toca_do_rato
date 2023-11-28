import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toca_do_rato_jogos/authentication/component/show_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firestore/models/jogos_first.dart';
import 'widgets/list_tile_produto.dart';

class JogoScreen extends StatefulWidget {

  final Jogos jogo;

  const JogoScreen({super.key, required this.jogo});

  Future<void> launchLink(Uri url) async {
    if(await canLaunchUrl(url)){
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    }
  }



  @override
  State<JogoScreen> createState() => _JogoScreenState();
}

class _JogoScreenState extends State<JogoScreen> {
  List<Jogos> listaJogosSelecionados = [];

  List<Jogos> listaJogosDisponiveis = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.jogo.nome, style: const TextStyle(color: Colors.black, fontSize: 23),)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if (listaJogosSelecionados.isEmpty) {
          showSnackBar(context: context, mensagem: "Selecione pelo menos um jogo para entrar em contato via WhatsApp.");
          }else {
            var whatsappUrl = "http://web.whatsapp.com/send?phone=555183153480&text=Olá.\nGostaria de alugar os seguintes jogos:\n${mensagemEnviar()}No valor de ${totalDiaria()} reais a diária.\nPodemos combinar os dias?";
            await launchUrl(Uri.parse(whatsappUrl));
            fecharListaSelecionada();
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check_circle_outline),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(                                  // <<<<<--------- COMEÇAR O CORPO AQUI!!!!!
              children: [
                Text(
                  "R\$${totalDiaria().toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 42),
                ),
                const Text(
                  "total da diária",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(thickness: 2),
          ),
          const Text(
            "Jogos Escolhidos",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: List.generate(listaJogosSelecionados.length, (index) {
              Jogos jogo = listaJogosSelecionados[index];
              return ListTileJogo(
                jogo: jogo,
                isDisponivel: false,
                iconClick: alterarDisponivel,
              );
            }),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(thickness: 2),
          ),
          const Text(
            "Jogo Disponível",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: List.generate(listaJogosDisponiveis.length, (index) {
              Jogos jogo = listaJogosDisponiveis[index];
              return ListTile(
                leading: IconButton(
                  onPressed: () {
                    alterarDisponivel(jogo);
                  },
                  icon: const Icon(
                    Icons.add, color: Colors.green,
                  ),
                ),
                title: Text(jogo.nome),
                subtitle: Padding(
                  padding: const EdgeInsets.only(right: 50, bottom: 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(jogo.img, fit: BoxFit.cover, height: 100, width: 100,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nivel de complexidade: nível ${jogo.complexidade}"),
                            Text("Idioma: ${jogo.idioma}", textAlign: TextAlign.start),
                            Text("Jogadores: ${jogo.qtdplayers}", textAlign: TextAlign.start),
                            Text("Valor: ${jogo.valor.toStringAsFixed(2)} reais"),
                            TextButton.icon(
                              icon: const Icon(Icons.link),
                              label: const Text("Saiba mais na Ludopedia.", style: TextStyle(color: Colors.blue),),
                              onPressed: (){
                                launchUrl(Uri.parse(jogo.link));
                              }
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  refresh() async {
    List<Jogos> tempSelecionados = await filtrarJogos(false);
    //List<Jogos> tempDisponiveis = await filtrarJogos(true);

    setState(() {
      listaJogosDisponiveis = [widget.jogo];
      listaJogosSelecionados = tempSelecionados;
    });
  }

  Future<List<Jogos>> filtrarJogos(bool isDisponivel) async{
    List<Jogos> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection("jogos").where("disponivel", isEqualTo: isDisponivel).get();

    for (var doc in snapshot.docs){
      Jogos jogos = Jogos.fromMap(doc.data());
      temp.add(jogos);
    }
    return temp;
  }

  alterarDisponivel(Jogos jogo) async{
    jogo.isDisponivel =! jogo.isDisponivel;

    await firestore
        .collection("jogos")
        .doc(jogo.id).update({"disponivel" : jogo.isDisponivel});

    refresh();
  }

  int totalDiaria(){
    int total = 0;
    for (Jogos jogo in listaJogosSelecionados) {
      total += jogo.valor;
    }
    return total;
  }

  String mensagemEnviar(){
    String mensagem = "";
    for (Jogos jogo in listaJogosSelecionados) {
      mensagem += "${jogo.nome},\n";
    }
    return mensagem;
  }

  fecharListaSelecionada() async{
    for (Jogos jogo in listaJogosSelecionados){
      jogo.isDisponivel = true;

      await firestore
          .collection("jogos")
          .doc(jogo.id).update({"disponivel" : jogo.isDisponivel});
    }
    refresh();
  }

}
