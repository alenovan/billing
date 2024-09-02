part of 'configs_bloc.dart';

abstract class ConfigsEvent extends Equatable {
  const ConfigsEvent();
}

class ActConfig extends ConfigsEvent {
  RequestConfigsModels payload;

  ActConfig({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class GetConfig extends ConfigsEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
