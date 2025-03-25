import 'package:news/core/models/source.dart';
import 'package:news/core/utils/meta_type.dart';

class NewsMeta {
  final String name;
  final String id;
  final MetaType metaType;

  NewsMeta({required this.name, required this.id, required this.metaType});
}