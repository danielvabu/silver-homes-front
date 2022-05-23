class Pets {
  String? id;
  String? typeofpets;
  String? size;
  String? age;
  bool? error_typeofpets = false;
  bool? error_size = false;
  bool? error_age = false;

  Pets({
    this.id,
    this.typeofpets,
    this.size,
    this.age,
    this.error_typeofpets,
    this.error_size,
    this.error_age,
  });

  Pets.clone(Pets source)
      : this.id = source.id,
        this.typeofpets = source.typeofpets,
        this.size = source.size,
        this.age = source.age,
        this.error_typeofpets = source.error_typeofpets,
        this.error_size = source.error_size,
        this.error_age = source.error_age;

  factory Pets.fromJson(Map<String, dynamic> json) => Pets(
        id: json["id"],
        typeofpets: json["typeofpets"],
        size: json["size"],
        age: json["age"],
        error_typeofpets: json["error_typeofpets"],
        error_size: json["error_size"],
        error_age: json["error_age"],
      );

  Map toJson() => {
        "id": id,
        "typeofpets": typeofpets,
        "size": size,
        "age": age,
        "error_typeofpets": error_typeofpets,
        "error_size": error_size,
        "error_age": error_age,
      };
}

class Vehical {
  String? id;
  String? make;
  String? model;
  String? year;
  bool? error_make = false;
  bool? error_model = false;
  bool? error_year = false;

  Vehical({
    this.id,
    this.make,
    this.model,
    this.year,
    this.error_make,
    this.error_model,
    this.error_year,
  });

  Vehical.clone(Vehical source)
      : this.id = source.id,
        this.make = source.make,
        this.model = source.model,
        this.year = source.year,
        this.error_make = source.error_make,
        this.error_model = source.error_model,
        this.error_year = source.error_year;

  factory Vehical.fromJson(Map<String, dynamic> json) => Vehical(
        id: json["id"],
        make: json["make"],
        model: json["model"],
        year: json["year"],
        error_make: json["error_make"],
        error_model: json["error_model"],
        error_year: json["error_year"],
      );

  Map toJson() => {
        "id": id,
        "make": make,
        "model": model,
        "year": year,
        "error_make": error_make,
        "error_model": error_model,
        "error_year": error_year,
      };
}
