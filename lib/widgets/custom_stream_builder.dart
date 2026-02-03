import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'error_display.dart';
import 'loading_display.dart';
import 'empty_state_display.dart';

/// Custom StreamBuilder that automatically handles loading, error, and empty states
/// 
/// This wrapper eliminates repetitive state handling code and ensures
/// consistent UX across all Firestore streams in the app.
/// 
/// Usage Example:
/// ```dart
/// CustomStreamBuilder(
///   stream: _firestore.getClients(),
///   emptyMessage: 'No clients yet',
///   emptyIcon: Icons.people,
///   onEmptyAction: _showAddClientDialog,
///   emptyActionLabel: 'Add Client',
///   builder: (context, docs) {
///     return ListView.builder(
///       itemCount: docs.length,
///       itemBuilder: (context, index) => ClientCard(docs[index]),
///     );
///   },
/// )
/// ```
class CustomStreamBuilder extends StatefulWidget {
  final Stream<QuerySnapshot>? stream;
  final Widget Function(BuildContext, List<QueryDocumentSnapshot>) builder;
  final String emptyMessage;
  final IconData emptyIcon;
  final VoidCallback? onEmptyAction;
  final String? emptyActionLabel;
  final String loadingMessage;
  final String errorMessage;

  const CustomStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.emptyMessage = 'No data available',
    this.emptyIcon = Icons.inbox,
    this.onEmptyAction,
    this.emptyActionLabel,
    this.loadingMessage = 'Loading...',
    this.errorMessage = 'Unable to load data.\nPlease check your connection.',
  });

  @override
  State<CustomStreamBuilder> createState() => _CustomStreamBuilderState();
}

class _CustomStreamBuilderState extends State<CustomStreamBuilder> {
  // Key to force rebuild on retry
  int _rebuildKey = 0;

  void _retry() {
    setState(() {
      _rebuildKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      key: ValueKey(_rebuildKey),
      stream: widget.stream,
      builder: (context, snapshot) {
        // LOADING STATE
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingDisplay(message: widget.loadingMessage);
        }

        // ERROR STATE
        if (snapshot.hasError) {
          // Log error for debugging (in production, use proper error logging)
          debugPrint('Stream Error: ${snapshot.error}');
          
          return ErrorDisplay(
            message: widget.errorMessage,
            onRetry: _retry,
          );
        }

        // EMPTY STATE
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return EmptyStateDisplay(
            icon: widget.emptyIcon,
            title: widget.emptyMessage,
            subtitle: widget.emptyActionLabel != null
                ? 'Get started by adding your first item'
                : 'Check back later for updates',
            actionLabel: widget.emptyActionLabel,
            onAction: widget.onEmptyAction,
          );
        }

        // SUCCESS STATE - build the content
        return widget.builder(context, snapshot.data!.docs);
      },
    );
  }
}