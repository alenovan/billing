part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class ActOrderOpenBilling extends OrderEvent {
  RequestOrdersModels payload;

  ActOrderOpenBilling({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class ActStopOrderOpenBilling extends OrderEvent {
  RequestStopOrdersModels payload;

  ActStopOrderOpenBilling({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class ActStopOrderOpenAutoBilling extends OrderEvent {
  RequestStopOrdersModels payload;

  ActStopOrderOpenAutoBilling({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class ActOrderOpenTable extends OrderEvent {
  RequestOrdersModels payload;

  ActOrderOpenTable({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class ActStopOrderOpenTable extends OrderEvent {
  RequestStopOrdersModels payload;

  ActStopOrderOpenTable({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class GetOrder extends OrderEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetOrderBg extends OrderEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ActOrderHistory extends OrderEvent {
  RequestOrderSearch payload;

  ActOrderHistory({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class ActChangetableTable extends OrderEvent {
  RequestChangeTable payload;

  ActChangetableTable({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class ActVoid extends OrderEvent {
  RequestVoidOrder payload;

  ActVoid({required this.payload});

  @override
  // TODO: implement props
  List<Object> get props => [payload];
}

class getDetailHistory extends OrderEvent {
  String id;

  getDetailHistory({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class getDetailOrders extends OrderEvent {
  String id;

  getDetailOrders({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}
