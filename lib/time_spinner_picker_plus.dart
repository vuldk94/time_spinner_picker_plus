////////////////////////////////////////////////
///      Created by:  vuldk@bytesoft.net     ///
///      Company: BYTESOFT                   ///
///      Time: 13/12/2023                    ///
////////////////////////////////////////////////

library time_spinner_picker_plus;

import 'package:flutter/material.dart';

class TimeSpinnerPickerPlus extends StatefulWidget {
  const TimeSpinnerPickerPlus({
    super.key,
    this.height = 100,
    this.fontSize = 16,
    this.minutesInterval = 1,
    this.secondsInterval = 1,
    this.is24h = true,
    this.isShowSeconds = false,
    this.selectedColor = Colors.black,
    this.unSelectedColor = Colors.grey,
    this.initialTime,
    required this.onTimeChange,
  });

  final double height;
  final double fontSize;
  final int minutesInterval;
  final int secondsInterval;
  final bool is24h;
  final bool isShowSeconds;
  final Color selectedColor;
  final Color unSelectedColor;
  final DateTime? initialTime;
  final Function(DateTime) onTimeChange;

  @override
  State<TimeSpinnerPickerPlus> createState() => _TimeSpinnerPickerPlusState();
}

class _TimeSpinnerPickerPlusState extends State<TimeSpinnerPickerPlus> {
  late int selectedHourItem;
  late int selectedMinutesItem;
  late int selectedSecondsItem;
  late int selectedTypeItem;

  late FixedExtentScrollController fscHour, fscMinutes, fscSeconds, fscType;

  @override
  void initState() {
    _initSelectedTime();
    super.initState();
  }

  int _getMinutesInterval() {
    if (widget.minutesInterval > 30) return 30;
    return widget.minutesInterval;
  }

  int _getSecondsInterval() {
    if (widget.secondsInterval > 30) return 30;
    return widget.secondsInterval;
  }

  _initSelectedTime() {
    if (widget.initialTime == null) {
      final time = DateTime.now();
      selectedHourItem =
      (!widget.is24h && time.hour > 12) ? time.hour - 13 : time.hour;
      selectedMinutesItem = (time.minute / _getMinutesInterval()).round();
      selectedSecondsItem = (time.second / _getSecondsInterval()).round();
      if (time.hour >= 12) {
        selectedTypeItem = 1;
      } else {
        selectedTypeItem = 0;
      }
    } else {
      selectedHourItem = (!widget.is24h && widget.initialTime!.hour > 12)
          ? widget.initialTime!.hour - 13
          : widget.initialTime!.hour;
      selectedMinutesItem =
          (widget.initialTime!.minute / _getMinutesInterval()).round();
      selectedSecondsItem =
          (widget.initialTime!.second / _getSecondsInterval()).round();
      if (widget.initialTime!.hour >= 12) {
        selectedTypeItem = 1;
      } else {
        selectedTypeItem = 0;
      }
    }
    fscHour = FixedExtentScrollController(initialItem: selectedHourItem);
    fscMinutes = FixedExtentScrollController(initialItem: selectedMinutesItem);
    fscSeconds = FixedExtentScrollController(initialItem: selectedSecondsItem);
    fscType = FixedExtentScrollController(
      initialItem: selectedTypeItem,
    );
  }

  void _onTimeChange() {
    final now = DateTime.now();
    DateTime result = DateTime(
      now.year,
      now.month,
      now.day,
      selectedHourItem,
      selectedMinutesItem * widget.minutesInterval,
      selectedSecondsItem * widget.secondsInterval,
    );
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
                  isHour: true,
                  size: widget.is24h ? 24 : 12,
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
          if (widget.isShowSeconds)
            Flexible(
                flex: 1,
                child: spin(
                    size: (60 / _getSecondsInterval()).round(),
                    fsc: fscSeconds,
                    selectedItem: selectedSecondsItem,
                    interval: 1,
                    indexChange: (index) {
                      setState(() {
                        selectedSecondsItem = index;
                        _onTimeChange();
                      });
                    })),
          if (!widget.is24h)
            Flexible(
                flex: 1,
                child: spin(
                    size: 2,
                    isType: true,
                    fsc: fscType,
                    selectedItem: selectedTypeItem,
                    interval: 1,
                    indexChange: (index) {
                      setState(() {
                        selectedTypeItem = index;
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
    bool isHour = false,
    bool isType = false,
  }) {
    return SizedBox(
      height: widget.height,
      child: !isType
          ? ListWheelScrollView.useDelegate(
        onSelectedItemChanged: (index) {
          indexChange.call(index);
        },
        scrollBehavior: const ScrollBehavior(),
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
                  '${isType ? (index == 0 ? 'AM' : 'PM') : ((isHour && size == 12) ? (index + 1) : index * interval)}',
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
      )
          : ListWheelScrollView(
        onSelectedItemChanged: (index) {
          indexChange.call(index);
        },
        itemExtent: widget.height / 3,
        children: List.generate(size, (index) {
          return Container(
            color: Colors.transparent,
            margin: const EdgeInsets.symmetric(vertical: 0),
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.center,
              '${isType ? (index == 0 ? 'AM' : 'PM') : ((isHour && size == 12) ? (index + 1) : index * interval)}',
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
        }),
      ),
    );
  }
}
