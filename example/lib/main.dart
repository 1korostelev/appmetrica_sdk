import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:appmetrica_sdk/appmetrica_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializing the AppMetrica SDK.
  await AppmetricaSdk()
      .activate(apiKey: '2ccabe3e-cfc5-46f3-84f0-0b9e4f8445e6');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _libraryVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initLibrarayVersionState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initLibrarayVersionState() async {
    String? libraryVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      libraryVersion = await AppmetricaSdk().getLibraryVersion();
    } on PlatformException {
      libraryVersion = 'Failed to get library version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _libraryVersion = libraryVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                          'AppMetrica SDK Library version: $_libraryVersion\n'),
                    ),
                    RaisedButton(
                      child: const Text('Send a custom event'),
                      onPressed: () {
                        /// Sending a custom event without nested parameters.
                        AppmetricaSdk().reportEvent(name: 'Updates installed');
                      },
                    ),
                    RaisedButton(
                      child: const Text(
                          'Send a custom event with nested parameters'),
                      onPressed: () {
                        /// Sending a custom event with nested parameters.
                        AppmetricaSdk().reportEvent(
                            name: 'Current app statistics',
                            attributes: <String, dynamic>{
                              'Application': 'com.company.myapp.awesomeapp',
                              'Audience': 1000000000,
                              'Product price in €': 10000000.99,
                              'nested map': <String, dynamic>{
                                'strategies': 'Age of Empires',
                              },
                            });
                      },
                    ),
                    RaisedButton(
                      child: const Text('Send user profile attributes'),
                      onPressed: () {
                        /// Sending profile custom string attribute.
                        AppmetricaSdk().reportUserProfileCustomString(
                            key: 'string_attribute', value: 'string');

                        /// Sending profile custom number attribute.
                        AppmetricaSdk().reportUserProfileCustomNumber(
                            key: 'number_attribute', value: 55);

                        /// Sending profile custom boolean attribute.
                        AppmetricaSdk().reportUserProfileCustomBoolean(
                            key: 'boolean_attribute', value: true);

                        /// Sending profile custom attribute of the counter type.
                        AppmetricaSdk().reportUserProfileCustomCounter(
                            key: 'counter_attribute', delta: 1);

                        /// Sets the ID of the user profile. Required for predefined
                        /// profile attributes like Name or Notifications enabled.
                        AppmetricaSdk().setUserProfileID(userProfileID: 'id');

                        /// Sending profile predefined user name attribute.
                        AppmetricaSdk()
                            .reportUserProfileUserName(userName: 'John');

                        /// Sending profile predefined NotificationsEnabled attribute.
                        AppmetricaSdk().reportUserProfileNotificationsEnabled(
                            notificationsEnabled: true);
                      },
                    ),
                    RaisedButton(
                      child:
                          const Text('Send referral URL for this installation'),
                      onPressed: () {
                        /// Sets referral URL for this installation. This might
                        /// be required to track some specific traffic
                        /// sources like Facebook.
                        AppmetricaSdk().reportReferralUrl(
                          referral: 'fb123456789://example.com/test',
                        );
                      },
                    ),
                    RaisedButton(
                      child: const Text('Send ecommerce event'),
                      onPressed: () {
                        AppmetricaSdk().reportShowProductDetailsEvent(
                          attributes: ProductAttributes(
                            price: 100.50,
                            product: 'Super Tasty Cake',
                            productCode: 'cake-spr-tsts',
                            category: 'cakes',
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: const Text('Send add to cart event'),
                      onPressed: () {
                        AppmetricaSdk().reportAddToCartEvent(
                          attributes: ProductAttributes(
                            price: 100,
                            product: 'Super Tasty Cake',
                            productCode: 'cake-spr-tsts',
                            category: 'cakes',
                            quantity: 10,
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: const Text('Send remove from cart event'),
                      onPressed: () {
                        AppmetricaSdk().reportAddToCartEvent(
                          attributes: ProductAttributes(
                            price: 100,
                            product: 'Super Tasty Cake',
                            productCode: 'cake-spr-tsts',
                            category: 'cakes',
                            quantity: 5,
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: const Text('Send begin checkout event'),
                      onPressed: () {
                        AppmetricaSdk().reportBeginCheckoutEvent(
                          attributes: CartAttributes(
                            cartId: '123',
                            cartItems: [
                              ProductAttributes(
                                price: 250,
                                product: 'Super Tasty Cake',
                                productCode: 'cake-spr-tsts',
                                category: 'cakes',
                                quantity: 2,
                              ),
                              ProductAttributes(
                                price: 150,
                                product: 'Milk',
                                productCode: 'milk-0.5',
                                category: 'milk',
                                quantity: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    RaisedButton(
                      child: const Text('Send purchase event'),
                      onPressed: () {
                        AppmetricaSdk().reportPurchaseEvent(
                          attributes: CartAttributes(
                            cartId: '123',
                            cartItems: [
                              ProductAttributes(
                                price: 250,
                                product: 'Super Tasty Cake',
                                productCode: 'cake-spr-tsts',
                                category: 'cakes',
                                quantity: 2,
                              ),
                              ProductAttributes(
                                price: 150,
                                product: 'Milk',
                                productCode: 'milk-0.5',
                                category: 'milk',
                                quantity: 1,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )));
  }
}
