import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/usecases/calendar_event/calendar_event_register_use_case.dart';

class RegisterFormViewModel with ChangeNotifier {
  BuildContext _context;
  CalendarEvent _event;

  GlobalKey<FormState> formKey;
  TextEditingController nameController;
  TextEditingController urlController;
  FormFieldState<DateTime> startDateTimeState;
  FormFieldState<DateTime> endDateTimeState;
  FormFieldState<DateTime> startDateState;
  FormFieldState<DateTime> endDateState;

  RegisterFormViewModel(BuildContext context, DateTime currentDate)
      : _event = CalendarEvent() {
    _context = context;
    _event.startDateTime = currentDate;
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    urlController = TextEditingController();
    startDateTimeState = FormFieldState<DateTime>();
    endDateTimeState = FormFieldState<DateTime>();
    startDateState = FormFieldState<DateTime>();
    endDateState = FormFieldState<DateTime>();
  }

  String get name => _event.name;
  set name(String newName) {
    _event.name = newName;
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
  Future<bool> registerEvent() async {
    AuthenticatorInterface authenticator =
        Provider.of<AuthenticatorInterface>(_context, listen: false);
    CalendarEventRegisterUseCase useCase =
        Provider.of<CalendarEventRegisterUseCase>(_context, listen: false);

    try {
      if (!formKey.currentState.validate()) {
        return false;
      }
      await useCase.execute(await authenticator.getUser(), _event);
      nameController.clear();
      urlController.clear();
      startDateTimeState.reset();
      endDateTimeState.reset();
      name = '';
      notifyListeners();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
