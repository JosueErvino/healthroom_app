class DateTimeService {
  String formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }

  static bool validarDataNascimento(String dataNascimento) {
    if (dataNascimento.isEmpty) {
      return false;
    }
    List<String> data = dataNascimento.split('/');
    if (data.length != 3) {
      return false;
    }
    int dia = int.parse(data[0]);
    int mes = int.parse(data[1]);
    int ano = int.parse(data[2]);
    if (dia < 1 || dia > 31) {
      return false;
    }
    if (mes < 1 || mes > 12) {
      return false;
    }
    if (ano < 1900 || ano > DateTime.now().year) {
      return false;
    }
    return true;
  }
}
