String formatLiters(int ml) {
  final liters = ml / 1000;
  final fixed = liters.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}

String formatHours(int minutes) {
  final hours = minutes / 60;
  final fixed = hours.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}

String formatKm(int meters) {
  final km = meters / 1000;
  final fixed = km.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}

String formatTimeFromMinutes(int totalMinutes) {
  final normalized = totalMinutes.clamp(0, 1439);
  final hour = (normalized ~/ 60).toString().padLeft(2, '0');
  final minute = (normalized % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatMoney(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      buffer.write('.');
    }
  }
  return 'R\$ ${buffer.toString()}';
}

String formatDate(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  return '$day/$month/${value.year}';
}

String formatMemberSince(DateTime date) {
  const months = <int, String>{
    1: 'Janeiro',
    2: 'Fevereiro',
    3: 'Março',
    4: 'Abril',
    5: 'Maio',
    6: 'Junho',
    7: 'Julho',
    8: 'Agosto',
    9: 'Setembro',
    10: 'Outubro',
    11: 'Novembro',
    12: 'Dezembro',
  };

  return '${date.day} de ${months[date.month] ?? 'Janeiro'} de ${date.year}';
}

String formatDaysOfWeek(Set<int> daysOfWeek) {
  if (daysOfWeek.isEmpty) return '';
  if (daysOfWeek.length >= 7) return 'Todos os dias';
  const labels = <int, String>{
    1: 'Seg',
    2: 'Ter',
    3: 'Qua',
    4: 'Qui',
    5: 'Sex',
    6: 'Sáb',
    7: 'Dom',
  };
  final ordered = daysOfWeek.toList()..sort();
  final text = ordered.map((d) => labels[d]).whereType<String>().join(', ');
  return text.isEmpty ? '' : 'Dias: $text';
}
