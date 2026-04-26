import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const RootShell(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Stack(
        children: [
          // Animated Background Orbs with smoother, drifting motion
          const Positioned(
            top: -100,
            right: -50,
            child: _FloatingOrb(
              size: 350,
              color: AppTheme.accentPurple,
              opacity: 0.15,
              duration: Duration(seconds: 8),
            ),
          ),
          const Positioned(
            bottom: -80,
            left: -30,
            child: _FloatingOrb(
              size: 300,
              color: AppTheme.accentCyan,
              opacity: 0.12,
              duration: Duration(seconds: 10),
              reverse: true,
            ),
          ),
          
          // Main Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo with sophisticated entrance
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentCyan.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      'assets/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .animate()
                .fade(duration: 800.ms, curve: Curves.easeOut)
                .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1), duration: 1000.ms, curve: Curves.easeOutBack)
                .shimmer(delay: 1200.ms, duration: 1800.ms, color: Colors.white.withValues(alpha: 0.2)),

                const SizedBox(height: 32),

                // Title with staggered animation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'EventFinder',
                      style: GoogleFonts.syne(
                        color: AppTheme.textPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.2,
                        height: 1,
                      ),
                    ),
                  ),
                )
                .animate()
                .fade(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'DISCOVER YOUR NEXT EXPERIENCE',
                  style: GoogleFonts.inter(
                    color: AppTheme.accentCyan.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                )
                .animate()
                .fade(delay: 800.ms, duration: 800.ms)
                .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic),
              ],
            ),
          ),
          
          // Refined loading indicator
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 160,
                height: 3,
                decoration: BoxDecoration(
                  color: AppTheme.glassWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentCyan),
                  ),
                ),
              )
              .animate()
              .fade(delay: 1200.ms, duration: 600.ms),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  final Duration duration;
  final bool reverse;

  const _FloatingOrb({
    required this.size,
    required this.color,
    required this.opacity,
    required this.duration,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            Colors.transparent,
          ],
        ),
      ),
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .moveY(
      begin: reverse ? -20 : 20,
      end: reverse ? 20 : -20,
      duration: duration,
      curve: Curves.easeInOutSine,
    )
    .moveX(
      begin: reverse ? 15 : -15,
      end: reverse ? -15 : 15,
      duration: duration * 1.2,
      curve: Curves.easeInOutSine,
    );
  }
}
