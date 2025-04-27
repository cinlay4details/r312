import 'dart:developer' as developer;

({
  String host,
  String? password,
  String protocol,
  String topic,
  String? username,
  int port,
})
parseMqttUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null ||
      !uri.hasScheme ||
      uri.host.isEmpty ||
      uri.pathSegments.isEmpty) {
    throw const FormatException('Invalid MQTT URL format');
  }

  final username =
      uri.userInfo.contains(':') ? uri.userInfo.split(':')[0] : null;
  final password =
      uri.userInfo.contains(':') ? uri.userInfo.split(':')[1] : null;

  final postHost = uri.pathSegments.join('/').split('//');
  developer.log('pathSegments: ${uri.pathSegments}');
  final host = '${uri.host}/${postHost[0]}';
  final topic = postHost[1];

  final response = (
    protocol: uri.scheme, // ws | wss | mqtt | mqtts
    username: username, // optional, string
    password: password, // optional, string
    port: uri.port, // 8884
    host: host, // blah.cloud/mqtt
    topic: topic, // test
  );
  developer.log('Parsed MQTT URL: $response');
  return response;
}
