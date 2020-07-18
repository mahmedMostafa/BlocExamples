import 'package:bloc_examples/apps/validation/form_screen.dart';
import 'package:bloc_examples/apps/pagination/bloc/posts_bloc.dart';
import 'package:bloc_examples/apps/pagination/bloc/posts_event.dart';
import 'package:bloc_examples/apps/pagination/posts_screen.dart';
import 'package:bloc_examples/apps/search/search_screen.dart';
import 'package:bloc_examples/apps/weather/blocs/settings/settings_bloc.dart';
import 'package:bloc_examples/apps/weather/blocs/weather/weather_bloc.dart';
import 'package:bloc_examples/apps/weather/data/weather_api_client.dart';
import 'package:bloc_examples/apps/weather/data/weather_repository.dart';
import 'package:bloc_examples/apps/weather/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'apps/simple_bloc_observer.dart';
import 'apps/weather/blocs/theme/theme_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    //Our App widget can then use BlocBuilder to react to changes in ThemeState
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Bloc Examples',
          theme: state.theme,
          home: Scaffold(
            body: FormScreen(),
          ),
        );
      },
    );
  }
}
