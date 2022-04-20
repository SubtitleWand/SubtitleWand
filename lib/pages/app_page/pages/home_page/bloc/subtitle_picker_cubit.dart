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

  SubtitlePickerState copyWith({
    NetworkStatus? status,
  }) {
    return SubtitlePickerState(
      status: status ?? this.status,
    );
  }
}

class SubtitlePickerCubit extends Cubit<SubtitlePickerState> {
  SubtitlePickerCubit({required this.srtRepository})
      : super(const SubtitlePickerState());

  final SrtRepository srtRepository;

  Future<List<TimeText>> pick() async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final result = await srtRepository.pickSrt();
      emit(state.copyWith(status: NetworkStatus.success));
      return result;
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
      return [];
    }
  }
}
