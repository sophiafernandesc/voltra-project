// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PmmStruct extends BaseStruct {
  PmmStruct({
    int? id,
    String? img,
    String? method,
  })  : _id = id,
        _img = img,
        _method = method;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "img" field.
  String? _img;
  String get img => _img ?? '';
  set img(String? val) => _img = val;

  bool hasImg() => _img != null;

  // "method" field.
  String? _method;
  String get method => _method ?? '';
  set method(String? val) => _method = val;

  bool hasMethod() => _method != null;

  static PmmStruct fromMap(Map<String, dynamic> data) => PmmStruct(
        id: castToType<int>(data['id']),
        img: data['img'] as String?,
        method: data['method'] as String?,
      );

  static PmmStruct? maybeFromMap(dynamic data) =>
      data is Map ? PmmStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'img': _img,
        'method': _method,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'img': serializeParam(
          _img,
          ParamType.String,
        ),
        'method': serializeParam(
          _method,
          ParamType.String,
        ),
      }.withoutNulls;

  static PmmStruct fromSerializableMap(Map<String, dynamic> data) => PmmStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        img: deserializeParam(
          data['img'],
          ParamType.String,
          false,
        ),
        method: deserializeParam(
          data['method'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PmmStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PmmStruct &&
        id == other.id &&
        img == other.img &&
        method == other.method;
  }

  @override
  int get hashCode => const ListEquality().hash([id, img, method]);
}

PmmStruct createPmmStruct({
  int? id,
  String? img,
  String? method,
}) =>
    PmmStruct(
      id: id,
      img: img,
      method: method,
    );
