import 'package:flutter/material.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/profile/points/widgets/restaurant_points_widget.dart';
import 'package:unifood/view/profile/points/widgets/total_points_widget.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:unifood/controller/restaurant_controller.dart'; 
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/controller/points_controller.dart';
import 'package:unifood/model/points_entity.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class PointsView extends StatefulWidget {
  const PointsView({Key? key}) : super(key: key);

  @override
  _PointsState createState() => _PointsState();
}

class _PointsState extends State<PointsView> {
  late bool _isConnected;
  late StreamSubscription _connectivitySubscription;
  List<Points>? _points;
  List<Restaurant>? _restaurants;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _stopwatch.start();
    _connectivitySubscription = Connectivity()
            .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime({
      'screen': 'Points View',
      'time': _stopwatch.elapsed.inSeconds
    });
    _connectivitySubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;
    final paddingHorizontal = screenWidth * 0.04;

    final Future<List<Points>> pointsFuture = PointsController().fetchPoints();
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniFood Points'),
      ),
      body: _isConnected
      ?
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TotalPointsWidget(totalPoints: 120),
            Container(
              margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: const Divider(color: Colors.grey, thickness: 1),
            ),
            SizedBox(height: screenWidth * 0.05),
            Padding(
              padding: EdgeInsets.only(left: paddingHorizontal),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Restaurant Points',
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            _points != null
            ?RestaurantPointsWidget(restaurantPointsList: _points!)
            :FutureBuilder<List<Points>>(
              future: pointsFuture,  // Use the pre-declared future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return RestaurantPointsWidget(restaurantPointsList: snapshot.data!);
                } else {
                  return const Text('No points available.');
                }
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: const Divider(color: Colors.grey, thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.all(paddingHorizontal),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Redeem Points',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            FutureBuilder<List<Restaurant>>(
              future: RestaurantController().getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data!.map((restaurant) {
                      return CustomRestaurant(
                        id: restaurant.id,
                        imageUrl: restaurant.imageUrl,
                        logoUrl: restaurant.logoUrl,
                        name: restaurant.name,
                        isOpen: restaurant.isOpen,
                        distance: restaurant.distance,
                        rating: restaurant.rating,
                        avgPrice: restaurant.avgPrice,
                        fromPointsView: true
                      );
                    }).toList(),
                  ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ],
        ),
      ):const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 48),
              SizedBox(height: 10),
              Text('No internet connection'),
            ],
          ),
        ),
    );
  }
}