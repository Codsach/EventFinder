import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/saved_events_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-load fonts to prevent "font-style conversion" / pop-in during splash
  GoogleFonts.syne();
  GoogleFonts.inter();
  GoogleFonts.poppins();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const EventFinderApp());
}

class EventFinderApp extends StatelessWidget {
  const EventFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventFinder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    SavedEventsScreen(),
    AddEventScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    const items = [
      (icon: Icons.explore_outlined, active: Icons.explore_rounded, label: 'Explore'),
      (icon: Icons.bookmark_border_rounded, active: Icons.bookmark_rounded, label: 'Saved'),
      (icon: Icons.add_circle_outline_rounded, active: Icons.add_circle_rounded, label: 'Create'),
      (icon: Icons.person_outline_rounded, active: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgDeep,
        border: Border(top: BorderSide(color: AppTheme.glassBorder, width: 1)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        top: 12,
      ),
      child: Row(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isActive = _currentIndex == i;
          final isCreate = i == 2;

          return Expanded(
            child: _NavBarItem(
              isActive: isActive,
              isCreate: isCreate,
              item: item,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _currentIndex = i);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final bool isActive;
  final bool isCreate;
  final dynamic item;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.isActive,
    required this.isCreate,
    required this.item,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isCreate)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.accentCyan,
                      AppTheme.accentPurple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentCyan.withValues(alpha: widget.isActive || _isHovered ? 0.5 : 0.3),
                      blurRadius: widget.isActive || _isHovered ? 20 : 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded, color: AppTheme.bgDeep, size: 28),
              ).animate(target: _isHovered ? 1 : 0).scale(end: const Offset(1.1, 1.1))
            else
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isActive 
                    ? AppTheme.accentCyan.withValues(alpha: 0.1) 
                    : (_isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.isActive ? widget.item.active : widget.item.icon,
                  color: widget.isActive 
                    ? AppTheme.accentCyan 
                    : (_isHovered ? AppTheme.textPrimary : AppTheme.textMuted),
                  size: 24,
                ),
              ).animate(target: widget.isActive ? 1 : 0).scale(end: const Offset(1.15, 1.15)),
            const SizedBox(height: 6),
            Text(
              widget.item.label,
              style: GoogleFonts.inter(
                color: widget.isActive 
                  ? AppTheme.textPrimary 
                  : (_isHovered ? AppTheme.textSecondary : AppTheme.textMuted),
                fontSize: 10,
                fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
