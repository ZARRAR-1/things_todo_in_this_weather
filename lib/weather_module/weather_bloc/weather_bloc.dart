import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:weather/weather.dart';

import '../weather_repo/repo.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherFactory wf = WeatherFactory(
    WeatherRepo.API_KEY,
    language: Language.ENGLISH,
  );

  WeatherBloc() : super(WeatherInitialLoadingState()) {                                    
    on<WeatherInitialFetchEvent>(weatherInitialFetchEvent);
    on<WeatherReFetchEvent>(weatherReFetchEvent);
    on<WeatherPositionFetchFailedEvent>(weatherPositionFetchFailedEvent);
  }

  Future<void> weatherInitialFetchEvent(
    WeatherInitialFetchEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherInitialLoadingState());
    try {
      Weather w = await wf.currentWeatherByLocation(
        event.position.latitude,
        event.position.longitude,
      );
      debugPrint(w.toString());
      emit(WeatherLoadedSuccessState(weather: w));
    } catch (e) {
      log(e.toString());
      emit(WeatherLoadedErrorState());
    }
  }

  Future<void> weatherReFetchEvent(
    WeatherReFetchEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      Weather w = await wf.currentWeatherByLocation(
        event.position.latitude,
        event.position.longitude,
      );
      debugPrint(w.toString());
      emit(WeatherLoadedSuccessState(weather: w));
    } catch (e) {
      log(e.toString());
      emit(WeatherLoadedErrorState());
    }
  }

  FutureOr<void> weatherPositionFetchFailedEvent(
    WeatherPositionFetchFailedEvent event,
    Emitter<WeatherState> emit,
  ) {
    emit(PositionFetchFailedState());
  }
}
