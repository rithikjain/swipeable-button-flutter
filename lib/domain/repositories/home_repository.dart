import 'package:cred_assignment/data/models/response_model.dart';
import 'package:either_dart/either.dart';

abstract class HomeRepository {
  Future<Either<ResponseModel, String>> getResponse({bool isSuccess = true});
}
