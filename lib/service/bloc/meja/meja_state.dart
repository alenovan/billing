part of 'meja_bloc.dart';

abstract class MejaState extends Equatable {
  const MejaState();
}



class MejaInitial extends MejaState {
  @override
  List<Object> get props => [];
}


class MejaLoadingState extends MejaState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class MejaLoadedState extends MejaState {
  ResponseRoomsModels result;

  MejaLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}


class PanelLoadedState extends MejaState {
  ResponsePanelModels result;

  PanelLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class PanelUpdateLoadedState extends MejaState {
  ResponseUpdatePanelModels result;

  PanelUpdateLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}




class MejaErrorState extends MejaState {
  String message;

  MejaErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
