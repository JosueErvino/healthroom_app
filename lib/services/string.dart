class StringService {
  String firstName(String? name) {
    return name!.split(' ')[0];
  }
}
