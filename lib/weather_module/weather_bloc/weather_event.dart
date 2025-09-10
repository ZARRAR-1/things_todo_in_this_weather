part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

///Triggered inside initState when the weather page is first loaded:
class WeatherInitialFetchEvent
    extends HomeEvent {
  final Position position;

  const FetchWeather(required this.position);
}

//ToDo: EVent For Pull to refresh:
class WeatherReFetchEvent
    extends HomeEvent {}