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
}

class FontPickerCubit extends Cubit<FontPickerState> {
  FontPickerCubit({required this.fontRepository})
      : super(const FontPickerState());

  final FontRepository fontRepository;

  Future<String> pick() {
    return fontRepository.pickFont();
  }
}
