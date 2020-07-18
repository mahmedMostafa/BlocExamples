import 'dart:async';

import 'package:bloc_examples/apps/search/domain/github_repository.dart';
import 'package:bloc_examples/apps/search/search_result.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'github_search_event.dart';
part 'github_search_state.dart';
class GithubSearchBloc extends Bloc<GithubSearchEvent, GithubSearchState> {
  final GithubRepository githubRepository;

  //i guess they changed the initial state to the constructor
  GithubSearchBloc({@required this.githubRepository}) : super(SearchStateEmpty());

  @override
  Stream<Transition<GithubSearchEvent, GithubSearchState>> transformEvents(
      Stream<GithubSearchEvent> events,
      Stream<Transition<GithubSearchEvent, GithubSearchState>> Function(
          GithubSearchEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<GithubSearchEvent, GithubSearchState> transition) {
    print(transition);
    super.onTransition(transition);
  }

//  @override
//  GithubSearchState get initialState => SearchStateEmpty();

  @override
  Stream<GithubSearchState> mapEventToState(
      GithubSearchEvent event,
      ) async* {
    if (event is TextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final results = await githubRepository.search(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    }
  }
}