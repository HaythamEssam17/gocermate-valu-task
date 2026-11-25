import 'package:material_ui/material_ui.dart';

class PriceHistoryPainter extends CustomPainter {
  PriceHistoryPainter(this.prices, this.color, this.grid);
  final List<double> prices;
  final Color color;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    final min = prices.reduce((a, b) => a < b ? a : b);
    final max = prices.reduce((a, b) => a > b ? a : b);
    final range = (max - min) == 0 ? 1.0 : (max - min);
    const pad = 8.0;

    Offset point(int i) => Offset(
      pad + (size.width - pad * 2) * i / (prices.length - 1),
      size.height - pad - (size.height - pad * 2) * (prices[i] - min) / range,
    );

    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      Paint()..color = grid,
    );
    final path = Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < prices.length; i++) {
      path.lineTo(point(i).dx, point(i).dy);
    }
    final fill = Path.from(path)
      ..lineTo(point(prices.length - 1).dx, size.height)
      ..lineTo(point(0).dx, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = color.withAlpha(35));
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(point(prices.length - 1), 4.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(PriceHistoryPainter old) =>
      old.prices != prices || old.color != color;
}
