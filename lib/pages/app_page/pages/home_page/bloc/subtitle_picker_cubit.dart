import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:srt_repository/srt_repository.dart';
import 'package:wand_api/wand_api.dart';

class SubtitlePickerState extends Equatable {
  final NetworkStatus status;
  const SubtitlePickerState({
    this.status = NetworkStatus.uninit,
  });

  @override
  List<Object> get props => [status];
}

class SubtitlePickerCubit extends Cubit<SubtitlePickerState> {
  SubtitlePickerCubit({required this.srtRepository})
      : super(const SubtitlePickerState());

  final SrtRepository srtRepository;

  Future<List<TimeText>> pick() {
    return srtRepository.pickSrt();
  }
}
