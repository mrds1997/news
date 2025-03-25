class NewsParam{
  String? _country;
  String? _category;
  String? _source;
  String? _query;
  String? _language;
  int? _pageSize;
  int? _page;

  String get country => _country!;

  set country(String value) {
    _country = value;
  }

  String get category => _category!;

  int get page => _page!;

  set page(int value) {
    _page = value;
  }

  int get pageSize => _pageSize!;

  set pageSize(int value) {
    _pageSize = value;
  }

  String get language => _language!;

  set language(String value) {
    _language = value;
  }

  String get query => _query!;

  set query(String value) {
    _query = value;
  }

  String get source => _source!;

  set source(String value) {
    _source = value;
  }

  set category(String value) {
    _category = value;
  }
}