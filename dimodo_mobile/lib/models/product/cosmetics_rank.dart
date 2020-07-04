import 'package:json_annotation/json_annotation.dart';

part 'cosmetics_rank.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CosmeticsRank {
  Map<String, dynamic> sensitiveSkinRank;
  Map<String, dynamic> oilySkinRank;
  Map<String, dynamic> drySkinRank;
  Map<String, dynamic> allSkinRank;

  CosmeticsRank(
    this.sensitiveSkinRank,
    this.allSkinRank,
    this.drySkinRank,
    this.oilySkinRank,
  );
  factory CosmeticsRank.fromJson(Map<String, dynamic> json) =>
      _$CosmeticsRankFromJson(json);
  Map<String, dynamic> toJson() => _$CosmeticsRankToJson(this);
}
