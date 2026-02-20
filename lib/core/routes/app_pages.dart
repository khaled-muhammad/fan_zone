import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/pitches/presentation/bindings/pitch_binding.dart';
import '../../features/pitches/presentation/pages/home_page.dart';
import '../../features/pitches/presentation/pages/pitch_detail_page.dart';
import '../../features/booking/presentation/bindings/booking_binding.dart';
import '../../features/booking/presentation/pages/schedule_page.dart';
import '../../features/booking/presentation/pages/booking_confirmation_page.dart';
import '../../features/booking/presentation/pages/my_bookings_page.dart';
import '../../features/qr/presentation/bindings/qr_binding.dart';
import '../../features/qr/presentation/pages/qr_code_page.dart';
import '../../features/qr/presentation/pages/qr_scanner_page.dart';
import '../../features/profile/presentation/bindings/profile_binding.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/teams/presentation/bindings/team_binding.dart';
import '../../features/teams/presentation/pages/teams_page.dart';
import '../../features/teams/presentation/pages/team_detail_page.dart';
import '../../features/chat/presentation/bindings/chat_binding.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/leagues/presentation/bindings/league_binding.dart';
import '../../features/leagues/presentation/pages/leagues_page.dart';
import '../../features/leagues/presentation/pages/league_detail_page.dart';
import '../../features/owner/presentation/bindings/owner_binding.dart';
import '../../features/owner/presentation/pages/owner_home_page.dart';
import '../../features/owner/presentation/pages/my_pitches_page.dart';
import '../../features/owner/presentation/pages/create_pitch_page.dart';
import '../../features/owner/presentation/pages/pitch_bookings_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: PitchBinding(),
    ),
    GetPage(
      name: AppRoutes.pitchDetail,
      page: () => const PitchDetailPage(),
      binding: PitchBinding(),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => const SchedulePage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingConfirmation,
      page: () => const BookingConfirmationPage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsPage(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: AppRoutes.qrCode,
      page: () => const QrCodePage(),
      binding: QrBinding(),
    ),
    GetPage(
      name: AppRoutes.qrScanner,
      page: () => const QrScannerPage(),
      binding: QrBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.teams,
      page: () => const TeamsPage(),
      binding: TeamBinding(),
    ),
    GetPage(
      name: AppRoutes.teamDetail,
      page: () => const TeamDetailPage(),
      binding: TeamBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.leagues,
      page: () => const LeaguesPage(),
      binding: LeagueBinding(),
    ),
    GetPage(
      name: AppRoutes.leagueDetail,
      page: () => const LeagueDetailPage(),
      binding: LeagueBinding(),
    ),
    // Owner
    GetPage(
      name: AppRoutes.ownerHome,
      page: () => const OwnerHomePage(),
      binding: OwnerBinding(),
    ),
    GetPage(
      name: AppRoutes.myPitches,
      page: () => const MyPitchesPage(),
      binding: OwnerBinding(),
    ),
    GetPage(
      name: AppRoutes.createPitch,
      page: () => const CreatePitchPage(),
      binding: OwnerBinding(),
    ),
    GetPage(
      name: AppRoutes.pitchBookings,
      page: () => const PitchBookingsPage(),
      binding: OwnerBinding(),
    ),
  ];
}
