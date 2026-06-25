import "package:sportsboard/app/config/app_constants.dart";
import "package:sportsboard/core/enums/sport_type.dart";
import "package:sportsboard/domain/entities/fixture.dart";
import "package:sportsboard/domain/entities/result.dart";
import "package:sportsboard/domain/entities/standing.dart";
import "package:sportsboard/domain/entities/team.dart";
import "package:sportsboard/domain/repositories/fixture_repository.dart";
import "package:sportsboard/domain/repositories/result_repository.dart";
import "package:sportsboard/domain/repositories/standing_repository.dart";

class _TeamCricketStats {
  int runsScored = 0;
  int ballsFaced = 0;
  int runsConceded = 0;
  int ballsBowled = 0;
}

class CalculateStandingsUseCase {
  final ResultRepository resultRepository;
  final StandingRepository standingRepository;
  final FixtureRepository fixtureRepository;

  CalculateStandingsUseCase({
    required this.resultRepository,
    required this.standingRepository,
    required this.fixtureRepository,
  });

  /// Calculates standings for a tournament based on sport type and saves them.
  Future<void> execute(
    String tournamentId,
    String sportTypeStr,
    List<Team> teams,
  ) async {
    final sportType = SportType.fromKey(sportTypeStr);

    // 1. Get all results for this tournament
    final resultsStream =
        resultRepository.getResults(tournamentId: tournamentId);
    final resultsList = await resultsStream.first;

    // Get fixtures to map team IDs
    final fixturesStream =
        fixtureRepository.getFixtures(tournamentId: tournamentId);
    final fixturesList = await fixturesStream.first;
    final Map<String, Fixture> fixturesMap = {
      for (var f in fixturesList) f.id: f
    };

    // 2. Initialize standing map
    final Map<String, Standing> standingsMap = {};
    for (var team in teams) {
      standingsMap[team.id] = Standing(
        id: "",
        tournamentId: tournamentId,
        teamId: team.id,
        teamName: team.name,
      );
    }

    // Aggregated stats for NRR (Cricket)
    final Map<String, _TeamCricketStats> statsMap = {
      for (var team in teams) team.id: _TeamCricketStats()
    };

    // 3. Process each result
    for (var result in resultsList) {
      if (sportType.isCricket) {
        _processCricketResult(result, standingsMap);
        _accumulateCricketStats(result, statsMap, fixturesMap);
      } else if (sportType.isFootball) {
        _processFootballResult(result, standingsMap, fixturesMap);
      } else if (sportType.isIndoor) {
        _processIndoorResult(result, standingsMap, fixturesMap);
      }
    }

    // If cricket, calculate and set NRR
    if (sportType.isCricket) {
      for (var teamId in standingsMap.keys) {
        final stats = statsMap[teamId];
        if (stats == null) continue;
        final standing = standingsMap[teamId]!;

        double scoredRate = 0.0;
        double concededRate = 0.0;

        if (stats.ballsFaced > 0) {
          scoredRate = stats.runsScored / (stats.ballsFaced / 6.0);
        }
        if (stats.ballsBowled > 0) {
          concededRate = stats.runsConceded / (stats.ballsBowled / 6.0);
        }

        final nrr = scoredRate - concededRate;
        final formattedNrr = double.parse(nrr.toStringAsFixed(3));
        standingsMap[teamId] = standing.copyWith(netRunRate: formattedNrr);
      }
    }

    // 4. Save to repository (overwrite existing)
    final existingStandingsStream =
        standingRepository.getStandings(tournamentId);
    final existingStandings = await existingStandingsStream.first;
    final Map<String, String> existingIds = {
      for (var s in existingStandings) s.teamId: s.id
    };

    final List<Standing> finalStandings = standingsMap.values.map((s) {
      return s.copyWith(id: existingIds[s.teamId] ?? "");
    }).toList();

    await standingRepository.saveStandings(finalStandings);
  }

  void _processCricketResult(
    Result result,
    Map<String, Standing> standings,
  ) {
    final winnerId = result.winnerTeamId;
    final loserId = result.loserTeamId;

    if (standings.containsKey(winnerId)) {
      final w = standings[winnerId]!;
      standings[winnerId] = w.copyWith(
        played: w.played + 1,
        won: w.won + 1,
        points: w.points + AppConstants.cricketWinPoints,
      );
    }

    if (loserId.isNotEmpty && standings.containsKey(loserId)) {
      final l = standings[loserId]!;
      standings[loserId] = l.copyWith(
        played: l.played + 1,
        lost: l.lost + 1,
        points: l.points + AppConstants.cricketLossPoints,
      );
    }
  }

  void _accumulateCricketStats(
    Result result,
    Map<String, _TeamCricketStats> statsMap,
    Map<String, Fixture> fixtures,
  ) {
    final fixture = fixtures[result.fixtureId];
    if (fixture == null) return;

    final teamAId = fixture.teamAId;
    final teamBId = fixture.teamBId;

    final cData = result.cricketData;
    if (cData == null) return;

    final aRuns = cData["teamARuns"] as int? ?? 0;
    final aOvers = (cData["teamAOvers"] as num? ?? 0.0).toDouble();

    final bRuns = cData["teamBRuns"] as int? ?? 0;
    final bOvers = (cData["teamBOvers"] as num? ?? 0.0).toDouble();

    final aBalls = _oversToBalls(aOvers);
    final bBalls = _oversToBalls(bOvers);

    // Team A scored aRuns in aBalls, conceded bRuns in bBalls
    if (statsMap.containsKey(teamAId)) {
      final stats = statsMap[teamAId]!;
      stats.runsScored += aRuns;
      stats.ballsFaced += aBalls;
      stats.runsConceded += bRuns;
      stats.ballsBowled += bBalls;
    }

    // Team B scored bRuns in bBalls, conceded aRuns in aBalls
    if (statsMap.containsKey(teamBId)) {
      final stats = statsMap[teamBId]!;
      stats.runsScored += bRuns;
      stats.ballsFaced += bBalls;
      stats.runsConceded += aRuns;
      stats.ballsBowled += aBalls;
    }
  }

  /// Converts overs (e.g. 19.3) to total balls (e.g. 117).
  int _oversToBalls(double overs) {
    final completedOvers = overs.truncate();
    final extraBalls = ((overs - completedOvers) * 10).round();
    return (completedOvers * 6) + extraBalls;
  }

  void _processFootballResult(
    Result result,
    Map<String, Standing> standings,
    Map<String, Fixture> fixtures,
  ) {
    final fixture = fixtures[result.fixtureId];
    if (fixture == null) return;

    final teamAId = fixture.teamAId;
    final teamBId = fixture.teamBId;

    final fData = result.footballData;
    if (fData == null) return;

    final aGoals = fData["teamAGoals"] as int? ?? 0;
    final bGoals = fData["teamBGoals"] as int? ?? 0;

    // Team A updates
    if (standings.containsKey(teamAId)) {
      final s = standings[teamAId]!;
      final won = aGoals > bGoals ? 1 : 0;
      final lost = aGoals < bGoals ? 1 : 0;
      final draw = aGoals == bGoals ? 1 : 0;
      final points = won * AppConstants.footballWinPoints +
          draw * AppConstants.footballDrawPoints;

      standings[teamAId] = s.copyWith(
        played: s.played + 1,
        won: s.won + won,
        lost: s.lost + lost,
        draw: s.draw + draw,
        points: s.points + points,
        goalsFor: s.goalsFor + aGoals,
        goalsAgainst: s.goalsAgainst + bGoals,
        goalDifference: s.goalDifference + (aGoals - bGoals),
      );
    }

    // Team B updates
    if (standings.containsKey(teamBId)) {
      final s = standings[teamBId]!;
      final won = bGoals > aGoals ? 1 : 0;
      final lost = bGoals < aGoals ? 1 : 0;
      final draw = bGoals == aGoals ? 1 : 0;
      final points = won * AppConstants.footballWinPoints +
          draw * AppConstants.footballDrawPoints;

      standings[teamBId] = s.copyWith(
        played: s.played + 1,
        won: s.won + won,
        lost: s.lost + lost,
        draw: s.draw + draw,
        points: s.points + points,
        goalsFor: s.goalsFor + bGoals,
        goalsAgainst: s.goalsAgainst + aGoals,
        goalDifference: s.goalDifference + (bGoals - aGoals),
      );
    }
  }

  void _processIndoorResult(
    Result result,
    Map<String, Standing> standings,
    Map<String, Fixture> fixtures,
  ) {
    final fixture = fixtures[result.fixtureId];
    if (fixture == null) return;

    final teamAId = fixture.teamAId;
    final teamBId = fixture.teamBId;

    final iData = result.indoorData;
    if (iData == null) return;

    final aSets = iData["teamASets"] as int? ?? 0;
    final bSets = iData["teamBSets"] as int? ?? 0;

    // Team A updates
    if (standings.containsKey(teamAId)) {
      final s = standings[teamAId]!;
      final won = aSets > bSets ? 1 : 0;
      final lost = aSets < bSets ? 1 : 0;
      final draw = aSets == bSets ? 1 : 0;
      final points = won * AppConstants.cricketWinPoints;

      standings[teamAId] = s.copyWith(
        played: s.played + 1,
        won: s.won + won,
        lost: s.lost + lost,
        draw: s.draw + draw,
        points: s.points + points,
      );
    }

    // Team B updates
    if (standings.containsKey(teamBId)) {
      final s = standings[teamBId]!;
      final won = bSets > aSets ? 1 : 0;
      final lost = bSets < aSets ? 1 : 0;
      final draw = bSets == aSets ? 1 : 0;
      final points = won * AppConstants.cricketWinPoints;

      standings[teamBId] = s.copyWith(
        played: s.played + 1,
        won: s.won + won,
        lost: s.lost + lost,
        draw: s.draw + draw,
        points: s.points + points,
      );
    }
  }
}
