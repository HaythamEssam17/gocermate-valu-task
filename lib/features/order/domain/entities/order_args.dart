class OrderArgs {
  const OrderArgs({
    required this.orderId,
    this.partialMissing = 0,
    this.fromOutbox = false,
  });
  final String orderId;
  final int partialMissing;
  final bool fromOutbox;
}
