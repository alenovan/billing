part of 'meja_bloc.dart';

abstract class MejaEvent extends Equatable {
  const MejaEvent();
}

class GetMeja extends MejaEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetPanel extends MejaEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class updatePanel extends MejaEvent {
  RequestPanelModels payload;
  String id;

  updatePanel({required this.payload,required this.id});
  @override
  // TODO: implement props
  List<Object> get props => [payload,id];
}





