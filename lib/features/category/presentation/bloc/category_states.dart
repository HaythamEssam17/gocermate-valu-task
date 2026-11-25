import 'package:equatable/equatable.dart';
import 'package:grocermate/core/error/failure.dart';
import 'package:grocermate/core/utils/enums/view_status.dart';
import 'package:grocermate/features/category/domain/entities/category_entity.dart';

class CategoriesState extends Equatable {
  const CategoriesState({
    this.status = ViewStatus.initial,
    this.categories = const [],
    this.failure,
  });

  final ViewStatus status;
  final List<CategoryEntity> categories;
  final Failure? failure;

  @override
  List<Object?> get props => [status, categories, failure];
}
