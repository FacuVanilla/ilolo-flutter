class Lga {
  final String name;

  Lga({required this.name});

  factory Lga.fromJson(String json) {
    return Lga(name: json);
  }
}

class StateDataModel {
  final String state;
  final String alias;
  final List<Lga> lgas;

  StateDataModel({required this.state, required this.alias, required this.lgas});

  factory StateDataModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> lgaList = json['lgas'];
    List<Lga> lgas = lgaList.map((lga) => Lga.fromJson(lga)).toList();

    return StateDataModel(
      state: json['state'],
      alias: json['alias'],
      lgas: lgas,
    );
  }
}