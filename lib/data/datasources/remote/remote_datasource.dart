import 'package:cred_assignment/data/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class RemoteDataSource {
  Future<Either<ResponseModel, String>> getResponse({
    bool isSuccess = true,
  }) async {
    try {
      dynamic response;
      if (isSuccess) {
        response =
            await Dio().get("https://api.mocklets.com/p68348/success_case");
      } else {
        response =
            await Dio().get("https://api.mocklets.com/p68348/failure_case");
      }

      return Left(ResponseModel.fromJson(response.data));
    } catch (e) {
      return Right(e.toString());
    }
  }
}
