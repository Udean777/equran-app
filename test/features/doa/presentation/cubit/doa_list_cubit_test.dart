import 'package:bloc_test/bloc_test.dart';
import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/presentation/cubit/doa_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_data.dart';

class MockGetDoaList extends Mock implements GetDoaList {}

void main() {
  late MockGetDoaList mockGetDoaList;

  setUp(() {
    mockGetDoaList = MockGetDoaList();
  });

  group('DoaListCubit', () {
    // ── load ──────────────────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'emits [loading, success] saat load() berhasil',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const DoaListState.loading(),
        isA<DoaListSuccess>(),
      ],
    );

    blocTest<DoaListCubit, DoaListState>(
      'emits [loading, failure] saat load() network error',
      build: () {
        when(
          () => mockGetDoaList(),
        ).thenAnswer((_) async => left(const Failure.network()));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        const DoaListState.loading(),
        const DoaListState.failure(failure: Failure.network()),
      ],
    );

    blocTest<DoaListCubit, DoaListState>(
      'success state berisi grupList dan tagList yang benar',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.grupList, contains('Doa Sebelum dan Sesudah Tidur'));
        expect(state.grupList, contains('Doa di Kamar Mandi'));
        expect(state.tagList, contains('tidur'));
        expect(state.tagList, contains('malam'));
        expect(state.tagList, contains('kamar mandi'));
      },
    );

    // ── search ────────────────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'search() filter berdasarkan nama',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.search('tidur');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.filtered.length, 1);
        expect(state.filtered.first.nama, 'Doa Sebelum Tidur 1');
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'search() filter berdasarkan idn',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.search('berlindung');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.filtered.length, 1);
        expect(state.filtered.first.id, 2);
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'search() filter berdasarkan grup',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.search('kamar mandi');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.filtered.length, 1);
        expect(state.filtered.first.grup, 'Doa di Kamar Mandi');
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'search() return semua jika query kosong',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.search('');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.filtered.length, 2);
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'search() tidak emit jika state bukan success',
      build: () => DoaListCubit(mockGetDoaList),
      act: (cubit) => cubit.search('test'),
      expect: () => <DoaListState>[],
    );

    // ── filterByGrup ──────────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'filterByGrup() filter berdasarkan grup',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.filterByGrup('Doa di Kamar Mandi');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.filtered.length, 1);
        expect(state.filtered.first.grup, 'Doa di Kamar Mandi');
        expect(state.activeGrup, 'Doa di Kamar Mandi');
        expect(state.activeTag, isNull);
        expect(state.hasActiveFilter, isTrue);
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'filterByGrup() clear activeTag saat filter grup dipilih',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit
          ..filterByTag('tidur')
          ..filterByGrup('Doa di Kamar Mandi');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.activeTag, isNull);
        expect(state.activeGrup, 'Doa di Kamar Mandi');
      },
    );

    // ── filterByTag ───────────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'filterByTag() filter berdasarkan tag',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.filterByTag('tidur');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.filtered.length, 1);
        expect(state.filtered.first.tag, contains('tidur'));
        expect(state.activeTag, 'tidur');
        expect(state.activeGrup, isNull);
        expect(state.hasActiveFilter, isTrue);
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'filterByTag() clear activeGrup saat filter tag dipilih',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit
          ..filterByGrup('Doa di Kamar Mandi')
          ..filterByTag('tidur');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.activeGrup, isNull);
        expect(state.activeTag, 'tidur');
      },
    );

    // ── clearFilter ───────────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'clearFilter() reset semua filter dan query',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit
          ..filterByGrup('Doa di Kamar Mandi')
          ..clearFilter();
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.activeGrup, isNull);
        expect(state.activeTag, isNull);
        expect(state.query, '');
        expect(state.hasActiveFilter, isFalse);
        expect(state.filtered.length, 2);
      },
    );

    // ── activeFilterLabel ─────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'activeFilterLabel return nama grup jika filter by grup',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.filterByGrup('Doa di Kamar Mandi');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.activeFilterLabel, 'Doa di Kamar Mandi');
      },
    );

    blocTest<DoaListCubit, DoaListState>(
      'activeFilterLabel return #tag jika filter by tag',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.filterByTag('tidur');
      },
      verify: (cubit) {
        final state = cubit.state as DoaListSuccess;
        expect(state.activeFilterLabel, '#tidur');
      },
    );

    // ── retry ─────────────────────────────────────────────────────────────────

    blocTest<DoaListCubit, DoaListState>(
      'retry() memanggil load() ulang',
      build: () {
        when(() => mockGetDoaList()).thenAnswer((_) async => right(tDoaList));
        return DoaListCubit(mockGetDoaList);
      },
      act: (cubit) async {
        await cubit.load();
        cubit.retry();
      },
      verify: (_) {
        verify(() => mockGetDoaList()).called(2);
      },
    );
  });
}
