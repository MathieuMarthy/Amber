import 'package:amber_calendar/src/services/favicon_service.dart';
import 'package:amber_calendar/src/utils/subscription_color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubscriptionAvatar extends StatelessWidget {
  final String name;
  final String? websiteUrl;
  final double size;

  const SubscriptionAvatar({
    super.key,
    required this.name,
    this.websiteUrl,
    this.size = 46,
  });


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final faviconUrl = FaviconService.getFaviconUrl(websiteUrl);

    final fallback = Container(
      color: subscriptionColor(name),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.42,
          ),
        ),
      ),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: colors.outlineVariant, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: faviconUrl != null
            ? CachedNetworkImage(
                imageUrl: faviconUrl,
                placeholder: (context, url) => fallback,
                errorWidget: (context, url, error) => fallback,
                imageBuilder: (context, imageProvider) => Container(
                  color: colors.surfaceContainerLow,
                  padding: EdgeInsets.all(size * 0.18),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : fallback,
      ),
    );
  }
}
