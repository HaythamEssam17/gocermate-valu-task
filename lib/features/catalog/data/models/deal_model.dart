class DealDto {
  const DealDto({
    required this.productId,
    required this.dealPrice,
    required this.endsAt,
  });

  final String productId;
  final double dealPrice;
  final DateTime endsAt;

  static List<DealDto> listFromJson(dynamic json) {
    if (json == null) return const [];

    final List<dynamic> list;
    if (json is List) {
      list = json;
    } else if (json is Map) {
      final items = json['items'] ?? json['deals'] ?? json['data'];
      if (items is List) {
        list = items;
      } else {
        return const [];
      }
    } else {
      return const [];
    }

    return list
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .map(
          (e) => DealDto(
            productId: e['productId'] as String,
            dealPrice: (e['dealPrice'] as num).toDouble(),
            endsAt: DateTime.parse(e['endsAt'] as String).toLocal(),
          ),
        )
        .toList();
  }
}
