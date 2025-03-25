import 'error_entity.dart';

class ErrorResponseModel extends ErrorEntity {

  const ErrorResponseModel({required this.status, required this.code, required this.message}) : super(status, code,message);

  final String? status;

  final String? code;

  final String? message;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) =>
      ErrorResponseModel(
          status : json["status"],
          code: json["code"],
          message: json["message"]
      );
}


