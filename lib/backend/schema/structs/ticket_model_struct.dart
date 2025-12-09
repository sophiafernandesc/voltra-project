// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TicketModelStruct extends BaseStruct {
  TicketModelStruct({
    int? id,
    String? title,
    String? date,
    String? destination,
  })  : _id = id,
        _title = title,
        _date = date,
        _destination = destination;

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

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  set date(String? val) => _date = val;

  bool hasDate() => _date != null;

  // "destination" field.
  String? _destination;
  String get destination => _destination ?? '';
  set destination(String? val) => _destination = val;

  bool hasDestination() => _destination != null;

  static TicketModelStruct fromMap(Map<String, dynamic> data) =>
      TicketModelStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        date: data['date'] as String?,
        destination: data['destination'] as String?,
      );

  static TicketModelStruct? maybeFromMap(dynamic data) => data is Map
      ? TicketModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'date': _date,
        'destination': _destination,
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
        'date': serializeParam(
          _date,
          ParamType.String,
        ),
        'destination': serializeParam(
          _destination,
          ParamType.String,
        ),
      }.withoutNulls;

  static TicketModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      TicketModelStruct(
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
        date: deserializeParam(
          data['date'],
          ParamType.String,
          false,
        ),
        destination: deserializeParam(
          data['destination'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TicketModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TicketModelStruct &&
        id == other.id &&
        title == other.title &&
        date == other.date &&
        destination == other.destination;
  }

  @override
  int get hashCode => const ListEquality().hash([id, title, date, destination]);
}

TicketModelStruct createTicketModelStruct({
  int? id,
  String? title,
  String? date,
  String? destination,
}) =>
    TicketModelStruct(
      id: id,
      title: title,
      date: date,
      destination: destination,
    );
