Future<void> Function() throttle(
  Future<void> Function() fn,
  Duration duration,
) {
  Future<void>? throttle;
  var pendingThrottle = false;

  late final Future<void> Function() caller;
  return caller = () async {
    if (throttle != null) {
      pendingThrottle = true;
      return throttle;
    }
    await fn();
    pendingThrottle = false;
    return throttle = Future<void>.delayed(duration, () {
      throttle = null;
      if (pendingThrottle) {
        return caller();
      }
    });
  };
}
