import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocermate/features/offline_sync/domain/entities/outbox_entry.dart';
import 'package:grocermate/features/offline_sync/domain/repositories/outbox_repository.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/cancel_queue_purchase_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/remove_outbox_entry_usecase.dart';
import 'package:grocermate/features/offline_sync/domain/usecases/watch_outbox_usecases.dart';
import 'package:grocermate/features/offline_sync/service/sync_manager.dart';

import 'outbox_states.dart';

class OutboxCubit extends Cubit<OutboxState> {
  OutboxCubit(
    WatchOutboxUseCase watch,
    this._manager,
    this._cancel,
    this._remove,
    this._repo,
  ) : super(const OutboxState()) {
    _sub = watch().listen(_onEntries);
  }

  final SyncManager _manager;
  final CancelQueuedPurchaseUseCase _cancel;
  final RemoveOutboxEntryUseCase _remove;
  final OutboxRepository _repo;
  StreamSubscription<List<OutboxEntry>>? _sub;
  bool _initialized = false;

  void _onEntries(List<OutboxEntry> next) {
    String? notice;
    if (_initialized) {
      final before = {for (final e in state.entries) e.id: e.status};
      for (final e in next) {
        final prev = before[e.id];
        if (prev == null && e.status == OutboxStatus.queued) {
          notice = 'Order queued - it will be sent when you are back online';
        } else if (prev != e.status && e.status == OutboxStatus.needsReview) {
          notice = 'A queued order needs your review';
        } else if (prev != e.status && e.status == OutboxStatus.completed) {
          notice = 'Queued order ${e.orderId ?? ''} was placed';
        }
      }
    }
    _initialized = true;
    emit(
      OutboxState(
        entries: next,
        notice: notice ?? state.notice,
        noticeId: notice == null ? state.noticeId : state.noticeId + 1,
      ),
    );
  }

  Future<void> syncNow() => _manager.syncNow();

  Future<void> cancel(OutboxEntry e) => _cancel(e);

  Future<void> dismiss(String id) => _remove(id);

  Future<void> retry(OutboxEntry e) async {
    await _repo.update(
      e.copyWith(status: OutboxStatus.queued, attempts: 0, note: 'Retrying...'),
    );
    await _manager.syncNow();
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
