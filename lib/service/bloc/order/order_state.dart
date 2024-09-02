part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();
}

class OrdersInitial extends OrderState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OrdersLoadingState extends OrderState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OrdersLoadedState extends OrderState {
  ResponseOrdersModels result;

  OrdersLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersLoadedOpenBillingState extends OrderState {
  ResponseOrdersOpenBillingModels result;

  OrdersLoadedOpenBillingState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersStopLoadedState extends OrderState {
  ResponseStopOrdersModels result;

  OrdersStopLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersStopOpenBillingLoadedState extends OrderState {
  ResponseStopOrdersModels result;

  OrdersStopOpenBillingLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}


class OrdersListLoadedState extends OrderState {
  ResponseListOrdersModels result;

  OrdersListLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersListBgLoadedState extends OrderState {
  ResponseOrdersBgModels result;

  OrdersListBgLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersErrorState extends OrderState {
  String message;

  OrdersErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class OrdersHistoryLoadedState extends OrderState {
  ResponseOrderHistoryModels result;

  OrdersHistoryLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

// Change Table
class OrdersChangeTableLoadingState extends OrderState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OrdersChangeTableLoadedState extends OrderState {
  ResponseChangeTable result;

  OrdersChangeTableLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersChangetableErrorState extends OrderState {
  String message;

  OrdersChangetableErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

// Void
class OrdersVoidLoadingState extends OrderState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OrdersVoidLoadedState extends OrderState {
  ResponseVoidOrder result;

  OrdersVoidLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersVoidErrorState extends OrderState {
  String message;

  OrdersVoidErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

// Void
class OrdersDetailHistoryLoadingState extends OrderState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OrdersDetailHistoryLoadedState extends OrderState {
  ResponseDetailHistory result;

  OrdersDetailHistoryLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}

class OrdersDetailHistoryErrorState extends OrderState {
  String message;

  OrdersDetailHistoryErrorState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}


class OrdersDetailLoadedState extends OrderState {
  ResponseListOrdersModels result;

  OrdersDetailLoadedState({required this.result});

  @override
  // TODO: implement props
  List<Object> get props => [result];
}