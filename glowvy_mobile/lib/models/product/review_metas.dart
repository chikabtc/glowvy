import 'package:Dimodo/models/product/review_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_metas.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ReviewMetas {
  ReviewMeta all;
  ReviewMeta complex;
  ReviewMeta dry;
  ReviewMeta neutral;
  ReviewMeta oily;
  ReviewMeta sensitive;

  ReviewMetas(
    this.all,
    this.neutral,
    this.dry,
    this.complex,
    this.oily,
    this.sensitive,
  );
  factory ReviewMetas.fromJson(Map<String, dynamic> json) =>
      _$ReviewMetasFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewMetasToJson(this);
}
