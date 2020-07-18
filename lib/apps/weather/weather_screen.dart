import 'package:bloc_examples/apps/weather/blocs/weather/weather_bloc.dart';
import 'package:bloc_examples/apps/weather/widgets/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'data/weather_api_client.dart';
import 'data/weather_repository.dart';

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>(
          create: (BuildContext context) => WeatherBloc(
              WeatherRepository(WeatherApiClient(httpClient: http.Client()))),
        )
      ],
      child: Weather(),
    );
  }
}
