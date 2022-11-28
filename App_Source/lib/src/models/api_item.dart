class ApiItem{
  final String path;
  final String mode;
  final String type;
  final String sha;
  final int size;
  final String url;

  ApiItem({
    required this.path,
    required this.mode,
    required this.type,
    required this.sha,
    required this.size,
    required this.url,
  });

  factory ApiItem.fromJson(Map<String, dynamic> json){
    return ApiItem(
        path: json['path'],
        mode : json['mode'],
        type : json ['type'],
        sha : json ['sha'],
        size : json ['size'] ?? 0,
        url : json ['url'],
    );
  }

  ApiItem copyWith({
    String? path,
    String? mode,
    String? type,
    String? sha,
    int? size,
    String? url,
  }) {
    return ApiItem(
      path: path ?? this.path,
      mode: mode ?? this.mode,
      type: type ?? this.type,
      sha: sha ?? this.sha,
      size: size ?? this.size,
      url: url ?? this.url,
    );
  }
}