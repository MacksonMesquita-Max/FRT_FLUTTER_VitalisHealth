import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vitalis_app/components/common/app_colors.dart';

class VitalisQuote {
  const VitalisQuote({
    required this.text,
    required this.author,
  });

  final String text;
  final String author;
}

class VitalisMotivationCarousel extends StatefulWidget {
  const VitalisMotivationCarousel({
    super.key,
    required this.quotes,
    this.title = 'Inspiração Diária',
  });

  final List<VitalisQuote> quotes;
  final String title;

  @override
  State<VitalisMotivationCarousel> createState() => _VitalisMotivationCarouselState();
}

class _VitalisMotivationCarouselState extends State<VitalisMotivationCarousel> {
  late final PageController _controller;
  Timer? _autoTimer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoTimer?.cancel();
    if (widget.quotes.length <= 1) return;

    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_index + 1) % widget.quotes.length;
      _goToInternal(next, restartAutoPlay: false);
    });
  }

  void _restartAutoPlay() {
    _startAutoPlay();
  }

  void _goTo(int index) {
    _goToInternal(index, restartAutoPlay: true);
  }

  void _goToInternal(int index, {required bool restartAutoPlay}) {
    if (index < 0 || index >= widget.quotes.length) return;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
    if (restartAutoPlay) _restartAutoPlay();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quotes.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            _NavButton(
              icon: Icons.chevron_left,
              onPressed: _index > 0 ? () => _goTo(_index - 1) : null,
            ),
            const SizedBox(width: 8),
            _NavButton(
              icon: Icons.chevron_right,
              onPressed: _index < widget.quotes.length - 1 ? () => _goTo(_index + 1) : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 118,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: widget.quotes.length,
            onPageChanged: (value) {
              setState(() => _index = value);
              _restartAutoPlay();
            },
            itemBuilder: (context, index) {
              final quote = widget.quotes[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _QuoteCard(quote: quote),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final foreground = isEnabled ? AppColors.onSurface : AppColors.outlineVariant;

    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: AppColors.surfaceContainer,
            width: 1,
          ),
        ),
        child: Icon(icon, color: foreground),
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});

  final VitalisQuote quote;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryContainer,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 12,
              child: Icon(
                Icons.format_quote,
                size: 28,
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 10,
              child: Transform.rotate(
                angle: 3.1416,
                child: Icon(
                  Icons.format_quote,
                  size: 28,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '“${quote.text}”',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.92),
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quote.author,
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFBDF3E4),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
