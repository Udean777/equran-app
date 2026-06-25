import 'package:equran_app/core/network/dio_client.dart';
import 'package:equran_app/core/providers.dart';
import 'package:equran_app/features/doa/data/datasources/doa_bookmark_data_source.dart';
import 'package:equran_app/features/doa/data/datasources/doa_local_data_source.dart';
import 'package:equran_app/features/doa/data/datasources/doa_remote_data_source.dart';
import 'package:equran_app/features/doa/data/repositories/doa_bookmark_repository_impl.dart';
import 'package:equran_app/features/doa/data/repositories/doa_repository_impl.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_bookmarks.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_detail.dart';
import 'package:equran_app/features/doa/domain/usecases/get_doa_list.dart';
import 'package:equran_app/features/doa/domain/usecases/toggle_doa_bookmark.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_bookmark_state.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_bookmark_viewmodel.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_detail_state.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_detail_viewmodel.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_list_state.dart';
import 'package:equran_app/features/doa/presentation/viewmodels/doa_list_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'viewmodels/doa_bookmark_state.dart';
export 'viewmodels/doa_detail_state.dart';
export 'viewmodels/doa_list_state.dart';

// --- Core wrappers ---

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

// --- Data Sources ---

final doaRemoteDataSourceProvider = Provider<DoaRemoteDataSourceImpl>((ref) {
  return DoaRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final doaLocalDataSourceProvider = Provider<DoaLocalDataSourceImpl>((ref) {
  return DoaLocalDataSourceImpl(ref.watch(doaBoxProvider).requireValue);
});

final doaBookmarkDataSourceProvider = Provider<DoaBookmarkDataSourceImpl>((
  ref,
) {
  return DoaBookmarkDataSourceImpl(
    ref.watch(doaBookmarkBoxProvider).requireValue,
  );
});

// --- Repositories ---

final doaRepositoryProvider = Provider<DoaRepositoryImpl>((ref) {
  return DoaRepositoryImpl(
    ref.read(doaRemoteDataSourceProvider),
    ref.read(doaLocalDataSourceProvider),
  );
});

final doaBookmarkRepositoryProvider = Provider<DoaBookmarkRepositoryImpl>((
  ref,
) {
  return DoaBookmarkRepositoryImpl(ref.read(doaBookmarkDataSourceProvider));
});

// --- Use Cases ---

final getDoaListProvider = Provider<GetDoaList>((ref) {
  return GetDoaList(ref.read(doaRepositoryProvider));
});

final getDoaDetailProvider = Provider<GetDoaDetail>((ref) {
  return GetDoaDetail(ref.read(doaRepositoryProvider));
});

final getDoaBookmarksProvider = Provider<GetDoaBookmarks>((ref) {
  return GetDoaBookmarks(ref.read(doaBookmarkRepositoryProvider));
});

final toggleDoaBookmarkProvider = Provider<ToggleDoaBookmark>((ref) {
  return ToggleDoaBookmark(ref.read(doaBookmarkRepositoryProvider));
});

// --- ViewModels ---

final doaListViewModelProvider =
    AutoDisposeStateNotifierProvider<DoaListViewModel, DoaListState>(
      (ref) => DoaListViewModel(ref.read(getDoaListProvider)),
    );

final doaDetailViewModelProvider =
    AutoDisposeStateNotifierProvider<DoaDetailViewModel, DoaDetailState>(
      (ref) => DoaDetailViewModel(
        ref.read(getDoaDetailProvider),
        ref.read(getDoaBookmarksProvider),
        ref.read(toggleDoaBookmarkProvider),
      ),
    );

final doaBookmarkViewModelProvider =
    StateNotifierProvider<DoaBookmarkViewModel, DoaBookmarkState>(
      (ref) => DoaBookmarkViewModel(
        ref.read(getDoaBookmarksProvider),
        ref.read(toggleDoaBookmarkProvider),
        ref.read(getDoaListProvider),
      ),
    );
