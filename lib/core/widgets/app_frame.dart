import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/connectivity/connectivity_states.dart';
import 'package:grocermate/core/helpers/shared_functions.dart';
import 'package:grocermate/core/utils/enums/network_banner_enum.dart';

import '../connectivity/connectivity_cubit.dart';
import 'app_network_banner.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      buildWhen: (p, c) => p.banner != c.banner,
      builder: (context, state) {
        final showBanner = state.banner != NetworkBanner.none;
        return Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              alignment: Alignment.topCenter,
              child: showBanner
                  ? AppNetworkBanner(
                      offline: state.banner == NetworkBanner.offline,
                    )
                  : getSpaceWidth(context, double.infinity),
            ),

            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: showBanner,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
