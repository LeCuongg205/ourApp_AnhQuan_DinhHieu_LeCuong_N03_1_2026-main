// lib/front/content_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/widget/bottom_navigation.dart';
import 'package:app/widget/text_field_form.dart';

class Expense {
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  final List<Expense> _allExpenses = [
    Expense(title: 'Mua đồ ăn', amount: 150000, date: DateTime(2026, 5, 4), category: 'Food'),
    Expense(title: 'Tiền xăng', amount: 200000, date: DateTime(2026, 5, 3), category: 'Transport'),
    Expense(title: 'Cà phê', amount: 30000, date: DateTime(2026, 5, 5), category: 'Food'),
    Expense(title: 'Điện thoại', amount: 1200000, date: DateTime(2026, 5, 1), category: 'Gadgets'),
    Expense(title: 'Vé xem phim', amount: 90000, date: DateTime(2026, 4, 28), category: 'Entertainment'),
    Expense(title: 'Sách', amount: 120000, date: DateTime(2026, 4, 20), category: 'Education'),
  ];

  List<Expense> _filteredExpenses = [];

  @override
  void initState() {
    super.initState();
    _filteredExpenses = List.from(_allExpenses);
    _searchController.addListener(_onSearchChangedImmediate);
  }

  // Debounce wrapper: chờ 250ms sau lần gõ cuối cùng rồi lọc
  void _onSearchChangedImmediate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _applyFilter);
  }

  /// Loại bỏ dấu tiếng Việt, chuyển về lowercase để so sánh không phân biệt dấu
  String _normalizeVietnamese(String s) {
    final lower = s.toLowerCase();
    return lower
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd');
  }

  /// Giữ lại chỉ chữ số (dùng để so sánh số tiền)
  String _digitsOnly(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  void _applyFilter() {
    final rawQuery = _searchController.text.trim();
    final query = rawQuery.toLowerCase();

    // Prepare normalized query and numeric query
    final normalizedQuery = _normalizeVietnamese(rawQuery);
    final queryDigits = _digitsOnly(rawQuery);

    setState(() {
      if (query.isEmpty) {
        _filteredExpenses = List.from(_allExpenses);
      } else {
        _filteredExpenses = _allExpenses.where((e) {
          final titleNorm = _normalizeVietnamese(e.title);
          final categoryNorm = _normalizeVietnamese(e.category);
          final amountStr = e.amount.toStringAsFixed(0);
          final amountDigits = _digitsOnly(amountStr);

          final matchesTitle = titleNorm.contains(normalizedQuery);
          final matchesCategory = categoryNorm.contains(normalizedQuery);
          final matchesAmountDigits = queryDigits.isNotEmpty && amountDigits.contains(queryDigits);
          final matchesAmountText = amountStr.contains(query); // fallback if user types exact digits or formatted

          // If user typed digits only, prefer numeric match; otherwise match normalized text
          final matchesQuery = queryDigits.isNotEmpty
              ? (matchesAmountDigits || titleNorm.contains(normalizedQuery) || categoryNorm.contains(normalizedQuery))
              : (matchesTitle || matchesCategory || matchesAmountText);

          return matchesQuery;
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChangedImmediate);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          _NavBar(),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextFieldForm(
              controller: _searchController,
              hintText: 'Tìm kiếm theo tên, loại, hoặc số tiền',
              prefixIcon: Icons.search,
              autofocus: false,
              onChanged: (_) {
                // onChanged is optional here because we listen to controller;
                // keeping it for compatibility with TextFieldForm API.
              },
            ),
          ),

          // Body: danh sách kết quả
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: _filteredExpenses.isEmpty
                  ? const Center(child: Text('Không tìm thấy khoản chi phù hợp'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredExpenses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final e = _filteredExpenses[index];
                        return _ExpenseTile(expense: e);
                      },
                    ),
            ),
          ),

          // Footer
          _Footer(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacementNamed(context, ['/home', '/content', '/contact'][index]);
        },
      ),
    );
  }
}

// ── Nav Bar ───────────────────────────────────────────────────────────────────

class _NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Logo
              Image.asset(
                'assets/group_avatar.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const FlutterLogo(size: 60),
              ),

              // Nav links
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _NavLink(label: 'Trang chủ', active: true),
                      _NavLink(label: 'Tính năng', active: false),
                      _NavLink(label: 'Giải pháp', active: false),
                      _NavLink(label: 'Nhóm', active: false),
                      _NavLink(label: 'Liên hệ', active: false),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Buttons
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A1A1A),
                  side: const BorderSide(color: Color(0xFFDDDDDD)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Sign in', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  const _NavLink({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: active ? const Color(0xFFEEEEEE) : Colors.transparent,
          foregroundColor: const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Expense Tile ──────────────────────────────────────────────────────────────

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  const _ExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade100,
            child: Icon(Icons.receipt_long, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('${expense.category} · ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('${expense.amount.toStringAsFixed(0)} đ', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
// ── Footer ────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: logo + socials
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/group_avatar.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const FlutterLogo(size: 40),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _SocialBtn(Icons.close),
                      _SocialBtn(Icons.camera_alt_outlined),
                      _SocialBtn(Icons.play_circle_outline),
                      _SocialBtn(Icons.work_outline),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              // Footer columns
              _FooterColumn(title: 'Use cases', items: ['UI design', 'UX design', 'Wireframing']),
              const SizedBox(width: 28),
              _FooterColumn(title: 'Explore', items: ['Design', 'Prototyping', 'Development features']),
              const SizedBox(width: 28),
              _FooterColumn(title: 'Resources', items: ['Blog', 'Best practices', 'Colors']),
            ],
          ),

          const SizedBox(height: 28),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 16),

          Row(
            children: [
              Text('© 2026 Finance Tracker', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              const Spacer(),
              Text('23010580 · 23010827 · 23010224', style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;
  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 14),
        ...items.map(
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(i, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ),
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  const _SocialBtn(this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Icon(icon, size: 22, color: const Color(0xFF1A1A1A)),
    );
  }
}
