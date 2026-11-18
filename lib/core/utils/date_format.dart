String apiDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

String displayDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String addMinutesToTime(String value, int minutesToAdd) {
  final parts = value.split(':');
  if (parts.length != 2) return value;
  final total = (int.tryParse(parts[0]) ?? 0) * 60 +
      (int.tryParse(parts[1]) ?? 0) +
      minutesToAdd;
  final hours = (total ~/ 60).toString().padLeft(2, '0');
  final minutes = (total % 60).toString().padLeft(2, '0');
  return '$hours:$minutes';
}
