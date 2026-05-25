import 'package:equran_app/core/error/failure.dart';
import 'package:equran_app/features/imsakiyah/data/datasources/imsakiyah_local_data_source.dart';
import 'package:equran_app/features/imsakiyah/domain/entities/imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_imsakiyah.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_kabkota.dart';
import 'package:equran_app/features/imsakiyah/domain/usecases/get_provinsi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'imsakiyah_cubit.freezed.dart';
part 'imsakiyah_state.dart';

@injectable
class ImsakiyahCubit extends Cubit<ImsakiyahState> {
  ImsakiyahCubit(
    this._getProvinsi,
    this._getKabkota,
    this._getImsakiyah,
    this._local,
  ) : super(const ImsakiyahState.initial());

  final GetProvinsi _getProvinsi;
  final GetKabkota _getKabkota;
  final GetImsakiyah _getImsakiyah;
  final ImsakiyahLocalDataSource _local;

  /// Load provinsi list + restore last location jika ada
  Future<void> init() async {
    emit(const ImsakiyahState.loadingProvinsi());

    final result = await _getProvinsi();
    await result.fold(
      (failure) async => emit(ImsakiyahState.failure(failure: failure)),
      (provinsi) async {
        // Coba restore lokasi terakhir
        final lastProvinsi = await _local.getLastProvinsi();
        final lastKabkota = await _local.getLastKabkota();

        if (lastProvinsi != null &&
            provinsi.contains(lastProvinsi) &&
            lastKabkota != null) {
          // Load kabkota untuk provinsi terakhir
          final kabkotaResult = await _getKabkota(lastProvinsi);
          await kabkotaResult.fold(
            (failure) async => emit(
              ImsakiyahState.provinsiLoaded(provinsi: provinsi),
            ),
            (kabkota) async {
              if (kabkota.contains(lastKabkota)) {
                // Auto-load jadwal
                emit(
                  ImsakiyahState.loadingJadwal(
                    provinsi: provinsi,
                    selectedProvinsi: lastProvinsi,
                    kabkota: kabkota,
                    selectedKabkota: lastKabkota,
                  ),
                );
                final jadwalResult = await _getImsakiyah(
                  provinsi: lastProvinsi,
                  kabkota: lastKabkota,
                );
                jadwalResult.fold(
                  (failure) => emit(
                    ImsakiyahState.failure(
                      failure: failure,
                      provinsi: provinsi,
                      selectedProvinsi: lastProvinsi,
                      kabkota: kabkota,
                      selectedKabkota: lastKabkota,
                    ),
                  ),
                  (jadwal) => emit(
                    ImsakiyahState.success(
                      provinsi: provinsi,
                      selectedProvinsi: lastProvinsi,
                      kabkota: kabkota,
                      selectedKabkota: lastKabkota,
                      jadwal: jadwal,
                    ),
                  ),
                );
              } else {
                emit(ImsakiyahState.provinsiLoaded(provinsi: provinsi));
              }
            },
          );
        } else {
          emit(ImsakiyahState.provinsiLoaded(provinsi: provinsi));
        }
      },
    );
  }

  /// User memilih provinsi → load kabkota
  Future<void> selectProvinsi(String provinsi) async {
    final currentProvinsiList = _extractProvinsiList();
    emit(
      ImsakiyahState.loadingKabkota(
        provinsi: currentProvinsiList,
        selectedProvinsi: provinsi,
      ),
    );

    final result = await _getKabkota(provinsi);
    result.fold(
      (failure) => emit(
        ImsakiyahState.failure(
          failure: failure,
          provinsi: currentProvinsiList,
          selectedProvinsi: provinsi,
        ),
      ),
      (kabkota) => emit(
        ImsakiyahState.kabkotaLoaded(
          provinsi: currentProvinsiList,
          selectedProvinsi: provinsi,
          kabkota: kabkota,
        ),
      ),
    );
  }

  /// User memilih kabkota → load jadwal
  Future<void> selectKabkota(String kabkota) async {
    final provinsiList = _extractProvinsiList();
    final selectedProvinsi = _extractSelectedProvinsi();
    final kabkotaList = _extractKabkotaList();

    if (selectedProvinsi == null) return;

    emit(
      ImsakiyahState.loadingJadwal(
        provinsi: provinsiList,
        selectedProvinsi: selectedProvinsi,
        kabkota: kabkotaList,
        selectedKabkota: kabkota,
      ),
    );

    // Simpan preferensi
    await _local.saveLastProvinsi(selectedProvinsi);
    await _local.saveLastKabkota(kabkota);

    final result = await _getImsakiyah(
      provinsi: selectedProvinsi,
      kabkota: kabkota,
    );
    result.fold(
      (failure) => emit(
        ImsakiyahState.failure(
          failure: failure,
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkotaList,
          selectedKabkota: kabkota,
        ),
      ),
      (jadwal) => emit(
        ImsakiyahState.success(
          provinsi: provinsiList,
          selectedProvinsi: selectedProvinsi,
          kabkota: kabkotaList,
          selectedKabkota: kabkota,
          jadwal: jadwal,
        ),
      ),
    );
  }

  /// Retry dari failure state
  Future<void> retry() async {
    final current = state;
    if (current is ImsakiyahFailure) {
      final provinsi = current.selectedProvinsi;
      final kabkota = current.selectedKabkota;

      if (provinsi != null && kabkota != null) {
        await selectKabkota(kabkota);
      } else if (provinsi != null) {
        await selectProvinsi(provinsi);
      } else {
        await init();
      }
    } else {
      await init();
    }
  }

  // --- helpers ---

  List<String> _extractProvinsiList() {
    final s = state;
    return switch (s) {
      ImsakiyahProvinsiLoaded() => s.provinsi,
      ImsakiyahLoadingKabkota() => s.provinsi,
      ImsakiyahKabkotaLoaded() => s.provinsi,
      ImsakiyahLoadingJadwal() => s.provinsi,
      ImsakiyahSuccess() => s.provinsi,
      ImsakiyahFailure() => s.provinsi ?? [],
      _ => [],
    };
  }

  String? _extractSelectedProvinsi() {
    final s = state;
    return switch (s) {
      ImsakiyahLoadingKabkota() => s.selectedProvinsi,
      ImsakiyahKabkotaLoaded() => s.selectedProvinsi,
      ImsakiyahLoadingJadwal() => s.selectedProvinsi,
      ImsakiyahSuccess() => s.selectedProvinsi,
      ImsakiyahFailure() => s.selectedProvinsi,
      _ => null,
    };
  }

  List<String> _extractKabkotaList() {
    final s = state;
    return switch (s) {
      ImsakiyahKabkotaLoaded() => s.kabkota,
      ImsakiyahLoadingJadwal() => s.kabkota,
      ImsakiyahSuccess() => s.kabkota,
      ImsakiyahFailure() => s.kabkota ?? [],
      _ => [],
    };
  }
}
