import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/core/utils/enums/check_out_status.dart';
import 'package:grocermate/core/utils/enums/review_issue_kind.dart';
import 'package:grocermate/core/utils/enums/review_resolution.dart';
import 'package:grocermate/core/utils/extensions/num_extensions.dart';
import 'package:grocermate/core/widgets/app_network_image.dart';
import 'package:grocermate/features/checkout/domain/entities/review_entites/review_issue.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_events.dart';
import 'package:grocermate/features/checkout/presentation/bloc/checkout_states.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showReviewSheet(BuildContext context, CheckoutBloc bloc) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    showDragHandle: true,
    builder: (_) =>
        BlocProvider.value(value: bloc, child: const _ReviewSheet()),
  );
}

class _ReviewSheet extends StatelessWidget {
  const _ReviewSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, s) {
        final scheme = Theme.of(context).colorScheme;
        final submitting = s.status == CheckoutStatus.submitting;
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: scheme.primary),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Your order needs a quick review',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    'Some items changed since you added them. Choose what to do for each one.',
                  ),
                ),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: s.issues.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, i) =>
                        _IssueCard(issue: s.issues[i], enabled: !submitting),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: submitting
                              ? null
                              : () {
                                  context.read<CheckoutBloc>().add(
                                    const CheckoutReviewDismissed(),
                                  );
                                },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: submitting || !s.allResolved
                              ? null
                              : () => context.read<CheckoutBloc>().add(
                                  const CheckoutResubmitted(),
                                ),
                          child: submitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text('Confirm & place order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue, required this.enabled});
  final ReviewIssue issue;
  final bool enabled;

  String get _description => switch (issue.kind) {
    IssueKind.priceChanged =>
      'Price changed from ${issue.oldPrice!.formatMoney()} to ${issue.newPrice!.formatMoney()}',
    IssueKind.outOfStock => 'Out of stock',
    IssueKind.limitedStock =>
      'Only ${issue.available} available (you asked for ${issue.requestedQty})',
  };

  String _label(Resolution r) => switch (r) {
    Resolution.acceptPrice => 'Accept ${(issue.newPrice ?? 0).formatMoney()}',
    Resolution.adjustQty => 'Change to ${issue.available}',
    Resolution.remove => 'Remove',
    Resolution.none => '',
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bloc = context.read<CheckoutBloc>();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: issue.isResolved
              ? scheme.primary.withAlpha(120)
              : scheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: AppNetworkImage(issue.image),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      _description,
                      style: TextStyle(
                        color: issue.kind == IssueKind.priceChanged
                            ? const Color(0xFFEF6C00)
                            : scheme.error,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              for (final r in issue.options)
                ChoiceChip(
                  label: Text(_label(r)),
                  selected: issue.resolution == r,
                  onSelected: enabled
                      ? (_) => bloc.add(CheckoutIssueResolved(issue.key, r))
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
