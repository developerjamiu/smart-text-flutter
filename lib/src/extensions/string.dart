extension StringX on String {
  String humanizeUrl(bool humanize) {
    if (!humanize) return this;
    if (!startsWith('http')) return this;

    final uri = Uri.parse(this);

    return uri.host;
  }
}
