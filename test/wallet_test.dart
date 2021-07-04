
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:wallet_sdk/src/config.dart';
import 'package:wallet_sdk/src/models/wallet.dart';
import 'wallet_test.mocks.dart';

const walletAddress = '0xD8E4e3cAa4929487cca3622952e4CF6c37d983ce';
const transferManager = '0x123';
const communityManager = '0x256';
const phoneNumber = '+123';
@GenerateMocks([Client])
void main() {

  setUp(() async {
    print('reset');
    await GetIt.I.reset(dispose: true);
  });

  test('fetch wallet', () async {
    var mockClient = new MockClient();
    setup(createClient: () => mockClient);
    var response = Response('{"data": {"phoneNumber": "$phoneNumber","walletAddress": "$walletAddress", "walletModules": {"CommunityManager": "$communityManager", "TransferManager": "$transferManager"}}}', 200);
    var _jwtToken = '';
    when(mockClient.get(Uri.parse('https://studio.fuse.io/api/v2/wallets'), headers: {"Authorization": "Bearer $_jwtToken"})).thenAnswer((_) async => response);
    WalletDetails walletDetails = await Wallet.fetchWallet(walletAddress);
    expect(walletDetails.walletAddress , walletAddress);
    expect(walletDetails.phoneNumnber, phoneNumber);
    expect(walletDetails.walletModules.transferManager, transferManager);
    expect(walletDetails.walletModules.communityManager, communityManager);
  });


  test('fetch wallet balances', () async {
    setup(createClient: () => Client());
    var walletDetails = new WalletDetails(walletAddress, phoneNumber, new WalletModules(transferManager, communityManager));
    Wallet wallet = new Wallet.fromWalletDetails(walletDetails);
    var tokenBalances = await wallet.fetchTokenBalances();
    print(tokenBalances);
  }, skip: true);
}
