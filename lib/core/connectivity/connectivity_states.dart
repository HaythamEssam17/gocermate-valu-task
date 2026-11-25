import 'package:equatable/equatable.dart';
import 'package:grocermate/core/utils/enums/network_banner_enum.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({required this.isOnline, required this.banner});

  final bool isOnline;
  final NetworkBanner banner;

  @override
  List<Object?> get props => [isOnline, banner];
}
