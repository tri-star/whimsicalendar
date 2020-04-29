import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/infrastructure/auth/google_authenticator.dart';
import 'package:whimsicalendar/infrastructure/repositories/calendar_event/calendar_repository.dart';
import 'package:whimsicalendar/pages/event/edit_form_view_model.dart';
import 'package:whimsicalendar/usecases/calendar_event/calendar_event_save_use_case.dart';
import 'package:whimsicalendar/widgets/date_time_input/date_input.dart';
import 'package:whimsicalendar/widgets/date_time_input/date_time_input.dart';
import 'package:whimsicalendar/widgets/labeled_checkbox.dart';

class EventEditPageArguments {
  CalendarEvent event;

  EventEditPageArguments({this.event});
}

class EventEditFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventEditPageArguments arguments =
        ModalRoute.of(context).settings.arguments;

    return MultiProvider(
        providers: [
          Provider<AuthenticatorInterface>(
              create: (_) => GoogleAuthenticator()),
          Provider<CalendarEventRepositoryInterface>(
              create: (_) => CalendarEventRepository()),
          Provider<CalendarEventSaveUseCase>(create: (BuildContext context) {
            return CalendarEventSaveUseCase(
                Provider.of<CalendarEventRepositoryInterface>(context,
                    listen: false));
          }),
          ChangeNotifierProvider<EditFormViewModel>(
              create: (BuildContext context) {
            return EditFormViewModel(
                authenticator:
                    Provider.of<AuthenticatorInterface>(context, listen: false),
                useCase: Provider.of<CalendarEventSaveUseCase>(context,
                    listen: false));
          }),
        ],
        child: Scaffold(
            appBar: AppBar(title: Text('イベントの編集')),
            body: EventEditForm(arguments)));
  }
}

class EventEditForm extends StatefulWidget {
  final CalendarEvent targetEvent;

  EventEditForm(EventEditPageArguments arguments)
      : targetEvent = arguments.event;

  @override
  State<StatefulWidget> createState() => EventEditFormState();
}

class EventEditFormState extends State<EventEditForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    EditFormViewModel viewModel =
        Provider.of<EditFormViewModel>(context, listen: false);
    viewModel.init(widget.targetEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Consumer<EditFormViewModel>(builder:
            (BuildContext context, EditFormViewModel viewModel, Widget widget) {
          return Form(
              key: viewModel.formKey,
              child: Column(children: [
                TextFormField(
                    controller: viewModel.nameController,
                    validator: (_) => viewModel.validateName(),
                    onChanged: (newValue) => viewModel.name = newValue,
                    decoration: InputDecoration(labelText: 'イベント名')),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: LabeledCheckBox(
                        checked: viewModel.isAllDay,
                        onChanged: (checked) => {viewModel.isAllDay = checked},
                        child: Text('終日'))),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _buildStartDayInput(context, viewModel)),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: _buildEndDayInput(context, viewModel)),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: TextFormField(
                        controller: viewModel.urlController,
                        onChanged: (newValue) => viewModel.url = newValue,
                        decoration: InputDecoration(labelText: 'URL'))),
                Expanded(
                  child: _buildSubmitButtonSection(context, viewModel),
                ),
              ]));
        }));
  }

  // 開始日入力欄を生成する(終日かどうかで入力欄が変化する)
  Widget _buildStartDayInput(
      BuildContext context, EditFormViewModel viewModel) {
    if (viewModel.isAllDay) {
      return DateInput(
          label: '開始日',
          initialValue: viewModel.startDateTime,
          onDateChanged: (DateTime date) => viewModel.startDate = date,
          validator: (DateTime dateTime) {
            if (dateTime == null) return '開始日は必ず入力してください。';
            return null;
          });
    }

    return DateTimeInput(
        label: '開始日時',
        initialValue: viewModel.startDateTime,
        onDateChanged: (DateTime date) => viewModel.startDate = date,
        onTimeChanged: (TimeOfDay time) => viewModel.startTime = time,
        validator: (DateTime dateTime) {
          if (dateTime == null) return '開始日時は必ず入力してください。';
          return null;
        });
  }

  // 終了日入力欄を生成する(終日かどうかで入力欄が変化する)
  Widget _buildEndDayInput(BuildContext context, EditFormViewModel viewModel) {
    if (viewModel.isAllDay) {
      return DateInput(
          label: '終了日',
          initialValue: widget.targetEvent.endDateTime,
          onDateChanged: (DateTime date) => viewModel.endDate = date,
          validator: (DateTime dateTime) {
            if (dateTime == null) return '終了日は必ず入力してください。';
            if (viewModel.startDateTime != null &&
                dateTime.isBefore(viewModel.startDateTime)) {
              return '終了日は開始日以降を指定してください。';
            }
            return null;
          });
    }

    return DateTimeInput(
        label: '終了日時',
        initialValue: widget.targetEvent.endDateTime,
        onDateChanged: (DateTime date) => viewModel.endDate = date,
        onTimeChanged: (TimeOfDay time) => viewModel.endTime = time,
        validator: (DateTime dateTime) {
          if (dateTime == null) return '終了日時は必ず入力してください。';
          if (viewModel.startDateTime != null &&
              dateTime.isBefore(viewModel.startDateTime)) {
            return '終了日時は開始日時以降を指定してください。';
          }
          return null;
        });
  }

  Widget _buildSubmitButtonSection(
      BuildContext context, EditFormViewModel viewModel) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('キャンセル'),
            ),
            RaisedButton(
              onPressed: () async {
                final bool succeed = await viewModel.updateEvent();
                if (succeed) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text('更新'),
            ),
          ],
        ));
  }
}
