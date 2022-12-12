class Filter {
  Filter();

  String? minbed;
  String? maxbed;
  String? minaltitude;
  String? maxaltitude;
  String? city;
  String? province;
  String? minOpTime;
  String? maxOpTime;
  String? minEdTime;
  String? maxEdTime;

  Map<String, dynamic> toQueryParameters() {
    final query = <String, dynamic>{
      if (minbed?.isNotEmpty ?? false) 'min_bed_num': '$minbed',
      if (maxbed?.isNotEmpty ?? false) 'max_bed_num': '$maxbed',
      if (minaltitude?.isNotEmpty ?? false) 'min_altitude': '$minaltitude',
      if (maxaltitude?.isNotEmpty ?? false) 'max_altitude': '$maxaltitude',
      if (city?.isNotEmpty ?? false) 'city': '$city',
      if (province?.isNotEmpty ?? false) 'province': '$province',
      if (minOpTime?.isNotEmpty ?? false) 'min_opening_time': '$minOpTime',
      if (maxOpTime?.isNotEmpty ?? false) 'max_opening_time': '$maxOpTime',
      if (minEdTime?.isNotEmpty ?? false) 'min_closing_time': '$minEdTime',
      if (maxEdTime?.isNotEmpty ?? false) 'max_closing_time': '$maxEdTime',
    };
    return query;
  }

  bool isEmpty() => toQueryParameters().entries.isEmpty;
}
