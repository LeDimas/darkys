import 'package:darky_app/services/authenitcation.dart';
import 'package:darky_app/services/check_service.dart';
import 'package:darky_app/services/database_service.dart';
import 'package:darky_app/services/role_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fcm/firebase_notification_handler.dart';
import 'firebase_admin_apiManager.dart';

final authenticationServiceProvider =
    Provider((ref) => AuthenticationService(FirebaseAuth.instance));

final userAuthStateProvider = StreamProvider(
    (ref) => AuthenticationService(FirebaseAuth.instance).member);

final roleNameProvider = Provider((ref) => RoleService());

final databaseServiceProvider = Provider((ref) => DatabaseService());

final firebaseAdminApiProvider = Provider((ref) => ApiManager());

final checkingProvider = Provider((ref) => CheckService());

final fcmProvider = Provider((ref) => FirebaseNotifications());
