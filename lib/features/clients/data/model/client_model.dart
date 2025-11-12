class ClientModel {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? commercialRegister;
  String? taxIdentificationNumber;
  String? note;
  String? imagePath;

  ClientModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.commercialRegister,
    this.taxIdentificationNumber,
    this.note,
    this.imagePath,
  });

  static ClientModel from(ClientModel source) {
    return ClientModel(
      id: source.id,
      name: source.name,
      phone: source.phone,
      email: source.email,
      address: source.address,
      commercialRegister: source.commercialRegister,
      taxIdentificationNumber: source.taxIdentificationNumber,
      note: source.note,
      imagePath: source.imagePath,
    );
  }

  static ClientModel fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      commercialRegister: json['commercial_register'],
      taxIdentificationNumber: json['tax_identification_number'],
      note: json['note'],
      imagePath: json['image_path'],
    );
  }
}
