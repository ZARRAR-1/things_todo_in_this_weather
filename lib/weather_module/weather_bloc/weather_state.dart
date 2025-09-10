part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

abstract class WeatherActionState extends WeatherState {}

///Non-Action States:
class WeatherInitialLoadingState
    extends WeatherState {} //State emitted when the Weatherpage is being loaded

class WeatherLoadedSuccessState extends WeatherState {
  //State emitted when the Weatherpage is successfully loaded

  final Weather weather;

  WeatherLoadedSuccessState({required this.weather});
}

class WeatherLoadedErrorState extends WeatherState {}

class PositionFetchFailedState extends WeatherState{}

///Action States:
class WeatherRefreshedState extends WeatherActionState{}

class WeatherRefreshErrorState extends WeatherActionState{}


