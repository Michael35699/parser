import "package:freezed_annotation/freezed_annotation.dart";

part "metadata.g.dart";

@JsonSerializable(createToJson: false)
class Metadata {
  final int start;
  final int end;
  final int index;
  final int line;
  final String raw;
  final String url;

  Metadata({
    required this.start,
    required this.end,
    required this.index,
    required this.line,
    required this.raw,
    required this.url,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);
  Map<String, dynamic> toJson() => <String, dynamic>{};
}
