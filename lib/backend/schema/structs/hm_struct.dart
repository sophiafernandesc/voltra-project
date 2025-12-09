// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HmStruct extends BaseStruct {
  HmStruct({
    String? title,
    String? subTitle,
  })  : _title = title,
        _subTitle = subTitle;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "sub_title" field.
  String? _subTitle;
  String get subTitle => _subTitle ?? '';
  set subTitle(String? val) => _subTitle = val;

  bool hasSubTitle() => _subTitle != null;

  static HmStruct fromMap(Map<String, dynamic> data) => HmStruct(
        title: data['title'] as String?,
        subTitle: data['sub_title'] as String?,
      );

  static HmStruct? maybeFromMap(dynamic data) =>
      data is Map ? HmStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'sub_title': _subTitle,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'sub_title': serializeParam(
          _subTitle,
          ParamType.String,
        ),
      }.withoutNulls;

  static HmStruct fromSerializableMap(Map<String, dynamic> data) => HmStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        subTitle: deserializeParam(
          data['sub_title'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'HmStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HmStruct &&
        title == other.title &&
        subTitle == other.subTitle;
  }

  @override
  int get hashCode => const ListEquality().hash([title, subTitle]);
}

HmStruct createHmStruct({
  String? title,
  String? subTitle,
}) =>
    HmStruct(
      title: title,
      subTitle: subTitle,
    );
