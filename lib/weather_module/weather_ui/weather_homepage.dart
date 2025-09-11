import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:things_todo_in_this_weather/weather_module/weather_bloc/weather_bloc.dart';
import 'package:things_todo_in_this_weather/weather_module/weather_repo/repo.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final WeatherBloc weatherBloc = WeatherBloc();

  @override
  initState() {
    super.initState();

    _fetchInitialWeather();
  }

  Future<void> _fetchInitialWeather() async {
    try {
      final position = await WeatherRepo.determinePosition();
      if (mounted) {
        weatherBloc.add(WeatherInitialFetchEvent(position: position));
      }
    } catch (e) {
      if (mounted) {
        log('Error determining position: ${e.toString()}');

        weatherBloc.add(WeatherPositionFetchFailedEvent());
      }
    }
  }

  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/2.png');
      case >= 500 && < 505:
        return Image.asset('assets/3.png');
      case >= 520 && < 532:
        return Image.asset('assets/1.png');
      case >= 600 && < 700:
        return Image.asset('assets/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/5.png');
      case == 800:
        return Image.asset('assets/6.png');
      case > 800 && <= 804:
        return Image.asset('assets/7.png');
      default:
        return Image.asset('assets/4.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      bloc: weatherBloc,

      listenWhen: (previous, current) => current is WeatherActionState,

      listener: (BuildContext context, WeatherState state) {
        if (state is WeatherRefreshedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Weather refreshed'),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is WeatherRefreshErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Fail to refresh Weather'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      buildWhen: (previous, current) => current is! WeatherActionState,
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (WeatherInitialLoadingState): // Our initial loading state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case const (WeatherLoadedSuccessState):
            final successState = state as WeatherLoadedSuccessState;
            return Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                // systemOverlayStyle: const SystemUiOverlayStyle(
                //     statusBarBrightness: Brightness.dark
                // ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(
                  40,
                  1.2 * kToolbarHeight,
                  40,
                  20,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(3, -0.3),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-3, -0.3),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF673AB7),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, -1.2),
                        child: Container(
                          height: 300,
                          width: 600,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFAB40),
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📍 ${successState.weather.areaName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Good Morning',
                              // This could also come from the state if dynamic
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            getWeatherIcon(
                              successState.weather.weatherConditionCode!,
                            ),
                            Center(
                              child: Text(
                                '${successState.weather.temperature!.celsius!.round()}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                successState.weather.weatherMain!.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(
                                DateFormat(
                                  'EEEE dd •',
                                ).add_jm().format(successState.weather.date!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/sunrise.png', scale: 8),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Sunrise',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          DateFormat().add_jm().format(
                                            successState.weather.sunrise!,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/sunset.png',
                                      // 'assets/12.png',
                                      scale: 8,
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Sunset',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          DateFormat().add_jm().format(
                                            successState.weather.sunset!,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Divider(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/max.png', scale: 8),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Temp Max',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "${successState.weather.tempMax!.celsius!.round()} °C",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset('assets/min.png', scale: 8),
                                    const SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Temp Min',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "${successState.weather.tempMin!.celsius!.round()} °C",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          case const (WeatherLoadedErrorState):
            // final errorState = state as WeatherLoadedErrorState ;
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error Loading Weather Data, Check your connectivity or enable location.',
                ),
              ),
            );

          case const (PositionFetchFailedState):
            // final errorState = state as WeatherLoadedErrorState ;
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error fetching location data. Please enable phone location.',
                ),
              ),
            );

          default:
            return const Scaffold(body: Center(child: Text('Unknown state')));
        }
      },
    );
  }

  @override
  void dispose() {
    weatherBloc.close();
    super.dispose();
  }
}
