import 'package:bloc_examples/apps/search/github_client.dart';
import 'package:bloc_examples/apps/search/githuc_cache.dart';
import 'package:bloc_examples/apps/search/search_result.dart';

class GithubRepository {
  final GithubCache githubCache;
  final GithubClient githubClient;

  GithubRepository(this.githubCache, this.githubClient);

  Future<SearchResult> search(String term) async {
    if (githubCache.contains(term)) {
      return githubCache.get(term);
    } else {
      final response = await githubClient.search(term);
      githubCache.set(term, response);
      return response;
    }
  }
}
