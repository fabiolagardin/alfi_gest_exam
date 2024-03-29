import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabsLabels;
  final GlobalKey<FormState> formKey;
  final void Function(int) onTapTab;

  CustomTabBar({
    required this.tabController,
    required this.tabsLabels,
    required this.formKey,
    required this.onTapTab,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TabBar(
        controller: tabController,
        tabs: tabsLabels.map((label) => Tab(text: label)).toList(),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        indicatorColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          onTapTab(index);
        },
      ),
    );
  }
}
