/// User role enumeration for admin access levels.
enum UserRole {
  superAdmin("Super Admin", "super_admin"),
  sportsAdmin("Sports Admin", "sports_admin"),
  resultManager("Result Manager", "result_manager"),
  viewer("Viewer", "viewer");

  final String label;
  final String key;

  const UserRole(this.label, this.key);

  static UserRole fromKey(String key) {
    return UserRole.values.firstWhere(
      (e) => e.key == key,
      orElse: () => UserRole.viewer,
    );
  }

  bool get isSuperAdmin => this == UserRole.superAdmin;
  bool get isSportsAdmin => this == UserRole.sportsAdmin;
  bool get isResultManager => this == UserRole.resultManager;
  bool get canManageSports => isSuperAdmin;
  bool get canManageTournaments => isSuperAdmin || isSportsAdmin;
  bool get canAddResults => isSuperAdmin || isSportsAdmin || isResultManager;
  bool get canDeleteData => isSuperAdmin;
}
