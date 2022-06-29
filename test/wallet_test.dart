import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:test/test.dart';
import 'package:wallet_sdk/src/di.dart';
import 'package:wallet_sdk/src/models/wallet.dart';

const walletAddress = '0xD8E4e3cAa4929487cca3622952e4CF6c37d983ce';
const transferManager = '0x123';
const communityManager = '0x256';
const phoneNumber = '+123';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  configureDependencies();
  setUp(() async {
    dio = getIt<Dio>();
    dio.options.baseUrl = 'https://studio.fuse.io/api';
    dioAdapter = DioAdapter();
    dio.httpClientAdapter = dioAdapter;
    await getIt.reset(dispose: true);
    print('reset');
  });

  test('fetch wallet', () async {
    dioAdapter.onGet(
      '/v2/wallets',
      (request) => request.reply(200, {
        "data": {
          "phoneNumber": "$phoneNumber",
          "walletAddress": "$walletAddress",
          "walletModules": {
            "CommunityManager": "$communityManager",
            "TransferManager": "$transferManager"
          },
        },
      }),
    );
    final Response response = await dio.get('/v2/wallets');
    expect(
      response.data['data']['walletAddress'],
      walletAddress,
    );
    expect(
      response.data['data']['phoneNumber'],
      phoneNumber,
    );
    expect(
      response.data['data']['walletModules']['TransferManager'],
      transferManager,
    );
    expect(
      response.data['data']['walletModules']['CommunityManager'],
      communityManager,
    );
  });

  test('fetch wallet balances', () async {
    WalletDetails walletDetails = new WalletDetails(
      walletAddress,
      phoneNumber,
      new WalletModules(
        transferManager,
        communityManager,
      ),
    );
    Wallet wallet = new Wallet.fromWalletDetails(
      walletDetails,
    );
    var tokenBalances = await wallet.fetchTokenBalances();
    print(tokenBalances);
  }, skip: true);
}
