import 'package:cred_assignment/data/models/response_model.dart';
import 'package:cred_assignment/domain/repositories/home_repository.dart';
import 'package:either_dart/either.dart';

class GetResponseUsecase {
  final HomeRepository _homeRepository;

  GetResponseUsecase(this._homeRepository);

  Future<Either<ResponseModel, String>> call({bool isSuccess = true}) {
    return _homeRepository.getResponse(isSuccess: isSuccess);
  }
}
