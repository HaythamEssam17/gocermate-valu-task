import 'package:flutter/foundation.dart';
import 'package:grocermate/core/utils/enums/purchase_scenario.dart';

class MockServerConfig extends ChangeNotifier {
  bool simulateOffline = false;
  double failureRate = 0;
  int minLatencyMs = 250;
  int maxLatencyMs = 700;
  PurchaseScenario nextPurchaseScenario = PurchaseScenario.auto;

  void update({
    bool? simulateOffline,
    double? failureRate,
    int? minLatencyMs,
    int? maxLatencyMs,
    PurchaseScenario? nextPurchaseScenario,
  }) {
    this.simulateOffline = simulateOffline ?? this.simulateOffline;
    this.failureRate = failureRate ?? this.failureRate;
    this.minLatencyMs = minLatencyMs ?? this.minLatencyMs;
    this.maxLatencyMs = maxLatencyMs ?? this.maxLatencyMs;
    this.nextPurchaseScenario =
        nextPurchaseScenario ?? this.nextPurchaseScenario;
    notifyListeners();
  }

  PurchaseScenario takeScenario() {
    final s = nextPurchaseScenario;
    if (s != PurchaseScenario.auto) {
      nextPurchaseScenario = PurchaseScenario.auto;
      notifyListeners();
    }
    return s;
  }
}
