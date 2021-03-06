import 'package:flutter_datetime_picker/src/date_format.dart';
import 'package:flutter_datetime_picker/src/i18n_model.dart';

abstract class BasePickerModel {
  String leftStringAtIndex(int index);
  String middleStringAtIndex(int index);
  String rightStringAtIndex(int index);
  void setLeftIndex(int index);
  void setMiddleIndex(int index);
  void setRightIndex(int index);
  int currentLeftIndex();
  int currentMiddleIndex();
  int currentRightIndex();
  DateTime finalTime();
  String leftDivider();
  String rightDivider();
  List<int> layoutProportions();
}

class CommonPickerModel extends BasePickerModel {
  List<String> leftList;
  List<String> middleList;
  List<String> rightList;
  DateTime currentTime;
  int _currentLeftIndex;
  int _currentMiddleIndex;
  int _currentRightIndex;

  LocaleType locale;
  CommonPickerModel({this.currentTime, locale}) : this.locale = locale ?? LocaleType.en;

  @override
  String leftStringAtIndex(int index) {
    return null;
  }

  @override
  String middleStringAtIndex(int index) {
    return null;
  }

  @override
  String rightStringAtIndex(int index) {
    return null;
  }

  @override
  int currentLeftIndex() {
    return _currentLeftIndex;
  }

  @override
  int currentMiddleIndex() {
    return _currentMiddleIndex;
  }

  @override
  int currentRightIndex() {
    return _currentRightIndex;
  }

  @override
  void setLeftIndex(int index) {
    _currentLeftIndex = index;
  }

  @override
  void setMiddleIndex(int index) {
    _currentMiddleIndex = index;
  }

  @override
  void setRightIndex(int index) {
    _currentRightIndex = index;
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }

  @override
  DateTime finalTime() {
    return null;
  }
}

class DatePickerModel extends CommonPickerModel {
  int maxYear;
  int minYear;

  List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];
  int _calcDateCount(int year, int month) {
    if (_leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  DatePickerModel(
      {this.maxYear = 2050, this.minYear = 1970, DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    if (currentTime != null) {
      int year = currentTime.year;
      if (this.maxYear < year) {
        currentTime = DateTime(this.maxYear, 12, 31);
      } else if (this.minYear > year) {
        currentTime = DateTime(this.minYear, 1, 1);
      }
    }
    this.currentTime = currentTime ?? DateTime.now();
    _currentLeftIndex = this.currentTime.year - minYear;
    _currentMiddleIndex = this.currentTime.month - 1;
    _currentRightIndex = this.currentTime.day - 1;

    fillLeftLists();
    fillMiddleLists();
    fillRightLists();
  }

  void fillLeftLists() {
    this.leftList = List.generate(maxYear - minYear + 1, (int index) {
      return '${minYear + index}${_localeYear()}';
    });
  }

  void fillMiddleLists() {
    this.middleList = List.generate(12, (int index) {
      return '${index + 1}${_localeMonth()}';
    });
  }

  void fillRightLists() {
    this.rightList = List.generate(
        _calcDateCount(_currentLeftIndex + minYear, _currentMiddleIndex + 1), (int index) {
      return '${index + 1}${_localeDay()}';
    });
  }

  @override
  void setLeftIndex(int index) {
    // TODO: implement setLeftIndex
    super.setLeftIndex(index);
  }

  @override
  void setMiddleIndex(int index) {
    _currentMiddleIndex = index;
    fillRightLists();
    final dayCount = _calcDateCount(_currentLeftIndex + minYear, _currentMiddleIndex + 1);
    if (_currentRightIndex >= dayCount) {
      _currentRightIndex = dayCount;
    }
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeYear() {
    if (locale == LocaleType.zh) {
      return '年';
    } else {
      return '';
    }
  }

  String _localeMonth() {
    if (locale == LocaleType.zh) {
      return '月';
    } else {
      return '';
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh) {
      return '日';
    } else {
      return '';
    }
  }

  @override
  DateTime finalTime() {
    final year = _currentLeftIndex + minYear;
    final month = _currentMiddleIndex + 1;
    final day = _currentRightIndex + 1;
    return DateTime(year, month, day);
  }
}

class TimePickerModel extends CommonPickerModel {
  TimePickerModel({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    _currentLeftIndex = this.currentTime.hour;
    _currentMiddleIndex = this.currentTime.minute;
    _currentRightIndex = this.currentTime.second;
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  DateTime finalTime() {
    return DateTime(currentTime.year, currentTime.month, currentTime.day, _currentLeftIndex,
        _currentMiddleIndex, _currentRightIndex);
  }
}

class DateTimePickerModel extends CommonPickerModel {
  DateTimePickerModel({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    _currentLeftIndex = 0;
    _currentMiddleIndex = this.currentTime.hour;
    _currentRightIndex = this.currentTime.minute;
  }

  @override
  String leftStringAtIndex(int index) {
    DateTime time = currentTime.add(Duration(days: index));
    return formatDate(time, [ymdw], locale);
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    DateTime time = currentTime.add(Duration(days: _currentLeftIndex));
    return DateTime(time.year, time.month, time.day, _currentMiddleIndex, _currentRightIndex);
  }

  @override
  List<int> layoutProportions() {
    return [4, 1, 1];
  }

  @override
  String rightDivider() {
    return ':';
  }
}
