library list_tile_package;

import 'package:flutter/material.dart';

class AnimatedUniqueListTile extends StatefulWidget {
  const AnimatedUniqueListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.badge,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;
  final Widget? badge;
  final bool initiallyExpanded;
  final Duration duration;

  @override
  State<AnimatedUniqueListTile> createState() => _AnimatedUniqueListTileState();
}

class _AnimatedUniqueListTileState extends State<AnimatedUniqueListTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideIn;
  late final Animation<double> _fadeIn;
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _expanded
                ? theme.colorScheme.primary.withOpacity(0.06)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                _toggleExpanded();
                widget.onTap?.call();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    if (widget.leading != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Hero(
                          tag: widget.key ?? UniqueKey(),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: widget.leading,
                          ),
                        ),
                      ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: theme.textTheme.titleMedium!,
                            child: widget.title,
                          ),

                          AnimatedSize(
                            duration: widget.duration,
                            curve: Curves.easeInOut,
                            child: widget.subtitle != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: DefaultTextStyle(
                                      style: theme.textTheme.bodySmall!,
                                      child: widget.subtitle!,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: theme.hintColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Tap again to collapse — this is the expanded area with any extra widget you want.',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: _expanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: widget.duration,
                          ),
                        ],
                      ),
                    ),

                    if (widget.badge != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: widget.badge!,
                      ),

                    _TrailingIcon(
                      expanded: _expanded,
                      duration: widget.duration,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({required this.expanded, required this.duration});

  final bool expanded;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0.0,
      duration: duration,
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: duration,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(expanded ? 0.12 : 0.0),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.chevron_right_rounded,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated ListTile Demo',
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Animated Unique ListTile')),
        body: const DemoList(),
      ),
    );
  }
}

class DemoList extends StatelessWidget {
  const DemoList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10, (i) => 'Item #${i + 1}');

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final title = items[index];

        return AnimatedUniqueListTile(
          key: ValueKey(title),
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(title),
          subtitle: Text('Subtitle for $title'),
          badge: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'NEW',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped $title')));
          },
        );
      },
    );
  }
}
