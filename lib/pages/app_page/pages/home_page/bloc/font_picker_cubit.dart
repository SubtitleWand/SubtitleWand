import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:font_repository/font_repository.dart';
import 'package:wand_api/wand_api.dart';

class FontPickerState extends Equatable {
  final NetworkStatus status;
  const FontPickerState({
    this.status = NetworkStatus.uninit,
  });

  @override
  List<Object> get props => [status];

  FontPickerState copyWith({
    NetworkStatus? status,
  }) {
    return FontPickerState(
      status: status ?? this.status,
    );
  }
}

class FontPickerCubit extends Cubit<FontPickerState> {
  FontPickerCubit({required this.fontRepository})
      : super(const FontPickerState());

  final FontRepository fontRepository;

  Future<String> pick() async {
    emit(state.copyWith(status: NetworkStatus.inProgress));
    try {
      final pick = await fontRepository.pickFont();
      emit(state.copyWith(status: NetworkStatus.success));
      return pick;
    } catch (_) {
      emit(state.copyWith(status: NetworkStatus.failure));
      return '';
    }
  }
}
