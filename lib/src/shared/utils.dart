String formatCurrency(double amount) {
  // Format number with thousands separator
  String formatted = amount.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},'
  );
  return '$formatted VND';
}
