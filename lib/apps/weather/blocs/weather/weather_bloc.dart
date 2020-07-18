import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_examples/apps/weather/data/weather_repository.dart';
import 'package:bloc_examples/apps/weather/models/weather.dart';
import 'package:equatable/equatable.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is WeatherRequested) {
      //don't forget to yield like this
      yield* _mapWeatherRequestedToState(event);
    } else if (event is WeatherRefreshRequested) {
      yield* _mapWeatherRefreshRequestedToState(event);
    }
  }


  Stream<WeatherState> _mapWeatherRequestedToState(
      WeatherRequested event,
      ) async* {
    yield WeatherLoadProgress();
    try {
      final Weather weather = await weatherRepository.getWeather(event.city);
      yield WeatherLoadSuccess(weather);
    } catch (error) {
      print("Error is $error");
      yield WeatherLoadFailure();
    }
  }

  Stream<WeatherState> _mapWeatherRefreshRequestedToState(
      WeatherRefreshRequested event) async* {
    try {
      final Weather weather = await weatherRepository.getWeather(event.city);
      yield WeatherLoadSuccess(weather);
    } catch (_) {
      yield state;
    }
  }

}
