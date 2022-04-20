import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:srt_repository/srt_repository.dart';
import 'package:subtitle_wand/pages/app_page/pages/home_page/bloc/subtitle_picker_cubit.dart';
import 'package:wand_api/wand_api.dart';

class MockSrtRepository extends Mock implements SrtRepository {}

void main() {
  late SrtRepository srtRepository;
  setUp(() {
    srtRepository = MockSrtRepository();
  });
  group('SubtitlePickerCubit', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => SubtitlePickerCubit(srtRepository: srtRepository),
      expect: () => [],
    );

    group('pickSrt', () {
      blocTest(
        'emits [inProgress, failure] and pickFont throws exception',
        build: () => SubtitlePickerCubit(srtRepository: srtRepository),
        act: (SubtitlePickerCubit bloc) => bloc.pick(),
        setUp: () {
          when(() => srtRepository.pickSrt()).thenThrow(Exception());
        },
        verify: (bloc) {
          verify(() => srtRepository.pickSrt()).called(1);
        },
        expect: () => const [
          SubtitlePickerState(status: NetworkStatus.inProgress),
          SubtitlePickerState(status: NetworkStatus.failure),
        ],
      );
      blocTest(
        'emits [inProgress, Success] and call pickFont',
        build: () => SubtitlePickerCubit(srtRepository: srtRepository),
        act: (SubtitlePickerCubit bloc) => bloc.pick(),
        setUp: () {
          when(() => srtRepository.pickSrt()).thenAnswer((_) async => []);
        },
        verify: (bloc) {
          verify(() => srtRepository.pickSrt()).called(1);
        },
        expect: () => const [
          SubtitlePickerState(status: NetworkStatus.inProgress),
          SubtitlePickerState(status: NetworkStatus.success),
        ],
      );
    });
  });
}
