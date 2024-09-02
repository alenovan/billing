import 'package:bloc/bloc.dart';
import 'package:carabaobillingapps/service/models/configs/RequestConfigsModels.dart';
import 'package:carabaobillingapps/service/models/configs/ResponseConfigsModels.dart';
import 'package:carabaobillingapps/service/repository/ConfigRepository.dart';
import 'package:equatable/equatable.dart';

import '../../models/configs/ResponseClientInformation.dart';

part 'configs_event.dart';
part 'configs_state.dart';

class ConfigsBloc extends Bloc<ConfigsEvent, ConfigsState> {
  ConfigRepo repository;

  ConfigsBloc({required this.repository}) : super(ConfigsInitial()) {
    on<ConfigsEvent>((event, emit) async {
      if (event is ActConfig) {
        emit(ConfigsLoadingState());
        try {
          final result = await repository.updateConfig(event.payload);
          emit(ConfigsLoadedState(result: result));
        } catch (e) {
          emit(ConfigsErrorState(message: e.toString()));
        }
      }
      if (event is GetConfig) {
        emit(ConfigsLoadingState());
        try {
          final result = await repository.getConfig();
          emit(ConfigsListLoadedState(result: result));
        } catch (e) {
          emit(ConfigsErrorState(message: e.toString()));
        }
      }
    });
  }
}
