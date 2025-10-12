import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/api/api_response.dart';
import 'package:pos_app/core/constant/constant.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';

part 'search_client_state.dart';

class SearchClientCubit extends Cubit<SearchClientState> {
  SearchClientCubit(this.repo) : super(SearchClientInitial());
  static SearchClientCubit get(context) => BlocProvider.of(context);

  final ClientsRepo repo;

  ScrollController scrollController = ScrollController();

  List<CustomerModel> clients = [];
  String query = '';

  bool canLoading() => repo.getCustomerSearchModel?.nextPageUrl != null;
  bool isFirstTime() => repo.getCustomerSearchModel == null;

  void init() async {
    if (isFirstTime()) {
      getSearchCustomer();
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          canLoading() &&
          !_isLoading) {
        getPaginationCustomer();
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
            log("getPaginationClients");
            // ignore: use_build_context_synchronously
            getPaginationCustomer();
          });
        }
      });
    }
  }

  Timer? _debounce;
  void onSearchChanged(
    String query,
  ) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      this.query = query;
      getSearchCustomer();
    });
  }

  void getSearchCustomer() async {
    emit(SearchClientLoading());
    final result = await repo.searchCustomers(
      query: query,
      refresh: true,
    );
    result.fold(
        (errMessage) => emit(SearchClientFailing(errMessage: errMessage)), (r) {
      clients = r;
      ifNotFillScreen();
      emit(SearchClientSuccess());
    });
  }

  bool _isLoading = false;

  void getPaginationCustomer() async {
    if (_isLoading) return;
    _isLoading = true;
    final result = await repo.searchCustomers(
      query: query,
      refresh: false,
    );
    result.fold(
        (errMessage) =>
            emit(SearchClientFailingPagination(errMessage: errMessage)), (r) {
      clients.addAll(r);
      ifNotFillScreen();
      _isLoading = false;
      emit(SearchClientSuccess());
    });
  }

  void reset() {
    // query = '';
    // clients = [];
    // repo.resetSearch();
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    _debounce?.cancel();
    return super.close();
  }
}
