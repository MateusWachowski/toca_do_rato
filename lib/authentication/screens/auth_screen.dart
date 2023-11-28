import 'package:flutter/material.dart';
import 'package:toca_do_rato_jogos/nossa_historia.dart';
import '../component/show_snackbar.dart';
import '../services/auth_services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool isEntrando = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        "assets/images/tocadorato.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        (isEntrando)
                            ? "Bem vindo a Toca do Rato"
                            : "Vamos começar?",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Stack(alignment: Alignment.center, children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: 30,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NossaHistoria(),
                          ));
                        },
                        child: const Text("Conheça nossa história"),
                      ),
                    ]),
                    Text(
                      (isEntrando)
                          ? "Faça login para conhecer nosso acervo."
                          : "Faça seu cadastro para começar a alugar Boardgames.",
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(label: Text("E-mail")),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "O valor de e-mail deve ser preenchido";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "O valor do e-mail deve ser válido";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(label: Text("Senha")),
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: isEntrando,
                      child: TextButton(
                        onPressed: () {
                          esqueciMinhaSenhaClicado();
                        },
                        child: const Text("Esqueci minha senha."),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                          visible: !isEntrando,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _confirmaController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  label: Text("Confirme a senha"),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 4) {
                                    return "Insira uma confirmação de senha válida.";
                                  }
                                  if (value != _senhaController.text) {
                                    return "As senhas devem ser iguais.";
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _nomeController,
                                decoration: const InputDecoration(
                                  label: Text("Nome"),
                                ),
                                validator: (value) {
                                  if (value == null || value.length < 3) {
                                    return "Insira um nome maior.";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        botaoEnviarClicado();
                      },
                      child: Text(
                        (isEntrando) ? "Entrar" : "Cadastrar",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEntrando = !isEntrando;
                        });
                      },
                      child: Text(
                        (isEntrando)
                            ? "Ainda não tem conta?\nClique aqui para cadastrar."
                            : "Já tem uma conta?\nClique aqui para entrar",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      padding: const EdgeInsetsDirectional.only(bottom: 0),
                      alignment: Alignment.bottomCenter,
                      child: const Text(
                          "created by Mateus Wachowski",
                      style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoEnviarClicado() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String nome = _nomeController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntrando) {
        _entrarUsuario(email: email, senha: senha);
      } else {
        _criarUsuario(email: email, senha: senha, nome: nome);
      }
    }
  }

  _entrarUsuario({required String email, required String senha}) {
    authService.entrarUsuario(email: email, senha: senha).then((String? erro) {
      if (erro == null) {
        showSnackBar(
          context: context,
          mensagem: "Logado com sucesso",
          isErro: false,
        );
      } else {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }

  _criarUsuario(
      {required String email, required String senha, required String nome}) {
    authService
        .cadastrarUsuario(
      email: email,
      senha: senha,
      nome: nome,
    )
        .then((String? erro) {
      if (erro == null) {
        showSnackBar(
            context: context,
            mensagem: "Conta criada com sucesso!",
            isErro: false);
      } else {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }

  esqueciMinhaSenhaClicado() {
    String email = _emailController.text;
    authService.redefinicaoSenha(email: email).then((String? erro) {
      if (erro == null) {
        showSnackBar(
          context: context,
          mensagem: "E-mail de redefinição enviado.",
          isErro: false,
        );
      } else {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }
}
