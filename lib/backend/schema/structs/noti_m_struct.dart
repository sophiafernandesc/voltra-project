// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotiMStruct extends BaseStruct {
  NotiMStruct({
    int? id,
    String? title,
    String? time,
  })  : _id = id,
        _title = title,
        _time = time;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "time" field.
  String? _time;
  String get time => _time ?? '';
  set time(String? val) => _time = val;

  bool hasTime() => _time != null;

  static NotiMStruct fromMap(Map<String, dynamic> data) => NotiMStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        time: data['time'] as String?,
      );

  static NotiMStruct? maybeFromMap(dynamic data) =>
      data is Map ? NotiMStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'time': _time,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'time': serializeParam(
          _time,
          ParamType.String,
        ),
      }.withoutNulls;

  static NotiMStruct fromSerializableMap(Map<String, dynamic> data) =>
      NotiMStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        time: deserializeParam(
          data['time'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'NotiMStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NotiMStruct &&
        id == other.id &&
        title == other.title &&
        time == other.time;
  }

  @override
  int get hashCode => const ListEquality().hash([id, title, time]);
}

NotiMStruct createNotiMStruct({
  int? id,
  String? title,
  String? time,
}) =>
    NotiMStruct(
      id: id,
      title: title,
      time: time,
    );
