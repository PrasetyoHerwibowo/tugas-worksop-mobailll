import 'package:go_router/go_router.dart';

import '../data/dummy_data.dart';
import '../models/models.dart';
import '../pages/edit_profile_page.dart';
import '../pages/not_found_page.dart';
import '../pages/profile_page.dart';
import '../pages/project_detail_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';

final GoRouter appGoRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
      routes: [
        GoRoute(
          path: 'projects/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final project = findProjectById(id);
            if (project == null) return const NotFoundPage();
            return ProjectDetailPage(project: project);
          },
        ),
        GoRoute(
          path: 'edit',
          builder: (context, state) {
            final profile = state.extra;
            if (profile is! Profile) return const NotFoundPage();
            return EditProfilePage(profile: profile);
          },
        ),
      ],
    ),
  ],
);
