import "package:sportsboard/domain/entities/sport.dart";

/// Abstract sport repository contract.
abstract class SportRepository {
  Stream<List<Sport>> getSports();
  Future<Sport?> getSportById(String id);
  Future<void> addSport(Sport sport);
  Future<void> updateSport(Sport sport);
  Future<void> deleteSport(String id);
}
