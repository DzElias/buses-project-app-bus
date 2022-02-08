
import 'package:bustracking/pages/bus-page/view/bus_page.dart';
import 'package:bustracking/pages/bus-stop-page/view/bus_stop_page.dart';
import 'package:bustracking/pages/daily-reminder-page/daily_reminders_page.dart';
import 'package:bustracking/pages/gps_access_page/view/gps_access_page.dart';

import 'package:bustracking/pages/login-page/login_page.dart';
import 'package:bustracking/pages/nearby-bus-stop-page/view/nearby_bus_stops_page.dart';
import 'package:bustracking/pages/register-page/register_page.dart';
import 'package:bustracking/pages/search-bus-page/search_bus_page.dart';
import 'package:bustracking/pages/set-daily-reminder-page/set-daily-reminder-page.dart';
import 'package:flutter/Material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'nearby-bus-stop-page': (_) => NearbyBusStopPage(),
  'search-bus': (_) => SearchBus(),
  'bus-stop': (_) => BusStopPage(),
  'bus-page': (_) => BusPage(),
  'daily-reminders-page': (_) => DailyRemindersPage(),
  'set-daily-reminder-page': (_) => SetDailyReminderPage(),
  'gps-access-page': (_) => GpsAccessPage()
};
