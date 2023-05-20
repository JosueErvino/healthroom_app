import 'package:url_launcher/url_launcher.dart';

class WhatsappService {
  static void abrirConversa(String telefone) {
    launchUrl(Uri.parse('https://wa.me/$telefone'));
  }
}
