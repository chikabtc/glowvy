// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cosmetics_rank.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CosmeticsRank _$CosmeticsRankFromJson(Map<String, dynamic> json) {
  return CosmeticsRank(
    json['sensitive_skin_rank'] as Map<String, dynamic>,
    json['all_skin_rank'] as Map<String, dynamic>,
    json['dry_skin_rank'] as Map<String, dynamic>,
    json['oily_skin_rank'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$CosmeticsRankToJson(CosmeticsRank instance) =>
    <String, dynamic>{
      'sensitive_skin_rank': instance.sensitiveSkinRank,
      'oily_skin_rank': instance.oilySkinRank,
      'dry_skin_rank': instance.drySkinRank,
      'all_skin_rank': instance.allSkinRank,
    };
