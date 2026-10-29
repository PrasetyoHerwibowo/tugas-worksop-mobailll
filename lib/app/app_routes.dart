class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const profile = '/profile';
  static const projectDetail = '/project-detail';
  static const editProfile = '/edit-profile';

  /// Path helper untuk navigasi go_router dengan parameter
  static String projectDetailPath(String id) => '/profile/projects/$id';
}
