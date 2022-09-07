import 'package:cred_assignment/data/datasources/remote/remote_datasource.dart';
import 'package:cred_assignment/data/repositories/home_repository_impl.dart';
import 'package:cred_assignment/domain/repositories/home_repository.dart';
import 'package:cred_assignment/domain/usecases/get_response_usecase.dart';
import 'package:cred_assignment/presentation/features/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  // Ideally should use DI, but didn't feel it was required for this scale
  late final RemoteDataSource _remoteDataSource;
  late final HomeRepository _homeRepository;
  late final GetResponseUsecase _getResponseUsecase;

  HomeCubit() : super(InitialState()) {
    _remoteDataSource = RemoteDataSource();
    _homeRepository = HomeRepositoryImpl(_remoteDataSource);
    _getResponseUsecase = GetResponseUsecase(_homeRepository);
  }

  void getResult(bool isSuccess) async {
    emit(LoadingState());

    var result = await _getResponseUsecase(isSuccess: isSuccess);

    result.fold(
      (left) {
        if (left.success ?? false) {
          emit(SuccessState());
        } else {
          emit(FailureState("Failure :("));
        }
      },
      (right) => emit(FailureState(right)),
    );
  }

  void resetCard() {
    emit(InitialState());
  }
}
