class Taggs {
  List tag = [];
  String? id;
  Taggs({required this.tag ,this.id});

  Taggs.fromMap(Map<String, dynamic> map) {
    tag = map['selectedValues'] ?? '';
    id = map['id'];
  }
}