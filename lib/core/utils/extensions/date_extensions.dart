extension DateExtensions on DateTime {
  String timeAgo({DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(this);
    if (diff.inSeconds < 45) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    return '${diff.inDays} d ago';
  }

  String endsIn({DateTime? now}) {
    final diff = difference(now ?? DateTime.now());
    if (diff.isNegative) return 'Ended';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return h > 0 ? 'Ends in ${h}h ${m}m' : 'Ends in ${m}m';
  }
}
