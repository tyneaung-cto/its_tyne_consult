import 'package:get/get.dart';

import '../modules/auth-gate/bindings/auth_gate_binding.dart';
import '../modules/auth-gate/views/auth_gate_view.dart';
import '../modules/banned-home/bindings/banned_home_binding.dart';
import '../modules/banned-home/views/banned_home_view.dart';
import '../modules/booking-list/bindings/booking_list_binding.dart';
import '../modules/booking-list/views/booking_list_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/create-fcm/bindings/create_fcm_binding.dart';
import '../modules/create-fcm/views/create_fcm_view.dart';
import '../modules/forget-password/bindings/forget_password_binding.dart';
import '../modules/forget-password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my-sessions/bindings/my_sessions_binding.dart';
import '../modules/my-sessions/views/my_sessions_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/privacy-policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy-policy/views/privacy_policy_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/superadmin-home/bindings/superadmin_home_binding.dart';
import '../modules/superadmin-home/views/superadmin_home_view.dart';
import '../modules/superadmin-list-notifications/bindings/superadmin_list_notifications_binding.dart';
import '../modules/superadmin-list-notifications/views/superadmin_list_notifications_view.dart';
import '../modules/superadmin-system-settings/bindings/superadmin_system_settings_binding.dart';
import '../modules/superadmin-system-settings/views/superadmin_system_settings_view.dart';
import '../modules/superadmin-user-management/bindings/superadmin_user_management_binding.dart';
import '../modules/superadmin-user-management/views/superadmin_user_management_view.dart';
import '../modules/terms-and-conditions/bindings/terms_and_conditions_binding.dart';
import '../modules/terms-and-conditions/views/terms_and_conditions_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH_GATE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_GATE,
      page: () => const AuthGateView(),
      binding: AuthGateBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.MY_SESSIONS,
      page: () => const MySessionsView(),
      binding: MySessionsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_LIST,
      page: () => const BookingListView(),
      binding: BookingListBinding(),
    ),
    GetPage(
      name: _Paths.BANNED_HOME,
      page: () => const BannedHomeView(),
      binding: BannedHomeBinding(),
    ),
    GetPage(
      name: _Paths.SUPERADMIN_HOME,
      page: () => const SuperadminHomeView(),
      binding: SuperadminHomeBinding(),
    ),
    GetPage(
      name: _Paths.SUPERADMIN_USER_MANAGEMENT,
      page: () => const SuperadminUserManagementView(),
      binding: SuperadminUserManagementBinding(),
    ),
    GetPage(
      name: _Paths.SUPERADMIN_SYSTEM_SETTINGS,
      page: () => const SuperadminSystemSettingsView(),
      binding: SuperadminSystemSettingsBinding(),
    ),
    GetPage(
      name: _Paths.SUPERADMIN_LIST_NOTIFICATIONS,
      page: () => const SuperadminListNotificationsView(),
      binding: SuperadminListNotificationsBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_FCM,
      page: () => const CreateFcmView(),
      binding: CreateFcmBinding(),
    ),
  ];
}
