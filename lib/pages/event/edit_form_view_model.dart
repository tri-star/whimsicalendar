import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/usecases/calendar_event/calendar_event_save_use_case.dart';

/// イベント編集画面のViewModel
class EditFormViewModel with ChangeNotifier {
  CalendarEvent _event;

  GlobalKey<FormState> formKey;
  TextEditingController nameController;
  TextEditingController urlController;
  AuthenticatorInterface _authenticator;
  CalendarEventSaveUseCase _useCase;

  EditFormViewModel(
      {AuthenticatorInterface authenticator, CalendarEventSaveUseCase useCase})
      : _authenticator = authenticator,
        _useCase = useCase {
    assert(_authenticator != null);
    assert(_useCase != null);
  }

  void init(CalendarEvent event) {
    _event = event;
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: _event.name);
    urlController = TextEditingController(text: _event.url);
  }

  String get name => _event.name;
  set name(String newName) {
    _event.name = newName;
    notifyListeners();
  }

  String get url => _event.url;
  set url(String newUrl) {
    _event.url = newUrl;
    notifyListeners();
  }

  bool get isAllDay => _event.isAllDay;
  set isAllDay(bool value) {
    _event.isAllDay = value;
    notifyListeners();
  }

  DateTime get startDateTime => _event.startDateTime;

  DateTime get startDate => _event.getStartDate();
  set startDate(DateTime newDate) {
    if (newDate == null) {
      return;
    }
    _event.startDateTime = newDate;
    notifyListeners();
  }

  DateTime get endDateTime => _event.endDateTime;
  DateTime get endDate => _event.getEndDate();
  set endDate(DateTime newDate) {
    if (newDate == null) {
      return;
    }
    _event.endDateTime = newDate;
    notifyListeners();
  }

  TimeOfDay get startTime {
    DateTime date = _event.startDateTime;
    if (date == null) {
      return null;
    }
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  set startTime(TimeOfDay time) {
    if (time == null) {
      return;
    }
    _event.startDateTime = DateTime(
        _event.startDateTime.year,
        _event.startDateTime.month,
        _event.startDateTime.day,
        time.hour,
        time.minute,
        0);
    notifyListeners();
  }

  TimeOfDay get endTime {
    DateTime date = _event.endDateTime;
    if (date == null) {
      return null;
    }
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  set endTime(TimeOfDay time) {
    if (time == null) {
      return;
    }
    _event.endDateTime = DateTime(
        _event.endDateTime.year,
        _event.endDateTime.month,
        _event.endDateTime.day,
        time.hour,
        time.minute,
        0);
    notifyListeners();
  }

  String formatDate(DateTime date) {
    if (date == null) {
      return '';
    }
    return DateFormat('y-MM-dd').format(date);
  }

  String formatTime(TimeOfDay time) {
    if (time == null) {
      return '';
    }
    NumberFormat timeFormat = NumberFormat('00');
    return '${timeFormat.format(time.hour)}:${timeFormat.format(time.minute)}';
  }

  /// 氏名のバリデーション
  String validateName() {
    var errors = _event.validateName();
    if (errors.length == 0) {
      return null;
    }
    return errors.join("\n");
  }

  /// 開始日時のバリデーション
  String validateStartDateTime() {
    var errors = _event.validateStartDateTime();
    if (errors.length == 0) {
      return null;
    }
    return errors.join("\n");
  }

  /// イベントの登録を実行する
  Future<bool> updateEvent() async {
    try {
      if (!formKey.currentState.validate()) {
        return false;
      }
      await _useCase.execute(await _authenticator.getUser(), _event);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
