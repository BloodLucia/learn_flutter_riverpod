import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:learn_flutter_riverpod/common/dio_client.dart';
import 'package:learn_flutter_riverpod/examples/user_list/user_model.dart';

final currentPageProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final userListProvider = FutureProvider.autoDispose
    .family<UserPaginateResponse, int>((ref, skip) async {
  final httpClient = ref.watch(dioProvider);
  final jsonResponse = await httpClient.get(
    "/users",
    queryParameters: {"skip": skip < 0 ? 0 : skip, "limit": 10},
  );
  final List<User> users = (jsonResponse.data["users"] as List<dynamic>)
      .map((dynamic x) => User.fromMap(x))
      .toList();

  return UserPaginateResponse.fromMap(jsonResponse.data, users);
});

final userListStateNotifierProvider =
    StateNotifierProvider.autoDispose<UserListStateNotifier, UserListState>(
        (ref) {
  return UserListStateNotifier(ref.watch(dioProvider));
});

class UserListStateNotifier extends StateNotifier<UserListState> {
  UserListStateNotifier(
    this.httpClient,
  ) : super(UserListState.empty()) {
    _initData();
  }

  final Dio httpClient;

  void _initData() async {
    state = state.copyWith(isLoading: true);
    final result = await _getUsers(skip: 0);
    if (result.users.isEmpty) {
      state = UserListState.empty();
      return;
    }
    state = state.copyWith(
      users: result.users,
      isLoading: false,
      hasMore: result.total / (result.limit * 0) > 0,
    );
  }

  Future<UserPaginateResponse> _getUsers({required int skip}) async {
    final json = await httpClient.get("/users", queryParameters: {
      "skip": skip,
      "limit": 10,
    });
    final users = (json.data["users"] as List<dynamic>)
        .map((e) => User.fromMap(e))
        .toList();

    return UserPaginateResponse.fromMap(json.data, users);
  }

  void loadMoreUsers({required int skip}) async {
    if (state.isLoading) return;
    final result = await _getUsers(skip: skip < 0 ? 0 : skip);

    // has more
    if (state.hasMore && result.total ~/ (result.limit * result.skip) > 0) {
      log("more result ${result.users.first.toString()}");
      state = state.copyWith(
        users: [...state.users, ...result.users],
        hasMore: true,
        isLoading: false,
        isLoadMoreLoading: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        hasMore: false,
      );
    }
  }
}

@immutable
class UserListState {
  final List<User> users;
  final bool hasMore;
  final bool isLoading;

  const UserListState({
    required this.users,
    required this.hasMore,
    required this.isLoading,
  });

  factory UserListState.empty() {
    return const UserListState(
      users: [],
      hasMore: false,
      isLoading: false,
    );
  }

  List<Object?> get props => [users, hasMore, isLoading];

  UserListState copyWith({
    List<User>? users,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadMoreLoading,
  }) {
    return UserListState(
      users: users ?? this.users,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
