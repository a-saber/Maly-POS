import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';

part 'get_clients_state.dart';

class GetClientsCubit extends Cubit<GetClientsState> {
  GetClientsCubit(this.repo) : super(GetClientsInitial());

  static GetClientsCubit get(context) => BlocProvider.of(context);

  final ClientsRepo repo;

  List<CustomerModel> clients = [];

  ScrollController scrollController = ScrollController();

  bool canLoading() => repo.getCustomerModel?.nextPageUrl != null;

  void init() {
    getClients();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (canLoading() && !_isLoading) {
          getClientsPagination();
        }
      }
    });
  }

  bool ifScrollNotFillScreen() {
    if (!scrollController.hasClients) return false;
    return scrollController.position.maxScrollExtent == 0;
  }

  void ifNotFillScreen() {
    if (canLoading()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ifScrollNotFillScreen()) {
          Future.delayed(
              const Duration(seconds: AppConstant.callPaginationSeconds), () {
            log("getPaginationPermissions");
            // ignore: use_build_context_synchronously
            getClientsPagination();
          });
        }
      });
    }
  }

  Future<void> getClients({
    isRefresh = false,
  }) async {
    emit(GetClientsLoading());
    // await Future.delayed(const Duration(seconds: 10));
    var response = await repo.getClients(
      isRefresh: isRefresh,
    );

    response
        .fold((errMessage) => emit(GetClientsFailing(errMessage: errMessage)),
            (clients) {
      if (isRefresh) {
        this.clients = [];
      }
      this.clients.addAll(clients);
      ifNotFillScreen();
      emit(GetClientsSuccess());
    });
  }

  bool _isLoading = false;

  Future<void> getClientsPagination() async {
    if (_isLoading) return;
    _isLoading = true;
    var response = await repo.getClients();

    response.fold(
        (errMessage) =>
            emit(GetClientsPaginationFailing(errMessage: errMessage)),
        (clients) {
      this.clients.addAll(clients);
      ifNotFillScreen();
      _isLoading = false;
      emit(GetClientsSuccess());
    });
  }

  void addClient(CustomerModel client) {
    if (!canLoading()) {
      clients.add(client);
      emit(GetClientsSuccess());
    }
  }

  void deleteClient(int id) {
    clients.removeWhere((element) => element.id == id);
    emit(GetClientsSuccess());
  }

  void editClient(CustomerModel client) {
    clients[clients.indexWhere((element) => element.id == client.id)] = client;
    emit(GetClientsSuccess());
  }

  void reset() {
    clients = [];
    repo.resetGetCustomers();
  }

  @override
  void emit(GetClientsState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
