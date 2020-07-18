part of 'settings_bloc.dart';

enum TemperatureUnits { fahrenheit, celsius }

class SettingsState extends Equatable {
  final TemperatureUnits temperatureUnits;

  SettingsState(this.temperatureUnits) : assert(temperatureUnits != null);

  @override
  List<Object> get props => [temperatureUnits];
}
