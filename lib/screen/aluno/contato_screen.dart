import 'package:flutter/material.dart';
import 'package:healthroom_app/model/contato.dart';
import 'package:healthroom_app/model/usuario.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'package:healthroom_app/services/database.dart';
import 'package:healthroom_app/services/whatsapp.dart';

class ContatoScreen extends StatelessWidget {
  const ContatoScreen({super.key});

  void _abrirWhatsapp(String telefone) {
    WhatsappService.abrirConversa(telefone);
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = UsuarioProvider.getProvider(context);
    final Future<List<Contato>> getContatos =
        DatabaseService().getContatos(usuario.uid);

    return FutureBuilder(
        future: getContatos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          if (snapshot.hasData) {
            final contatos = snapshot.data as List<Contato>;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: contatos.length,
              itemBuilder: (BuildContext context, int index) {
                final contato = contatos[index];
                return Center(
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    shadowColor: Colors.grey[400],
                    color: Colors.green[200],
                    child: ListTile(
                      leading: Icon(contato.tipo.isInstrutor()
                          ? Icons.fitness_center
                          : Icons.apple),
                      title: Text(contato.nome),
                      subtitle: Text(contato.tipo.toString()),
                      trailing: const Icon(Icons.chat_bubble),
                      onTap: () => _abrirWhatsapp(contato.telefone),
                    ),
                  ),
                );
              },
            );
          }

          return const Loading();
        });
  }
}
