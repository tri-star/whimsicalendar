import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/widgets/labeled_checkbox.dart';

import 'register_form_view_model.dart';

/// イベント登録画面に渡すパラメータ
class EventRegisterPageArguments {
  DateTime currentDate;

  EventRegisterPageArguments({this.currentDate});
}

/// イベント登録画面
class EventRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventRegisterPageArguments arguments =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(title: Text('イベント登録')),
        body: EventRegisterForm(arguments.currentDate));
  }
}

class EventRegisterForm extends StatefulWidget {
  DateTime currentDate;

  EventRegisterForm(this.currentDate);

  @override
  State<StatefulWidget> createState() => EventRegisterFormState();
}

class EventRegisterFormState extends State<EventRegisterForm> {
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => RegisterFormViewModel(widget.currentDate),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Consumer<RegisterFormViewModel>(builder:
                (BuildContext context, RegisterFormViewModel viewModel,
                    Widget _) {
              return Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      initialValue: viewModel.name,
                      onChanged: (newValue) => viewModel.name = newValue,
                      decoration: InputDecoration(labelText: 'イベント名'),
                    ),
                    LabeledCheckBox(
                        checked: viewModel.isAllDay,
                        onChanged: (checked) => {viewModel.isAllDay = checked},
                        child: Text('終日')),
                    _buildStartDayInput(context, viewModel)
                  ]));
            })));
  }

  // 開始日入力欄を生成する(終日かどうかで入力欄が変化する)
  Widget _buildStartDayInput(
      BuildContext context, RegisterFormViewModel viewModel) {
    if (viewModel.isAllDay) {
      return Row(children: [
        SizedBox(width: 100, child: Text('開始日')),
        Icon(Icons.calendar_today),
        Expanded(
            child: GestureDetector(
                onTap: () async {
                  viewModel.startDate =
                      await _showDatePickerPopup(viewModel.startDate);
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black))),
                    child: Text(viewModel.formatDate(viewModel.startDate)))))
      ]);
    }

    return Row(children: [
      SizedBox(width: 100, child: Text('開始日時')),
      Icon(Icons.calendar_today),
      Expanded(
          child: GestureDetector(
              onTap: () async {
                viewModel.startDate =
                    await _showDatePickerPopup(viewModel.startDate);
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                  child: Text(viewModel.formatDate(viewModel.startDate))))),
      Icon(Icons.watch),
      Expanded(
          child: GestureDetector(
              onTap: () async {
                await _showDateTimePickerPopup(viewModel.startDate);
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                  child: Text(viewModel.formatDate(viewModel.startDate)))))
    ]);
  }

  Future<DateTime> _showDatePickerPopup(DateTime initialDate) async {
    if (initialDate == null) {
      initialDate = DateTime.now();
    }
    return await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime(DateTime.now().year + 2));
  }

  Future<DateTime> _showDateTimePickerPopup(DateTime initialTime) async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return null;
  }
}
