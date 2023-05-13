enum Perfil {
  aluno,
  instrutor,
  nutricionista;

  @override
  String toString() {
    String perfil = super.toString().split('.').last;
    return perfil[0].toUpperCase() + perfil.substring(1);
  }

  bool isProfissional() {
    return this != Perfil.aluno;
  }

  bool isNutricionista() {
    return this == Perfil.nutricionista;
  }

  bool isInstrutor() {
    return this == Perfil.instrutor;
  }

  static Perfil fromValue(String value) {
    return Perfil.values.firstWhere((element) => element.toString() == value);
  }
}
