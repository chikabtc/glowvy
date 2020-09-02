// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skinScores.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkinScores _$SkinScoresFromJson(Map<String, dynamic> json) {
  return SkinScores(
    dsScore: (json['ds_score'] as num)?.toDouble(),
    pnScore: (json['pn_score'] as num)?.toDouble(),
    srScore: (json['sr_score'] as num)?.toDouble(),
    wnScore: (json['wn_score'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SkinScoresToJson(SkinScores instance) =>
    <String, dynamic>{
      'ds_score': instance.dsScore,
      'sr_score': instance.srScore,
      'pn_score': instance.pnScore,
      'wn_score': instance.wnScore,
    };
