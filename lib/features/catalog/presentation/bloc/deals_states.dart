import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/catalog/domain/entities/deal.dart';

class DealsState extends Equatable {
  const DealsState({this.status = ViewStatus.initial, this.deals = const []});
  final ViewStatus status;
  final List<DealEntity> deals;

  @override
  List<Object?> get props => [status, deals];
}
