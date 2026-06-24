/// Sport type enumeration for all supported sports.
enum SportType {
  cricket("Cricket", "cricket"),
  football("Football", "football"),
  badminton("Badminton", "badminton"),
  tableTennis("Table Tennis", "table_tennis"),
  volleyball("Volleyball", "volleyball"),
  chess("Chess", "chess"),
  carrom("Carrom", "carrom"),
  athletics("Athletics", "athletics"),
  tugOfWar("Tug of War", "tug_of_war"),
  ludo("Ludo", "ludo"),
  snooker("Snooker", "snooker"),
  custom("Custom", "custom");

  final String label;
  final String key;

  const SportType(this.label, this.key);

  static SportType fromKey(String key) {
    return SportType.values.firstWhere(
      (e) => e.key == key,
      orElse: () => SportType.custom,
    );
  }

  bool get isCricket => this == SportType.cricket;
  bool get isFootball => this == SportType.football;
  bool get isIndoor => [
        SportType.badminton,
        SportType.tableTennis,
        SportType.chess,
        SportType.carrom,
        SportType.ludo,
        SportType.snooker,
      ].contains(this);
}
