import 'package:equatable/equatable.dart';
import 'package:news/core/models/source.dart';
import 'package:news/core/utils/meta_type.dart';

class NewsMeta extends Equatable {
  final String name;
  final String id;
  final MetaType metaType;
  bool isSelected;

  NewsMeta({required this.name, required this.id, required this.metaType, this.isSelected = false});


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'newsMetaId': id,
      'type': metaType.index,
    };
  }

  factory NewsMeta.fromMap(Map<String, dynamic> map) {
    return NewsMeta(name: map['name'],
        id: map['newsMetaId'],
        metaType: MetaType.values[map['type']],
    );
  }

  @override
  List<Object?> get props => [id, name, metaType];

  @override
  bool get stringify => true;
}