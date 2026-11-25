import 'package:grocermate/core/domain/entities/paginated_result.dart';

class PaginatedResultModel {
  const PaginatedResultModel._();

  static PaginatedResult<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson,
  ) {
    return PaginatedResult<T>(
      items: (json['data'] as List)
          .map<T>((e) => itemFromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );
  }
}
