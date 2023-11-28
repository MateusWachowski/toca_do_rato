//ARQUIVO QUE REPRESENTA A PRIMEIRA CAMADA DO FIRESTORE - A LISTA QUE CONTEM TODOS OS JOGOS
//E TODOS OS CAMPOS QUE CADA JOGO TEM

class Jogos {
  String id;
  String nome;
  bool isDisponivel;
  String img;
  int valor;
  String link;
  String complexidade;
  String qtdplayers;
  String idioma;

  Jogos({
  this.isDisponivel= true,
  required this.id,
  required this.nome,
  required this.img,
  required this.valor,
  required this.link,
  required this.complexidade,
  required this.qtdplayers,
  required this.idioma,
  });

  Jogos.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nome = map["nome"],
        img = map["img"],
        valor = map["valor"],
        link = map["link"],
        complexidade = map["nvlcomplexo"],
        qtdplayers = map["qtdplayers"],
        idioma = map["idioma"],
        isDisponivel =map["disponivel"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": nome,
      "img": img,
      "valor": valor,
      "link": link,
      "nvlcomplexo": complexidade,
      "qtdplayers": qtdplayers,
      "idioma": idioma,
      "disponivel": isDisponivel,
    };
  }
}
