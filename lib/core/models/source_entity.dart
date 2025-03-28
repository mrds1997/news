import 'package:equatable/equatable.dart';
import 'package:news/core/models/source.dart';

import 'article.dart';


class SourceEntity extends Equatable{
  final String status;
  final List<Source> sources;


  const SourceEntity(this.status, this.sources);

  @override
  List<Object?> get props => [status, sources];

}