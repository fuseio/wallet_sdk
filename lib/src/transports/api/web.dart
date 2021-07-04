import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:web3dart/web3dart.dart';

@module
abstract class RegisterModule {
  // You can register named preemptive types like follows
  @Named("RpcUrl")
  String get rpcUrl => 'https://rpc.fuse.io';

  // url here will be injected
  @lazySingleton
  Web3Client web3Client(@Named('RpcUrl') String rpcUrl) => Web3Client(
        rpcUrl,
        new Client(),
      );

  // @singleton
  // Web3Client get web3Client => Web3Client(
  //       RPC_URL,
  //       new Client(),
  //     );
}
