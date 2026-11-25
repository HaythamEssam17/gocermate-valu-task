import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:material_ui/material_ui.dart';

abstract class LoadingFactory {
  Widget buildLoading({required BuildContext context});

  factory LoadingFactory(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return AndroidLoading();
      case TargetPlatform.iOS:
        return IOSLoading();

      default:
        return AndroidLoading();
    }
  }
}

class AndroidLoading implements LoadingFactory {
  @override
  Widget buildLoading({required BuildContext context}) {
    return CircularProgressIndicator.adaptive(
      backgroundColor: context.appColors.surface5,
      valueColor: AlwaysStoppedAnimation<Color>(context.appColors.primary),
    );
  }
}

class IOSLoading implements LoadingFactory {
  @override
  Widget buildLoading({required BuildContext context}) {
    return CupertinoActivityIndicator.partiallyRevealed(
      radius: 10,
      color: context.appColors.primary,
    );
  }
}

/// Use This in UI
class PlatformLoading {
  static Widget buildLoading({required BuildContext context}) {
    return LoadingFactory(Theme.of(context).platform)
        .buildLoading(context: context);
  }
}
