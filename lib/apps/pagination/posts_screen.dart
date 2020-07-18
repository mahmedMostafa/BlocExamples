import 'package:bloc_examples/apps/pagination/bloc/posts_bloc.dart';
import 'package:bloc_examples/apps/pagination/bloc/posts_state.dart';
import 'package:bloc_examples/apps/pagination/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/posts_event.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200;
  PostsBloc _postsBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postsBloc = BlocProvider.of<PostsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostsFailure) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        } else {
          final success = state as PostsSuccess;
          if (success.posts.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= success.posts.length
                  ? BottomLoader()
                  : PostWidget(post: success.posts[index]);
            },
            itemCount: success.hasReachedMax
                ? success.posts.length
                : success.posts.length + 1,
            controller: _scrollController,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postsBloc.add(PostsFetched());
    }
  }
}

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${post.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(post.title),
      isThreeLine: true,
      subtitle: Text(post.body),
      dense: true,
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
