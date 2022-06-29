// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:web3dart/web3dart.dart' as _i7;

import 'dio.dart' as _i9;
import 'transports/api/backend_wallet_api.dart' as _i8;
import 'transports/api/explorer_api.dart' as _i4;
import 'transports/api/web.dart' as _i10;
import 'transports/token.dart' as _i5;
import 'transports/wallet.dart' as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final dioDi = _$DioDi();
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => dioDi.dio);
  gh.factoryParam<_i4.ExplorerApi, String?, String?>(
      (base, apiKey) => _i4.ExplorerApi(get<_i3.Dio>(), base, apiKey));
  gh.factory<String>(() => registerModule.rpcUrl, instanceName: 'RpcUrl');
  gh.lazySingleton<_i5.TokenTransport>(() => _i5.Web3TokenTransport());
  gh.factory<_i6.WalletTransport>(() => _i6.ApiWalletTransport());
  gh.lazySingleton<_i7.Web3Client>(
      () => registerModule.web3Client(get<String>(instanceName: 'RpcUrl')));
  gh.factoryParam<_i8.BackendWalletApi, String?, dynamic>(
      (baseUrl, _) => _i8.BackendWalletApi(get<_i3.Dio>(), baseUrl));
  return get;
}

class _$DioDi extends _i9.DioDi {}

class _$RegisterModule extends _i10.RegisterModule {}
