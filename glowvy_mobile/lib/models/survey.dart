import 'package:json_annotation/json_annotation.dart';

part 'survey.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Survey {
  String question;
  String type;
  List<String> options;
  String answer;
  Survey(this.question, this.options, this.type, this.answer);
  factory Survey.fromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyToJson(this);
}
