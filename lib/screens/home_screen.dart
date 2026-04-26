import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../theme.dart';
import '../widgets/event_card.dart';
import '../widgets/event_card_shimmer.dart';
import '../widgets/category_chip.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventService _service = EventService();
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  List<Event> _allEvents = [];
  List<Event> _filtered = [];
  bool _loading = true;
  String? _error;
  String _selectedCat = 'All';
  bool _showElevation = false;

  static const List<String> _categories = [
    'All', 'Music', 'Sports', 'Tech', 'Wellness', 'Art', 'Gaming',
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _scrollCtrl.addListener(() {
      final shouldShow = _scrollCtrl.offset > 30;
      if (shouldShow != _showElevation) setState(() => _showElevation = shouldShow);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() { _loading = true; _error = null; });
    try {
      final events = await _service.fetchEvents();
      setState(() {
        _allEvents = events;
        _applyFilter();
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.bgCard,
        content: const Text('Feature coming soon',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    );
  }

  void _applyFilter() {
    final query = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filtered = _allEvents.where((e) {
        final matchCat = _selectedCat == 'All' || e.category == _selectedCat;
        final matchSearch = query.isEmpty ||
            e.title.toLowerCase().contains(query) ||
            e.location.toLowerCase().contains(query) ||
            e.category.toLowerCase().contains(query);
        return matchCat && matchSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppTheme.bgDeep,
        body: Stack(
          children: [
            // Background orbs
            Positioned(top: -80, right: -60,
              child: _Orb(size: 280, color: AppTheme.accentPurple.withOpacity(0.18))),
            Positioned(top: 200, left: -80,
              child: _Orb(size: 220, color: AppTheme.accentCyan.withOpacity(0.12))),
            Positioned(bottom: 100, right: -40,
              child: _Orb(size: 200, color: AppTheme.accentPink.withOpacity(0.1))),

            SafeArea(
              child: RefreshIndicator(
                color: AppTheme.accentCyan,
                backgroundColor: AppTheme.bgCard,
                onRefresh: _loadEvents,
                child: CustomScrollView(
                  controller: _scrollCtrl,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // App Bar
                    SliverToBoxAdapter(child: _buildHeader()),

                    // Search Bar
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: _buildSearchBar(),
                      ),
                    ),

                    // Categories
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 44,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: _categories.length,
                          itemBuilder: (_, i) => CategoryChip(
                            label: _categories[i],
                            isSelected: _selectedCat == _categories[i],
                            onTap: () {
                              setState(() => _selectedCat = _categories[i]);
                              _applyFilter();
                            },
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Section title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _loading ? 'Loading...' : '${_filtered.length} Events',
                              style: GoogleFonts.poppins(
                                color: AppTheme.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (!_loading)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentCyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Near You',
                                  style: GoogleFonts.inter(
                                    color: AppTheme.accentCyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: _buildContent(),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_rounded,
                      color: AppTheme.accentCyan, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Bangalore, KA',
                    style: GoogleFonts.inter(
                      color: AppTheme.accentCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Discover Events',
                style: GoogleFonts.poppins(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          _buildNotificationButton(),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: _showComingSoon,
      child: Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.glassWhite,
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.notifications_outlined,
                color: AppTheme.textPrimary, size: 22),
            Positioned(
              top: 9, right: 9,
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                    color: AppTheme.accentPink, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.glassBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => _applyFilter(),
        style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search events, artists, venues…',
          hintStyle: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppTheme.accentCyan, size: 22),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppTheme.textSecondary, size: 20),
                  onPressed: () {
                    _searchCtrl.clear();
                    _applyFilter();
                  },
                )
              : GestureDetector(
                  onTap: _showComingSoon,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: AppTheme.accentCyan, size: 18),
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const SliverToBoxAdapter(child: EventCardShimmer());
    }

    if (_error != null) {
      return SliverToBoxAdapter(child: _buildError());
    }

    if (_filtered.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmpty());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => EventCard(
          event: _filtered[i],
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, anim, __) =>
                  EventDetailScreen(event: _filtered[i]),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                  child: child,
                ),
              ),
              transitionDuration: const Duration(milliseconds: 300),
            ),
          ),
        ),
        childCount: _filtered.length,
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppTheme.accentPink, size: 52),
            const SizedBox(height: 16),
            Text('Could not load events',
                style: GoogleFonts.syne(
                    color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Check your connection and try again.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadEvents,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentCyan,
                foregroundColor: AppTheme.bgDeep,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, color: AppTheme.textMuted, size: 52),
            const SizedBox(height: 16),
            Text('No events found',
                style: GoogleFonts.syne(
                    color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Try a different category or search term.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}
