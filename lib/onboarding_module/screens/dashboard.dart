import 'package:flutter/material.dart';
import 'package:things_todo_in_this_weather/todo_list_module/ui/home_ui.dart';
import 'package:things_todo_in_this_weather/weather_module/weather_ui/weather_homepage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Things ToDo in this Weather',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [
          Icon(Icons.tag_faces_outlined, color: Colors.white),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            dividerHeight: 0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
            tabs: const [
              Text('ToDo', style: TextStyle()),
              Text('Weather', style: TextStyle()),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [ToDoHomeScreen(), WeatherHomeScreen()],
            ),
          ),
        ],
      ),
    );
  }
}
