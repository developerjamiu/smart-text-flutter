extension StringX on String {
  String humanizeUrl(bool humanize) {
    if (!humanize) return this;

    final uri = Uri.parse(this);

    return uri.host;
  }
}
