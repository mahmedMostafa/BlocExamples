part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoadProgress extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;

  WeatherLoadSuccess(this.weather) : assert(weather != null);

  @override
  List<Object> get props => [weather];

}

class WeatherLoadFailure extends WeatherState {}
