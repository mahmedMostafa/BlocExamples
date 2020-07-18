import 'package:bloc_examples/apps/pagination/post.dart';
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsFailure extends PostsState {}

class PostsSuccess extends PostsState {
  final List<Post> posts;
  final bool hasReachedMax;

  const PostsSuccess({this.posts, this.hasReachedMax});

  PostsSuccess copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostsSuccess(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'PostSuccess { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
