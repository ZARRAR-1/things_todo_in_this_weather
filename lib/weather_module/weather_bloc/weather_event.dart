part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

///Triggered inside initState when the weather page is first loaded:
class WeatherInitialFetchEvent
    extends WeatherEvent {
  final Position position;

  WeatherInitialFetchEvent({required this.position});

}

//ToDo: EVent For Pull to refresh:
class WeatherReFetchEvent
    extends WeatherEvent {}