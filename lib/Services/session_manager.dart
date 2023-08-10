class SessionController {
  static final SessionController _session = SessionController._internal();
  String? userID;

  factory SessionController() {
    return _session;
  }
  SessionController._internal();
}
