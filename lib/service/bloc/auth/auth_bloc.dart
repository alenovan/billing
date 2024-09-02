import 'package:bloc/bloc.dart';
import 'package:carabaobillingapps/service/models/auth/RequestLoginModels.dart';
import 'package:carabaobillingapps/service/models/auth/ResponseLoginModels.dart';
import 'package:carabaobillingapps/service/repository/LoginRepository.dart';
import 'package:equatable/equatable.dart';

import '../../../constant/data_constant.dart';
import '../../../helper/shared_preference.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  LoginRepo repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is ActLogin) {
        emit(AuthLoadingState());
        try {
          final result = await repository.actLogin(event.payload);
          await addStringSf(ConstantData.token, result.data!.token);
          await addBoolSf(ConstantData.is_login, true);
          await addStringSf(ConstantData.is_timer, result.data!.isTimer.toString());
          emit(AuthLoadedState(result: result));
        } catch (e) {
          emit(AuthErrorState(message: e.toString()));
        }
      }
    });
  }
}
