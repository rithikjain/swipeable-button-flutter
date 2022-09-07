import 'package:cred_assignment/data/datasources/remote/remote_datasource.dart';
import 'package:cred_assignment/data/models/response_model.dart';
import 'package:cred_assignment/domain/repositories/home_repository.dart';
import 'package:either_dart/either.dart';

class HomeRepositoryImpl extends HomeRepository {
  final RemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<ResponseModel, String>> getResponse({
    bool isSuccess = true,
  }) async {
    return await _remoteDataSource.getResponse(isSuccess: isSuccess);
  }
}
