import 'package:url_launcher/url_launcher.dart';

class WhatsappService {
  static void abrirConversa(String telefone) {
    launchUrl(Uri.parse('https://wa.me/+55$telefone'));
  }

  static void abrirConversaAndroid(String telefone) {
    launchUrl(Uri.parse("whatsapp://send?phone=+55$telefone"));
  }
}
