class ApiConstants {
  static const String baseUrl = 'http://192.168.1.45:4000/api';

  static const bool googleMapsEnabled = false;

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Users
  static const String me = '/users/me';
  static String userStats(String id) => '/users/$id/stats';

  // Pitches
  static const String pitches = '/pitches';
  static const String myPitches = '/pitches/mine';
  static String pitchDetail(String id) => '/pitches/$id';
  static String updatePitch(String id) => '/pitches/$id';
  static String pitchSchedule(String pitchId) => '/pitches/$pitchId/schedule';

  // Bookings
  static const String bookings = '/bookings';
  static const String myBookings = '/bookings/my';
  static const String verifyBooking = '/bookings/verify';
  static String cancelBooking(String id) => '/bookings/$id/cancel';
  static String completeBooking(String id) => '/bookings/$id/complete';
  static const String ownerStats = '/bookings/owner/stats';
  static const String ownerToday = '/bookings/owner/today';
  static String pitchBookings(String pitchId) => '/bookings/pitch/$pitchId';

  // Teams
  static const String teams = '/teams';
  static String teamDetail(String id) => '/teams/$id';
  static String joinTeam(String id) => '/teams/$id/join';
  static String leaveTeam(String id) => '/teams/$id/leave';

  // Leagues
  static const String leagues = '/leagues';
  static String leagueDetail(String id) => '/leagues/$id';
  static String registerTeamToLeague(String id) => '/leagues/$id/register';
  static String recordMatch(String id) => '/leagues/$id/match';

  // Messages
  static String teamMessages(String teamId) => '/messages/$teamId';
  static const String sendMessage = '/messages';
}
