import 'package:bloc/bloc.dart';
import 'package:carabaobillingapps/service/models/order/RequestChangeTable.dart';
import 'package:carabaobillingapps/service/models/order/RequestOrderSearch.dart';
import 'package:carabaobillingapps/service/models/order/RequestOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/RequestStopOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/RequestVoidOrder.dart';
import 'package:carabaobillingapps/service/models/order/ResponseChangeTable.dart';
import 'package:carabaobillingapps/service/models/order/ResponseDetailHistory.dart';
import 'package:carabaobillingapps/service/models/order/ResponseListOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseStopOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseVoidOrder.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:equatable/equatable.dart';

import '../../models/order/ResponseOrderHistoryModels.dart';
import '../../models/order/ResponseOrdersBgModels.dart';
import '../../models/order/ResponseOrdersOpenBillingModels.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderRepo repository;

  OrderBloc({required this.repository}) : super(OrdersInitial()) {
    on<OrderEvent>((event, emit) async {
      if (event is ActOrderOpenBilling) {
        emit(OrdersLoadingState());
        try {
          final result = await repository.order_open_billing(event.payload);
          emit(OrdersLoadedOpenBillingState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }
      if (event is ActStopOrderOpenBilling) {
        emit(OrdersLoadingState());
        try {
          final result =
              await repository.stop_order_open_billing(event.payload);
          emit(OrdersStopLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }

      if (event is ActStopOrderOpenAutoBilling) {
        emit(OrdersLoadingState());
        try {
          final result =
          await repository.stop_order_open_billing(event.payload);
          emit(OrdersStopOpenBillingLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }


      if (event is ActOrderOpenTable) {
        emit(OrdersLoadingState());
        try {
          final result = await repository.order_open_table(event.payload);
          emit(OrdersLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }
      if (event is ActStopOrderOpenTable) {
        emit(OrdersLoadingState());
        try {
          final result = await repository.stop_order_open_table(event.payload);
          emit(OrdersStopLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }

      if (event is GetOrder) {
        emit(OrdersLoadingState());
        try {
          final result = await repository.getOrder();
          emit(OrdersListLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }

      if (event is GetOrderBg) {
        try {
          final result = await repository.getOrderBg();
          emit(OrdersListBgLoadedState(result: result));
        } catch (e) {}
      }

      if (event is ActOrderHistory) {
        emit(OrdersLoadingState());
        try {
          final result = await repository.OrderHistory(event.payload);
          emit(OrdersHistoryLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }
      if (event is ActChangetableTable) {
        emit(OrdersChangeTableLoadingState());
        try {
          final result = await repository.changeTable(event.payload);
          emit(OrdersChangeTableLoadedState(result: result));
        } catch (e) {
          emit(OrdersChangetableErrorState(message: e.toString()));
        }
      }

      if (event is ActVoid) {
        emit(OrdersVoidLoadingState());
        try {
          final result = await repository.voidTable(event.payload);
          emit(OrdersVoidLoadedState(result: result));
        } catch (e) {
          emit(OrdersVoidErrorState(message: e.toString()));
        }
      }

      if (event is getDetailHistory) {
        emit(OrdersDetailHistoryLoadingState());
        try {
          final result = await repository.historyDetail(event.id);
          emit(OrdersDetailHistoryLoadedState(result: result));
        } catch (e) {
          emit(OrdersDetailHistoryErrorState(message: e.toString()));
        }
      }

      if (event is getDetailOrders) {
        emit(OrdersLoadingState());
        try {
          final result = await repository.getOrdersDetail(event.id);
          emit(OrdersDetailLoadedState(result: result));
        } catch (e) {
          emit(OrdersErrorState(message: e.toString()));
        }
      }
    });
  }
}
