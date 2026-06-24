/// Application constants.
abstract class AppConstants {
  // ── Firestore Collections ──
  static const String sportsCollection = "sports";
  static const String tournamentsCollection = "tournaments";
  static const String teamsCollection = "teams";
  static const String playersCollection = "players";
  static const String fixturesCollection = "fixtures";
  static const String resultsCollection = "results";
  static const String standingsCollection = "standings";
  static const String playerStatsCollection = "playerStats";
  static const String adminsCollection = "admins";

  // ── Pagination ──
  static const int pageSize = 20;

  // ── Cricket Points ──
  static const int cricketWinPoints = 2;
  static const int cricketLossPoints = 0;
  static const int cricketNoResultPoints = 1;

  // ── Football Points ──
  static const int footballWinPoints = 3;
  static const int footballDrawPoints = 1;
  static const int footballLossPoints = 0;

  // ── Cricket Player Ranking ──
  static const int runsPerPoint = 1;
  static const int fourBonus = 1;
  static const int sixBonus = 2;
  static const int fiftyBonus = 10;
  static const int centuryBonus = 25;
  static const int wicketPoints = 25;
  static const int maidenPoints = 10;
  static const int threeWicketBonus = 10;
  static const int fiveWicketBonus = 25;

  // ── Football Player Ranking ──
  static const int goalPoints = 10;
  static const int assistPoints = 5;
  static const int cleanSheetPoints = 5;
  static const int yellowCardPenalty = -2;
  static const int redCardPenalty = -5;
  static const int manOfMatchPoints = 10;
}
