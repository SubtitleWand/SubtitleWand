import 'package:equatable/equatable.dart';

class TimeText extends Equatable {
  final String text;
  final DateTime startTimestamp;
  final DateTime endTimeStamp;

  const TimeText({
    required this.text,
    required this.startTimestamp,
    required this.endTimeStamp,
  });

  @override
  List<Object?> get props => [text, startTimestamp, endTimeStamp];
}
