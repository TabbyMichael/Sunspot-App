import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sunspot/features/orders/bloc/orders_event.dart';
import 'package:sunspot/features/orders/bloc/orders_state.dart';
import 'package:sunspot/features/orders/data/orders_repository.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _repository;

  OrdersBloc(this._repository) : super(OrdersInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<FetchOrderDetails>(_onFetchOrderDetails);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await _repository.fetchOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onFetchOrderDetails(
    FetchOrderDetails event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final order = await _repository.getOrderById(event.orderId);
      emit(OrderDetailsLoaded(order));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await _repository.updateOrderStatus(event.orderId, event.status);
      add(FetchOrders());
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
