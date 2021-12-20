
import 'package:bustracking/pages/add_destination_page.dart';
import 'package:bustracking/pages/bus_page.dart';
import 'package:bustracking/pages/bus_stop_page.dart';
import 'package:bustracking/pages/daily_reminders_page.dart';
import 'package:bustracking/pages/login_page.dart';
import 'package:bustracking/pages/nearby_bus_stops_page.dart';
import 'package:bustracking/pages/register_page.dart';
import 'package:bustracking/pages/search_bus_page.dart';
import 'package:bustracking/pages/set-daily-reminder-page.dart';
import 'package:flutter/Material.dart';




final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': ( _ ) => LoginPage(),
  'register': ( _ ) => RegisterPage(),
  'nearby-bus-stop-page': ( _ ) => NearbyBusStopPage(),
  'search-bus': ( _ ) => SearchBus(),
  'add-destination': ( _ ) => AddDestinationPage(),
  'bus-stop': ( _ ) => BusStopPage(),
  'bus-page': ( _ ) => BusPage(),
  'daily-reminders-page': ( _ ) => DailyRemindersPage(),
  'set-daily-reminder-page': ( _ ) => SetDailyReminderPage(),




};