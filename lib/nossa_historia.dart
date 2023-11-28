import 'package:flutter/material.dart';

class NossaHistoria extends StatefulWidget {
  const NossaHistoria({Key? key}) : super(key: key);

  @override
  State<NossaHistoria> createState() => _NossaHistoriaState();
}

class _NossaHistoriaState extends State<NossaHistoria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 32,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.orange, size: 20),
                      ),
                    ],
                  ),
                  Image.asset(
                    "assets/images/tocadorato.png",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        style: TextStyle(
                            decorationStyle: TextDecorationStyle.wavy),
                        "      Nossa história começou há muito tempo, quando uma família resolveu comprar um boardgame para ver do que se tratava.\n"
                        "      Depois de experimentar, e ver que era bom, essa família decidiu comprar outro. E depois outro. E mais um...\n"
                        "      Com o passar dos anos, essa família apresentou boardgames para muitas pessoas, que também gostaram, e insentivaram essa família a comprar mais."
                        "Alguns anos depois, já não tinhamos quase espaço para guardar tantos jogos, e tampouco tempo para jogar tudo.\n"
                        "      Decidimos então procurar um destino melhor para tanto jogo, do que ficar juntando poeira em estantes e armários."
                        "(Claro que também não queriamos nos desfazer deles, afinal, faziam parte de nossa história."
                        "Decidimos deixar outras pessoas também conhecerem esse universo de boardgames. Fosse para conhecer novos jogos, ou para entrar nesse mundo"
                        "de um jeito mais em conta, já que boardgames não é um hobby barato de se ter.\n"
                        "      Assim surgiu a ideia de alugar a preços bem em conta todos os jogos do nosso acervo.\n"
                        "Claro que isso também foi mais uma desculpa para continuar comprando novos jogos..."
                        "É para os nossos clientes, diziamos..."),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
