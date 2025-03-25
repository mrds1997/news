import 'package:equatable/equatable.dart';


class ErrorEntity extends Equatable{
  final String? status;
  final String? code;
  final String? message;


  const ErrorEntity(this.status, this.code, this.message);

  @override
  List<Object?> get props => [status, code, message];

}