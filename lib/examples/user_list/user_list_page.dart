import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

import 'user_list_provider.dart';
import 'user_model.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  final _controller = ScrollController();
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      ref.read(currentPageProvider.notifier).state++;
      ref
          .read(userListStateNotifierProvider.notifier)
          .loadMoreUsers(skip: ref.watch(currentPageProvider));
      log("request more data...");
    } else {
      log("scrolling");
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListStateNotifierProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor("#ff0f7b"),
            HexColor("#f89b29"),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: const Text("Users"),
        ),
        body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                itemCount: state.users.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index + 1 < state.users.length) {
                    return _buildUserItem(state.users[index]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
      ),
    );
  }

  ListTile _buildUserItem(User user) {
    return ListTile(
      leading: ClipOval(
        child: Image.network(
          user.image,
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        ),
      ),
      title: Text(user.fullName),
      subtitle: Text("@${user.username}"),
    );
  }
}
