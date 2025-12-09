import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _isIntro = prefs.getBool('ff_isIntro') ?? _isIntro;
    });
    _safeInit(() {
      _introIndex = prefs.getInt('ff_introIndex') ?? _introIndex;
    });
    _safeInit(() {
      _isLogin = prefs.getBool('ff_isLogin') ?? _isLogin;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _isIntro = false;
  bool get isIntro => _isIntro;
  set isIntro(bool value) {
    _isIntro = value;
    prefs.setBool('ff_isIntro', value);
  }

  int _introIndex = 0;
  int get introIndex => _introIndex;
  set introIndex(int value) {
    _introIndex = value;
    prefs.setInt('ff_introIndex', value);
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  set isLogin(bool value) {
    _isLogin = value;
    prefs.setBool('ff_isLogin', value);
  }

  //Primeiro Nome do Usuário
  String _userFirstName = ''; 
  String get userFirstName => _userFirstName;
  set userFirstName(String value) {
    _userFirstName = value;
  }

  //Sobrenome do Usuário
  String _userLastName = ''; 
  String get userLastName => _userLastName;
  set userLastName(String value) {
    _userLastName = value;
  }

  //Email do Usuário
  String _userEmail = ''; 
  String get userEmail => _userEmail;
  set userEmail(String value) {
    _userEmail = value;
  }

  //ID do Usuário
  int _userId = 0; 
  int get userId => _userId;
  set userId(int value) {
    _userId = value;
  }

  List<TicketModelStruct> _updeparturesList = [
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"0\",\"title\":\"Rammurthy nagar, Bangalore\",\"date\":\"18 Aug, 2021 15:25\",\"destination\":\"Gate 1C\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"1\",\"title\":\"South Keenan, NE 65240\",\"date\":\"08 Dec, 2021 03:14\",\"destination\":\"Gate 2B\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"2\",\"title\":\"Julianna Mission Quitzonb\",\"date\":\"04 Jan, 2021 02:15\",\"destination\":\"Gate 3\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"3\",\"title\":\"Lake Frances\",\"date\":\"05 Feb, 2021 02:21\",\"destination\":\"Gate 4A\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"4\",\"title\":\"West Randolph, ME\",\"date\":\"17 Mar, 2021 03:15\",\"destination\":\"Gate 4D\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"5\",\"title\":\"Elvin Unions New Patrick\",\"date\":\"08 Apr, 2021 04:25\",\"destination\":\"Gate 2A\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"6\",\"title\":\"Hermistonfort, SD\",\"date\":\"27 May, 2021 02:15\",\"destination\":\"Gate 3A\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"7\",\"title\":\"Cyndy Mea Rolfsonmouth\",\"date\":\"04 Jan, 2021 02:15\",\"destination\":\"Gate 3\"}'))
  ];
  List<TicketModelStruct> get updeparturesList => _updeparturesList;
  set updeparturesList(List<TicketModelStruct> value) {
    _updeparturesList = value;
  }

  void addToUpdeparturesList(TicketModelStruct value) {
    updeparturesList.add(value);
  }

  void removeFromUpdeparturesList(TicketModelStruct value) {
    updeparturesList.remove(value);
  }

  void removeAtIndexFromUpdeparturesList(int index) {
    updeparturesList.removeAt(index);
  }

  void updateUpdeparturesListAtIndex(
    int index,
    TicketModelStruct Function(TicketModelStruct) updateFn,
  ) {
    updeparturesList[index] = updateFn(_updeparturesList[index]);
  }

  void insertAtIndexInUpdeparturesList(int index, TicketModelStruct value) {
    updeparturesList.insert(index, value);
  }

  List<NotiMStruct> _notificationList = [
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"0\",\"title\":\"You can use this generator to create.\",\"time\":\"Just now\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"1\",\"title\":\"After which the tool will generate.\",\"time\":\"1 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"2\",\"title\":\"During your manual automated tests\",\"time\":\"2 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"3\",\"title\":\"Addresses which can be used for jak\",\"time\":\"10 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"4\",\"title\":\"Form that requires a postal address\",\"time\":\"20 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"5\",\"title\":\"We use an utility called Fake progres\",\"time\":\"30 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"6\",\"title\":\"Generate data such as random add\",\"time\":\"40 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"7\",\"title\":\"You can use this yourself with Nodej\",\"time\":\"50 Min\"}')),
    NotiMStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"8\",\"title\":\"You can use this generator to create.\",\"time\":\"55 Min\"}'))
  ];
  List<NotiMStruct> get notificationList => _notificationList;
  set notificationList(List<NotiMStruct> value) {
    _notificationList = value;
  }

  void addToNotificationList(NotiMStruct value) {
    notificationList.add(value);
  }

  void removeFromNotificationList(NotiMStruct value) {
    notificationList.remove(value);
  }

  void removeAtIndexFromNotificationList(int index) {
    notificationList.removeAt(index);
  }

  void updateNotificationListAtIndex(
    int index,
    NotiMStruct Function(NotiMStruct) updateFn,
  ) {
    notificationList[index] = updateFn(_notificationList[index]);
  }

  void insertAtIndexInNotificationList(int index, NotiMStruct value) {
    notificationList.insert(index, value);
  }

  List<String> _searchResult = [];
  List<String> get searchResult => _searchResult;
  set searchResult(List<String> value) {
    _searchResult = value;
  }

  void addToSearchResult(String value) {
    searchResult.add(value);
  }

  void removeFromSearchResult(String value) {
    searchResult.remove(value);
  }

  void removeAtIndexFromSearchResult(int index) {
    searchResult.removeAt(index);
  }

  void updateSearchResultAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    searchResult[index] = updateFn(_searchResult[index]);
  }

  void insertAtIndexInSearchResult(int index, String value) {
    searchResult.insert(index, value);
  }

  List<TicketModelStruct> _todayTicketList = [
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"0\",\"title\":\"Billy\'s Bomber\",\"date\":\"14 Jan, 2021 12:00\",\"destination\":\"Naperville\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"1\",\"title\":\"MitchellBlackbird\",\"date\":\"15 Aug, 2021 02:50\",\"destination\":\"Austin\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"2\",\"title\":\"Black JetLockheed \",\"date\":\"25 Feb, 2021 03:00\",\"destination\":\"Orange\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"3\",\"title\":\"Hercules\",\"date\":\"18 Aug, 2021 15:25\",\"destination\":\"Naperville\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"5\",\"title\":\"Etymology and usage\",\"date\":\"18 Aug, 2021 15:25\",\"destination\":\"Gate 1C\"}'))
  ];
  List<TicketModelStruct> get todayTicketList => _todayTicketList;
  set todayTicketList(List<TicketModelStruct> value) {
    _todayTicketList = value;
  }

  void addToTodayTicketList(TicketModelStruct value) {
    todayTicketList.add(value);
  }

  void removeFromTodayTicketList(TicketModelStruct value) {
    todayTicketList.remove(value);
  }

  void removeAtIndexFromTodayTicketList(int index) {
    todayTicketList.removeAt(index);
  }

  void updateTodayTicketListAtIndex(
    int index,
    TicketModelStruct Function(TicketModelStruct) updateFn,
  ) {
    todayTicketList[index] = updateFn(_todayTicketList[index]);
  }

  void insertAtIndexInTodayTicketList(int index, TicketModelStruct value) {
    todayTicketList.insert(index, value);
  }

  List<PmmStruct> _pmList = [
    PmmStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"0\",\"img\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tacking-app-p6j9b1/assets/f0jcbl1t1u8o/g_pay_ic.png\",\"method\":\"Google pay\"}')),
    PmmStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"1\",\"img\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tacking-app-p6j9b1/assets/dfrge52xhsfg/paypal_img.png\",\"method\":\"PayPal\"}')),
    PmmStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"2\",\"img\":\"https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/tacking-app-p6j9b1/assets/x1pdqikgumub/visa_img.png\",\"method\":\"Visa\"}'))
  ];
  List<PmmStruct> get pmList => _pmList;
  set pmList(List<PmmStruct> value) {
    _pmList = value;
  }

  void addToPmList(PmmStruct value) {
    pmList.add(value);
  }

  void removeFromPmList(PmmStruct value) {
    pmList.remove(value);
  }

  void removeAtIndexFromPmList(int index) {
    pmList.removeAt(index);
  }

  void updatePmListAtIndex(
    int index,
    PmmStruct Function(PmmStruct) updateFn,
  ) {
    pmList[index] = updateFn(_pmList[index]);
  }

  void insertAtIndexInPmList(int index, PmmStruct value) {
    pmList.insert(index, value);
  }

  List<TicketModelStruct> _bookmarkList = [
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"0\",\"title\":\"Julianna Mission Quitzonb\",\"date\":\"04 Jan, 2021 02:15\",\"destination\":\"Gate 3\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"1\",\"title\":\"Lake Frances\",\"date\":\"05 Feb, 2021 02:21\",\"destination\":\"Gate 4A\"}')),
    TicketModelStruct.fromSerializableMap(jsonDecode(
        '{\"id\":\"2\",\"title\":\"West Randolph, ME\",\"date\":\"17 Mar, 2021 03:15\",\"destination\":\"Gate 4D\"}'))
  ];
  List<TicketModelStruct> get bookmarkList => _bookmarkList;
  set bookmarkList(List<TicketModelStruct> value) {
    _bookmarkList = value;
  }

  void addToBookmarkList(TicketModelStruct value) {
    bookmarkList.add(value);
  }

  void removeFromBookmarkList(TicketModelStruct value) {
    bookmarkList.remove(value);
  }

  void removeAtIndexFromBookmarkList(int index) {
    bookmarkList.removeAt(index);
  }

  void updateBookmarkListAtIndex(
    int index,
    TicketModelStruct Function(TicketModelStruct) updateFn,
  ) {
    bookmarkList[index] = updateFn(_bookmarkList[index]);
  }

  void insertAtIndexInBookmarkList(int index, TicketModelStruct value) {
    bookmarkList.insert(index, value);
  }

  List<HmStruct> _helpQList = [
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"How to check flight ticket price?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}')),
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"How to check flight ticket price?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}')),
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"What is the cheapest day to fly?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}')),
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Which airline is the cheapest in India?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}')),
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Which flight is best in India?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}')),
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"Which website gives cheapest flights?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}')),
    HmStruct.fromSerializableMap(jsonDecode(
        '{\"title\":\"What times are flights the cheapest?\",\"sub_title\":\"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\"}'))
  ];
  List<HmStruct> get helpQList => _helpQList;
  set helpQList(List<HmStruct> value) {
    _helpQList = value;
  }

  void addToHelpQList(HmStruct value) {
    helpQList.add(value);
  }

  void removeFromHelpQList(HmStruct value) {
    helpQList.remove(value);
  }

  void removeAtIndexFromHelpQList(int index) {
    helpQList.removeAt(index);
  }

  void updateHelpQListAtIndex(
    int index,
    HmStruct Function(HmStruct) updateFn,
  ) {
    helpQList[index] = updateFn(_helpQList[index]);
  }

  void insertAtIndexInHelpQList(int index, HmStruct value) {
    helpQList.insert(index, value);
  }

  // --- Cars list (simple in-memory list of registered car names) ---
  List<String> _carList = ['Chevrolet Onix 2019'];
  List<String> get carList => _carList;
  set carList(List<String> value) {
    _carList = value;
  }

  void addToCarList(String value) {
    carList.add(value);
  }

  void removeFromCarList(String value) {
    carList.remove(value);
  }

  void removeAtIndexFromCarList(int index) {
    carList.removeAt(index);
  }

  void updateCarListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    carList[index] = updateFn(_carList[index]);
  }

  void insertAtIndexInCarList(int index, String value) {
    carList.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
