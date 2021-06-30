
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:test/test.dart';
// import 'package:wallet_sdk/src/transports/wallet.dart';

// import 'wallet_test.mocks.dart';

// const WALLET_ADDRESS = '0xD8E4e3cAa4929487cca3622952e4CF6c37d983ce';



// @GenerateMocks([ApiWalletTransport])
// void main() {

//   test('fetch wallet', () async {
//     var apiWalletTransport = new MockApiWalletTransport();
//     var walletMap = {
//       'data': {
//         'phoneNumber': '+123'
//       }
//     };
//     when(apiWalletTransport.get('v2/wallets', auth: true)).thenAnswer((_) => Future.value(walletMap));
//     // apiWalletTransport.get('v2/wallets', auth: true);
//     // verify(apiWalletTransport.get('v2/wallets', auth: true));
//     // print(apiWalletTransport.fetchWallet);
//     // WalletDetails walletDetails = await apiWalletTransport.fetchWallet(WALLET_ADDRESS);
//     expect(await apiWalletTransport.fetchWallet(WALLET_ADDRESS) , WALLET_ADDRESS);
//   });
// }
