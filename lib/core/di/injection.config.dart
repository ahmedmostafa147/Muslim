// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/date/presentation/cubit/date_cubit.dart' as _i756;
import '../../features/location/data/repositories/location_repository_impl.dart'
    as _i115;
import '../../features/location/domain/repositories/location_repository.dart'
    as _i332;
import '../../features/location/presentation/cubit/location_cubit.dart'
    as _i181;
import '../../features/notification/presentation/cubit/notification_cubit.dart'
    as _i369;
import '../../features/prayer_times/data/repositories/prayer_times_repository_impl.dart'
    as _i78;
import '../../features/prayer_times/domain/repositories/prayer_times_repository.dart'
    as _i447;
import '../../features/prayer_times/presentation/cubit/prayer_times_cubit.dart'
    as _i1041;
import '../../features/quran/presentation/cubit/last_read_cubit.dart' as _i1008;
import '../../features/quran/presentation/cubit/surah_cubit.dart' as _i203;
import '../../features/quran/presentation/presentation/cubit/bookmark_cubit.dart'
    as _i584;
import '../../features/quran/presentation/presentation/cubit/favorite_cubit.dart'
    as _i494;
import '../../features/quran/presentation/presentation/cubit/quran_audio_cubit.dart'
    as _i152;
import '../../features/quran/presentation/presentation/cubit/reciters_cubit.dart'
    as _i176;
import '../../features/quran/presentation/presentation/cubit/tafseer_cubit.dart'
    as _i835;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i756.DateCubit>(() => _i756.DateCubit());
    gh.factory<_i1008.LastReadCubit>(() => _i1008.LastReadCubit());
    gh.factory<_i203.SurahCubit>(() => _i203.SurahCubit());
    gh.factory<_i584.BookmarkCubit>(() => _i584.BookmarkCubit());
    gh.factory<_i494.FavoriteCubit>(() => _i494.FavoriteCubit());
    gh.factory<_i152.QuranAudioCubit>(() => _i152.QuranAudioCubit());
    gh.factory<_i835.TafseerCubit>(() => _i835.TafseerCubit());
    gh.factory<_i369.NotificationCubit>(
        () => _i369.NotificationCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i176.RecitersCubit>(
        () => _i176.RecitersCubit(gh<_i460.SharedPreferences>()));
    gh.factory<_i332.LocationRepository>(
        () => _i115.LocationRepositoryImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i447.PrayerTimesRepository>(
        () => _i78.PrayerTimesRepositoryImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i181.LocationCubit>(
        () => _i181.LocationCubit(gh<_i332.LocationRepository>()));
    gh.factory<_i1041.PrayerTimesCubit>(() => _i1041.PrayerTimesCubit(
          gh<_i447.PrayerTimesRepository>(),
          gh<_i181.LocationCubit>(),
          gh<_i369.NotificationCubit>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
