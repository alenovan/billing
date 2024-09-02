part of 'configs_bloc.dart';

abstract class ConfigsState extends Equatable {
  const ConfigsState();
}

class ConfigsInitial extends ConfigsState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ConfigsLoadingState extends ConfigsState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ConfigsLoadedState extends ConfigsState {
  ResponseConfigsModels result;

  ConfigsLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class ConfigsListLoadedState extends ConfigsState {
  ResponseClientInformation result;

  ConfigsListLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class ConfigsErrorState extends ConfigsState {
  String message;

  ConfigsErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
