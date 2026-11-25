import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/config/app_flags.dart';
import 'package:grocermate/core/config/flags_repository.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/custom_scaffold.dart';
import 'package:grocermate/core/widgets/states_widgets/app_state_widget.dart';
import 'package:material_ui/material_ui.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final flags = context.read<FlagsRepository>();
    return ValueListenableBuilder<AppFlags>(
      valueListenable: flags.listenable,
      builder: (context, f, _) => f.maintenanceMode
          ? CustomScaffold(
              useSafeArea: true,
              body: AppStateWidget(
                icon: Icons.construction_rounded,
                title: context.tr.willBack,
                message: context.tr.appUnderMaintenance,
                actionLabel: context.tr.checkAgain,
                onAction: flags.refresh,
              ),
            )
          : child,
    );
  }
}
