class Filter {
  Filter();

  String? startAsc;
  String? endAsc;
  String? difficulty = 'ALL';
  String? startLen;
  String? endLen;
  String? city;
  String? province;
  static List<String> list = <String>['ALL', 'PH', 'H', 'T'];

  Map<String, dynamic> toQueryParameters() {
    Map<String, dynamic> query = {
      if (startAsc?.isNotEmpty ?? false) 'start_asc': "$startAsc",
      if (endAsc?.isNotEmpty ?? false) 'end_asc': "$endAsc",
      if (startLen?.isNotEmpty ?? false) 'start_len': "$startLen",
      if (endLen?.isNotEmpty ?? false) 'end_len': "$endLen",
      if ((difficulty?.isNotEmpty ?? false) && difficulty != 'ALL')
        'difficulty': "$difficulty",
      if (city?.isNotEmpty ?? false) 'city': "$city",
      if (province?.isNotEmpty ?? false) 'province': "$province",
    };
    return query;
  }

  bool isEmpty() => toQueryParameters().entries.isEmpty;
}
