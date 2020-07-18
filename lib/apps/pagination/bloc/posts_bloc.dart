import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_examples/apps/pagination/bloc/posts_event.dart';
import 'package:bloc_examples/apps/pagination/bloc/posts_state.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../post.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final http.Client httpClient;

  PostsBloc(this.httpClient) : super(PostsInitial());

  @override
  Stream<Transition<PostsEvent, PostsState>> transformEvents(
    Stream<PostsEvent> events,
    transitionFn,
  ) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 500)), transitionFn);
  }

  @override
  Stream<PostsState> mapEventToState(
    PostsEvent event,
  ) async* {
    final currentState = state;
    if (event is PostsFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostsInitial) {
          final posts = await _fetchPosts(0, 20);
          yield PostsSuccess(posts: posts, hasReachedMax: false);
          return;
        }
        if (currentState is PostsSuccess) {
          final posts = await _fetchPosts(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostsSuccess(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                );
        }
      } catch (error) {
        yield PostsFailure();
      }
    }
  }

  bool _hasReachedMax(PostsState state) =>
      state is PostsSuccess && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}
