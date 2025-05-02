// Simple implementation to avoid intl dependency issues
class DateFormat {
  final String _format;
  
  DateFormat(this._format);
  
  String format(DateTime dateTime) {
    // Simple formatter implementation
    if (_format == 'HH:mm') {
      return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
    } else if (_format == 'dd/MM/yyyy') {
      return '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year}';
    } else if (_format == 'dd/MM/yyyy HH:mm') {
      return '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year} ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}';
    }
    return dateTime.toString();
  }
  
  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }
}

class DateFormatter {
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }
} 