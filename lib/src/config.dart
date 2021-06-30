import 'package:http/http.dart';

import 'package:get_it/get_it.dart';
import 'package:web3dart/web3dart.dart';

final getIt = GetIt.instance;

const String RPC_URL = 'https://rpc.fuse.io';

void setup() {

  Web3Client webClient = new Web3Client(RPC_URL, new Client());

  getIt.registerSingleton<Web3Client>(webClient);
}