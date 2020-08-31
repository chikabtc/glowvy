import 'package:json_annotation/json_annotation.dart';

part 'skinScores.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SkinScores {
  double dsScore;
  double srScore;
  double pnScore;
  double wnScore;
  SkinScores(this.dsScore, this.pnScore, this.srScore, this.wnScore);

  factory SkinScores.fromJson(Map<String, dynamic> json) =>
      _$SkinScoresFromJson(json);
  Map<String, dynamic> toJson() => _$SkinScoresToJson(this);
}
