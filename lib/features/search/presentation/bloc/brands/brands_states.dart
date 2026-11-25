import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';

class BrandsState extends Equatable {
  const BrandsState({this.status = ViewStatus.initial, this.brands = const []});
  final ViewStatus status;
  final List<String> brands;

  @override
  List<Object?> get props => [status, brands];
}
