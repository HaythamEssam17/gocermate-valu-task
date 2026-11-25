import 'package:cached_network_image/cached_network_image.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

/// Cached network image with graceful placeholder/error (works offline once cached).
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(this.url, {super.key, this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final bg = context.appColors;
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      memCacheWidth: 600,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => ColoredBox(color: bg.surface5),
      errorWidget: (_, _, _) => ColoredBox(
        color: bg.surface5,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, color: bg.active),
        ),
      ),
    );
  }
}
