library time_spinner_picker_plus;

////////////////////////////////////////////////
///      Created by:  vuldk@bytesoft.net     ///
///      Company: BYTESOFT                   ///
///      Time: 13/12/2023                    ///
////////////////////////////////////////////////

import 'package:flutter/material.dart';

class TimeSpinnerPickerPlus extends StatefulWidget {
  const TimeSpinnerPickerPlus({
    super.key,
    this.height = 100,
    this.fontSize = 16,
    this.minutesInterval = 1,
    this.is24h = true,
    this.selectedColor = Colors.black,
    this.unSelectedColor = Colors.grey,
    this.initialTime,
    required this.onTimeChange,
  });

  final double height;
  final double fontSize;
  final int minutesInterval;
  final bool is24h;
  final Color selectedColor;
  final Color unSelectedColor;
  final DateTime? initialTime;
  final Function(DateTime) onTimeChange;

  @override
  State<TimeSpinnerPickerPlus> createState() =>
      _TimeSpinnerPickerPlusState();
}

class _TimeSpinnerPickerPlusState extends State<TimeSpinnerPickerPlus> {
  late int selectedHourItem;

  late int selectedMinutesItem;

  late FixedExtentScrollController fscHour;
  late FixedExtentScrollController fscMinutes;

  @override
  void initState() {
    _initSelectedTime();
    super.initState();
  }

  int _getMinutesInterval() {
    if (widget.minutesInterval > 30) return 30;
    return widget.minutesInterval;
  }

  _initSelectedTime() {
    if (widget.initialTime == null) {
      final time = DateTime.now();
      selectedHourItem = time.hour;
      selectedMinutesItem = (time.minute / _getMinutesInterval()).round();
    } else {
      selectedHourItem = widget.initialTime!.hour;
      selectedMinutesItem =
          (widget.initialTime!.minute / _getMinutesInterval()).round();
    }
    fscHour = FixedExtentScrollController(initialItem: selectedHourItem);
    fscMinutes = FixedExtentScrollController(initialItem: selectedMinutesItem);
  }

  void _onTimeChange() {
    final now = DateTime.now();
    DateTime result = DateTime(now.year, now.month, now.day, selectedHourItem,
        selectedMinutesItem * widget.minutesInterval);
    widget.onTimeChange.call(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width / 3),
      width: MediaQuery.sizeOf(context).width,
      height: widget.height,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: spin(
                  size: 24,
                  fsc: fscHour,
                  selectedItem: selectedHourItem,
                  interval: 1,
                  indexChange: (index) {
                    setState(() {
                      selectedHourItem = index;
                      _onTimeChange();
                    });
                  })),
          Flexible(
              flex: 1,
              child: spin(
                  size: (60 / _getMinutesInterval()).round(),
                  fsc: fscMinutes,
                  selectedItem: selectedMinutesItem,
                  interval: _getMinutesInterval(),
                  indexChange: (index) {
                    setState(() {
                      selectedMinutesItem = index;
                      _onTimeChange();
                    });
                  })),
        ],
      ),
    );
  }

  Widget spin({
    required int size,
    required FixedExtentScrollController fsc,
    required int selectedItem,
    required Function(int) indexChange,
    required int interval,
  }) {
    return SizedBox(
      height: widget.height,
      child: ListWheelScrollView.useDelegate(
        onSelectedItemChanged: (index) {
          indexChange.call(index);
        },
        itemExtent: widget.height / 3,
        controller: fsc,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildLoopingListDelegate(
            children: List.generate(size, (index) {
              return Container(
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(vertical: 0),
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.center,
                  '${index * interval}',
                  style: selectedItem == index
                      ? TextStyle(
                    color: widget.selectedColor,
                    fontSize: widget.fontSize,
                    decoration: TextDecoration.none,
                  )
                      : TextStyle(
                    color: widget.unSelectedColor,
                    fontSize: widget.fontSize,
                    decoration: TextDecoration.none,
                  ),
                ),
              );
            })),
      ),
    );
  }
}
