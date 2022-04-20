import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_repository/font_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/font_picker_cubit.dart';
import 'package:wand_api/wand_api.dart';

class MockFontRepository extends Mock implements FontRepository {}

void main() {
  late FontRepository fontRepository;
  setUp(() {
    fontRepository = MockFontRepository();
  });
  group('FontPickerCubit', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => FontPickerCubit(fontRepository: fontRepository),
      expect: () => [],
    );

    group('pick', () {
      blocTest(
        'emits [inProgress, failure] and pickFont throws exception',
        build: () => FontPickerCubit(fontRepository: fontRepository),
        act: (FontPickerCubit bloc) => bloc.pick(),
        setUp: () {
          when(() => fontRepository.pickFont()).thenThrow(Exception());
        },
        verify: (bloc) {
          verify(() => fontRepository.pickFont()).called(1);
        },
        expect: () => const [
          FontPickerState(status: NetworkStatus.inProgress),
          FontPickerState(status: NetworkStatus.failure),
        ],
      );
      blocTest(
        'emits [inProgress, Success] and call pickFont',
        build: () => FontPickerCubit(fontRepository: fontRepository),
        act: (FontPickerCubit bloc) => bloc.pick(),
        setUp: () {
          when(() => fontRepository.pickFont()).thenAnswer((_) async => '');
        },
        verify: (bloc) {
          verify(() => fontRepository.pickFont()).called(1);
        },
        expect: () => const [
          FontPickerState(status: NetworkStatus.inProgress),
          FontPickerState(status: NetworkStatus.success),
        ],
      );
    });
  });
}
