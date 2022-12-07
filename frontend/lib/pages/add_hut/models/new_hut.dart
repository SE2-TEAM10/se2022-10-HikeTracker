class NewHut {
  NewHut({
    this.name,
    this.hhOp,
    this.mmOp,
    this.hhEd,
    this.mmEd,
    this.bednum,
    this.description,
    this.phone,
    this.mail,
    this.website,
    this.city,
    this.province,
    this.altitude,
    this.latitude,
    this.longitude,
  });

  final String? name;
  final int? hhOp;
  final int? mmOp;
  final int? hhEd;
  final int? mmEd;
  final String? bednum;
  final String? phone;
  final String? description;
  final String? mail;
  final String? website;
  final String? city;
  final String? province;
  final String? altitude;
  final String? latitude;
  final String? longitude;

  Map<String, dynamic> toMap() => {
        'name': name,
        'opening_time': '$hhOp:$mmOp',
        'closing_time': '$hhEd:$mmEd',
        'bed_num': bednum,
        'description': description,
        'altitude': altitude,
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'province': province,
        'phone': phone,
        'mail': mail,
        'website': website,
      };

/*
  bool isFull() =>
      name != null &&
      hhOp != null &&
      mmOp != null &&
      hhEd != null &&
      mmEd != null &&
      difficulty != null &&
      description != null &&
      startp != null &&
      endp != null &&
      gpx != null;
*/
  NewHut copyWith({
    String? name,
    int? hhOp,
    int? mmOp,
    int? hhEd,
    int? mmEd,
    String? bednum,
    String? phone,
    String? description,
    String? mail,
    String? website,
    String? city,
    String? province,
    String? altitude,
    String? latitude,
    String? longitude,
  }) =>
      NewHut(
        name: name ?? this.name,
        hhOp: hhOp ?? this.hhOp,
        mmOp: mmOp ?? this.mmOp,
        hhEd: hhEd ?? this.hhEd,
        mmEd: mmEd ?? this.mmEd,
        bednum: bednum ?? this.bednum,
        description: description ?? this.description,
        phone: phone ?? this.phone,
        mail: mail ?? this.mail,
        website: website ?? this.website,
        city: city ?? this.city,
        province: province ?? this.province,
        altitude: altitude ?? this.altitude,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
