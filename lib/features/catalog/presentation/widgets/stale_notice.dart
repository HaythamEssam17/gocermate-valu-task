import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/connectivity/connectivity_cubit.dart';
import 'package:grocermate/core/utils/extensions/context_extensions.dart';
import 'package:grocermate/core/widgets/states_widgets/inline_error.dart';
import 'package:grocermate/features/products/presentation/bloc/products_bloc.dart';
import 'package:grocermate/features/products/presentation/bloc/products_events.dart';
import 'package:grocermate/features/products/presentation/bloc/products_states.dart';
import 'package:material_ui/material_ui.dart';

class StaleNotice extends StatelessWidget {
  const StaleNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final online = context.select((ConnectivityCubit c) => c.state.isOnline);
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (p, c) => p.fromCache != c.fromCache,
      builder: (context, state) {
        if (!online || !state.fromCache) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: InlineError(
            message: context.tr.couldNotRefresh,
            onRetry: () =>
                context.read<ProductsBloc>().add(const ProductsRefreshed()),
          ),
        );
      },
    );
  }
}
