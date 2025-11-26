part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

///Triggered inside initState when the weather page is first loaded:
class WeatherInitialFetchEvent
    extends WeatherEvent {
  
  final Position position;

  WeatherInitialFetchEvent({required this.position});

}

class WeatherPositionFetchFailedEvent extends WeatherEvent{}/// EVent For Pull to refresh:
class WeatherReFetchEvent
    extends WeatherEvent {

  final Position position;

  WeatherReFetchEvent({required this.position});

}