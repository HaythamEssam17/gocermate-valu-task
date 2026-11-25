import 'package:equatable/equatable.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';

class OutboxState extends Equatable {
  const OutboxState({this.entries = const [], this.notice, this.noticeId = 0});

  final List<OutboxEntry> entries;
  final String? notice;
  final int noticeId;

  int get attentionCount => entries
      .where((e) => e.isPending || e.status == OutboxStatus.needsReview)
      .length;
  bool get isSyncing => entries.any((e) => e.status == OutboxStatus.syncing);

  @override
  List<Object?> get props => [entries, notice, noticeId];
}
