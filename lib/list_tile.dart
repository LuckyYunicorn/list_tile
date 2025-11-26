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
    final width = MediaQuery.of(context).size.width;

    final bool isTablet = width > 600;
    final bool isDesktop = width > 1000;

    // Responsive multipliers
    double scale = (width / 400).clamp(0.8, 1.4);

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideIn,
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 6 * scale,
          ),
          decoration: BoxDecoration(
            color: _expanded
                ? theme.colorScheme.primary.withOpacity(0.06)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(14 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8 * scale,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14 * scale),
              onTap: () {
                _toggleExpanded();
                widget.onTap?.call();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12 * scale,
                  vertical: 10 * scale,
                ),
                child: Row(
                  children: [
                    // Responsive leading widget
                    if (widget.leading != null)
                      Padding(
                        padding: EdgeInsets.only(right: 12 * scale),
                        child: SizedBox(
                          width: isTablet ? 60 : 48 * scale,
                          height: isTablet ? 60 : 48 * scale,
                          child: widget.leading!,
                        ),
                      ),

                    // Text section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontSize: theme.textTheme.titleMedium!.fontSize! *
                                  scale,
                            ),
                            child: widget.title,
                          ),

                          // Subtitle with animation
                          AnimatedSize(
                            duration: widget.duration,
                            curve: Curves.easeInOut,
                            child: widget.subtitle != null
                                ? Padding(
                                    padding: EdgeInsets.only(top: 6 * scale),
                                    child: DefaultTextStyle(
                                      style:
                                          theme.textTheme.bodySmall!.copyWith(
                                        fontSize: theme.textTheme.bodySmall!
                                                .fontSize! *
                                            scale,
                                      ),
                                      child: widget.subtitle!,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // Expand section
                          AnimatedCrossFade(
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: EdgeInsets.only(top: 10 * scale),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16 * scale,
                                    color: theme.hintColor,
                                  ),
                                  SizedBox(width: 6 * scale),
                                  Expanded(
                                    child: Text(
                                      'Tap again to collapse — this is the expanded area with any extra widget you want.',
                                      style:
                                          theme.textTheme.bodySmall!.copyWith(
                                        fontSize: theme.textTheme.bodySmall!
                                                .fontSize! *
                                            scale,
                                      ),
                                    ),
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
                        padding: EdgeInsets.only(right: 8 * scale),
                        child: widget.badge!,
                      ),

                    _TrailingIcon(
                      expanded: _expanded,
                      duration: widget.duration,
                      scale: scale,
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
  const _TrailingIcon({
    required this.expanded,
    required this.duration,
    required this.scale,
  });

  final bool expanded;
  final Duration duration;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0.0,
      duration: duration,
      curve: Curves.easeInOut,
      child: AnimatedContainer(
        duration: duration,
        padding: EdgeInsets.all(6 * scale),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(expanded ? 0.12 : 0),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.chevron_right_rounded,
          size: 22 * scale,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
