import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: LabeledCheckBox(
                            checked: viewModel.isAllDay,
                            onChanged: (checked) =>
                                {viewModel.isAllDay = checked},
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
                            initialValue: '',
                            onChanged: (newValue) => {},
                            decoration: InputDecoration(labelText: 'URL'))),
                    Expanded(
                      child: _buildSubmitButtonSection(context, viewModel),
                    ),
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
                  child: Text(
                    viewModel.formatDate(viewModel.startDate),
                    textAlign: TextAlign.right,
                  )))),
      Icon(Icons.watch),
      Expanded(
          child: GestureDetector(
              onTap: () async {
                viewModel.startTime =
                    await _showDateTimePickerPopup(viewModel.startTime);
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                  child: Text(
                    viewModel.formatTime(viewModel.startTime),
                    textAlign: TextAlign.right,
                  ))))
    ]);
  }

  // 終了日入力欄を生成する(終日かどうかで入力欄が変化する)
  Widget _buildEndDayInput(
      BuildContext context, RegisterFormViewModel viewModel) {
    if (viewModel.isAllDay) {
      return Row(children: [
        SizedBox(width: 100, child: Text('終了日')),
        Icon(Icons.calendar_today),
        Expanded(
            child: GestureDetector(
                onTap: () async {
                  viewModel.endDate =
                      await _showDatePickerPopup(viewModel.endDate);
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black))),
                    child: Text(viewModel.formatDate(viewModel.endDate)))))
      ]);
    }

    return Row(children: [
      SizedBox(width: 100, child: Text('終了日時')),
      Icon(Icons.calendar_today),
      Expanded(
          child: GestureDetector(
              onTap: () async {
                viewModel.endDate =
                    await _showDatePickerPopup(viewModel.endDate);
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                  child: Text(
                    viewModel.formatDate(viewModel.endDate),
                    textAlign: TextAlign.right,
                  )))),
      Icon(Icons.watch),
      Expanded(
          child: GestureDetector(
              onTap: () async {
                viewModel.endTime =
                    await _showDateTimePickerPopup(viewModel.endTime);
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black))),
                  child: Text(
                    viewModel.formatTime(viewModel.endTime),
                    textAlign: TextAlign.right,
                  ))))
    ]);
  }

  Widget _buildSubmitButtonSection(
      BuildContext context, RegisterFormViewModel viewModel) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('キャンセル'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('登録'),
            ),
          ],
        ));
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

  Future<TimeOfDay> _showDateTimePickerPopup(TimeOfDay initialTime) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }
}
