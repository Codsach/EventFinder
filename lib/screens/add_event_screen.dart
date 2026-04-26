import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();

  String? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isFree = false;
  bool _submitting = false;

  static const List<String> _categories = [
    'Music', 'Sports', 'Tech', 'Wellness', 'Art', 'Gaming', 'Food', 'Comedy',
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.accentCyan,
            onPrimary: AppTheme.bgDeep,
            surface: AppTheme.bgCard,
            onSurface: AppTheme.textPrimary,
          ),
          dialogBackgroundColor: AppTheme.bgCard,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.accentCyan,
            onPrimary: AppTheme.bgDeep,
            surface: AppTheme.bgCard,
            onSurface: AppTheme.textPrimary,
          ),
          dialogBackgroundColor: AppTheme.bgCard,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatDate(DateTime d) =>
      '${_weekday(d.weekday)}, ${_month(d.month)} ${d.day} ${d.year}';

  String _weekday(int w) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][w - 1];

  String _month(int m) => [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$min $period';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showError('Please select a category');
      return;
    }
    if (_selectedDate == null) {
      _showError('Please select a date');
      return;
    }
    if (_selectedTime == null) {
      _showError('Please select a time');
      return;
    }

    setState(() => _submitting = true);
    HapticFeedback.mediumImpact();

    // Simulate submission delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _submitting = false);

    if (!mounted) return;
    _showSuccess();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.accentPink.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(msg,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (ctx) => _SuccessSheet(
        onDone: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppTheme.bgDeep,
        body: Stack(
          children: [
            Positioned(
                top: -80,
                left: -60,
                child: _Orb(
                    size: 280,
                    color: AppTheme.accentCyan.withOpacity(0.12))),
            Positioned(
                bottom: 120,
                right: -40,
                child: _Orb(
                    size: 220,
                    color: AppTheme.accentPurple.withOpacity(0.14))),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.fromLTRB(20, 8, 20, 120),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('Event Details'),
                            _buildTextField(
                              controller: _titleCtrl,
                              hint: 'Event title',
                              icon: Icons.title_rounded,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Title is required'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            _buildCategoryDropdown(),
                            const SizedBox(height: 24),
                            _sectionLabel('Date & Time'),
                            Row(children: [
                              Expanded(
                                child: _PickerTile(
                                  icon: Icons.calendar_today_rounded,
                                  color: AppTheme.accentPurple,
                                  label: 'Date',
                                  value: _selectedDate != null
                                      ? _formatDate(_selectedDate!)
                                      : null,
                                  placeholder: 'Select date',
                                  onTap: _pickDate,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _PickerTile(
                                  icon: Icons.schedule_rounded,
                                  color: AppTheme.accentCyan,
                                  label: 'Time',
                                  value: _selectedTime != null
                                      ? _formatTime(_selectedTime!)
                                      : null,
                                  placeholder: 'Select time',
                                  onTap: _pickTime,
                                ),
                              ),
                            ]),
                            const SizedBox(height: 24),
                            _sectionLabel('Location'),
                            _buildTextField(
                              controller: _locationCtrl,
                              hint: 'Venue / address',
                              icon: Icons.location_on_rounded,
                              color: AppTheme.accentPink,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Location is required'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            _sectionLabel('Pricing'),
                            GlassCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Row(children: [
                                const Icon(Icons.confirmation_number_rounded,
                                    color: AppTheme.accentCyan, size: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _priceCtrl,
                                    enabled: !_isFree,
                                    keyboardType:
                                        TextInputType.number,
                                    style: TextStyle(
                                      color: _isFree
                                          ? AppTheme.textMuted
                                          : AppTheme.textPrimary,
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: _isFree
                                          ? 'Free event'
                                          : 'Price in ₹',
                                      hintStyle: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 14),
                                      border: InputBorder.none,
                                      prefixText: _isFree ? '' : '₹ ',
                                      prefixStyle: const TextStyle(
                                          color: AppTheme.accentCyan,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Row(children: [
                                  Text('Free',
                                      style: TextStyle(
                                          color: _isFree
                                              ? const Color(0xFF00FF9D)
                                              : AppTheme.textSecondary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                  Switch(
                                    value: _isFree,
                                    activeColor: const Color(0xFF00FF9D),
                                    onChanged: (v) => setState(() {
                                      _isFree = v;
                                      if (v) _priceCtrl.clear();
                                    }),
                                  ),
                                ]),
                              ]),
                            ),
                            const SizedBox(height: 24),
                            _sectionLabel('Image URL (optional)'),
                            _buildTextField(
                              controller: _imageUrlCtrl,
                              hint: 'https://example.com/banner.jpg',
                              icon: Icons.image_outlined,
                              color: AppTheme.accentPurple,
                            ),
                            const SizedBox(height: 24),
                            _sectionLabel('Description'),
                            GlassCard(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 14, 16, 14),
                              child: TextFormField(
                                controller: _descCtrl,
                                maxLines: 5,
                                style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14.5,
                                    height: 1.6),
                                decoration: const InputDecoration(
                                  hintText:
                                      'Describe your event — what to expect, who it\'s for…',
                                  hintStyle: TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 14,
                                      height: 1.6),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom submit button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildSubmitBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          _GlassCircle(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppTheme.textPrimary, size: 16),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Event',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1)),
              Text('Fill in the details below',
                  style: GoogleFonts.inter(
                      color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label,
          style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Color color = AppTheme.accentCyan,
    String? Function(String?)? validator,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: validator,
            style: const TextStyle(
                color: AppTheme.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppTheme.textMuted, fontSize: 14),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildCategoryDropdown() {
    final catColor = _selectedCategory != null
        ? AppTheme.categoryColor(_selectedCategory!)
        : AppTheme.accentCyan;

    return GestureDetector(
      onTap: _showCategorySheet,
      child: GlassCard(
        borderColor: _selectedCategory != null
            ? catColor.withOpacity(0.4)
            : AppTheme.glassBorder,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(children: [
          Icon(Icons.category_rounded, color: catColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedCategory ?? 'Select category',
              style: TextStyle(
                color: _selectedCategory != null
                    ? AppTheme.textPrimary
                    : AppTheme.textMuted,
                fontSize: 15,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textSecondary, size: 20),
        ]),
      ),
    );
  }

  void _showCategorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard.withOpacity(0.97),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              border: const Border(
                  top: BorderSide(color: AppTheme.glassBorder)),
            ),
            padding: EdgeInsets.fromLTRB(24, 16, 24,
                24 + MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppTheme.textMuted,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                Text('Select Category',
                    style: GoogleFonts.syne(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _categories.map((cat) {
                    final color = AppTheme.categoryColor(cat);
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = cat);
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isSelected
                              ? color.withOpacity(0.2)
                              : AppTheme.glassWhite,
                          border: Border.all(
                              color: isSelected
                                  ? color
                                  : AppTheme.glassBorder,
                              width: 1.2),
                        ),
                        child: Text(cat,
                            style: TextStyle(
                                color:
                                    isSelected ? color : AppTheme.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 14)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: AppTheme.bgDeep.withOpacity(0.85),
            border: const Border(
                top: BorderSide(color: AppTheme.glassBorder)),
          ),
          child: GestureDetector(
            onTap: _submitting ? null : _submit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _submitting
                      ? [AppTheme.textMuted, AppTheme.textMuted]
                      : [AppTheme.accentCyan, AppTheme.accentPurple],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _submitting
                    ? []
                    : [
                        BoxShadow(
                            color: AppTheme.accentCyan.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8))
                      ],
              ),
              child: Center(
                child: _submitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3))
                    : Text('PUBLISH EVENT',
                        style: GoogleFonts.poppins(
                            color: AppTheme.bgDeep,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value != null ? color.withOpacity(0.08) : AppTheme.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: value != null ? color.withOpacity(0.4) : AppTheme.glassBorder,
              width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 3),
            Text(
              value ?? placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: value != null
                      ? AppTheme.textPrimary
                      : AppTheme.textMuted,
                  fontSize: 12.5,
                  fontWeight: value != null ? FontWeight.w600 : FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessSheet({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard.withOpacity(0.97),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: const Border(top: BorderSide(color: AppTheme.glassBorder)),
          ),
          padding: EdgeInsets.fromLTRB(
              24, 36, 24, 40 + MediaQuery.of(context).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    AppTheme.accentCyan.withOpacity(0.3),
                    AppTheme.accentPurple.withOpacity(0.3)
                  ]),
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppTheme.accentCyan, size: 40),
              ),
              const SizedBox(height: 20),
              Text('Event Published!',
                  style: GoogleFonts.poppins(
                      color: AppTheme.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Text(
                'Your event has been submitted successfully\nand is now visible to everyone.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: AppTheme.textSecondary, fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentCyan,
                    foregroundColor: AppTheme.bgDeep,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text('BACK TO HOME',
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _GlassCircle({required this.child, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppTheme.glassWhite),
              child: Center(child: child),
            ),
          ),
        ),
      );
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient:
                RadialGradient(colors: [color, Colors.transparent])),
      );
}
