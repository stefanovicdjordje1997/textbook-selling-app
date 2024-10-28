import 'package:flutter/material.dart';

// Animation type
enum RouteAnimationType {
  fade,
  slideFromRight,
  slideFromBottomAndFadeIn, // Nova animacija
}

// Function that creates route with animation based on animation type
PageRouteBuilder createRoute({
  required Widget page,
  required RouteAnimationType animationType,
}) {
  // Animation duration
  Duration duration;
  switch (animationType) {
    case RouteAnimationType.fade:
      duration = const Duration(milliseconds: 600);
      break;
    case RouteAnimationType.slideFromRight:
      duration = const Duration(milliseconds: 300);
      break;
    case RouteAnimationType.slideFromBottomAndFadeIn:
      duration = const Duration(milliseconds: 300);
      break;
    default:
      duration = const Duration(milliseconds: 300);
  }

  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (animationType) {
        case RouteAnimationType.fade:
          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        case RouteAnimationType.slideFromRight:
          var slideAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);
          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        case RouteAnimationType.slideFromBottomAndFadeIn:
          var slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation);

          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: child,
            ),
          );

        default:
          return child;
      }
    },
    transitionDuration: duration,
  );
}
