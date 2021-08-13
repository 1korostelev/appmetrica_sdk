// Copyright 2019 EM ALL iT Studio. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "AppmetricaSdkPlugin.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import <YandexMobileMetrica/YMMProfileAttribute.h>

@implementation AppmetricaSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"emallstudio.com/appmetrica_sdk"
            binaryMessenger:[registrar messenger]];
  AppmetricaSdkPlugin* instance = [[AppmetricaSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"activate" isEqualToString:call.method]) {
      [self handleActivate:call result:result];
  } else if ([@"reportEvent" isEqualToString:call.method]) {
      [self handleReportEvent:call result:result];
  } else if ([@"reportUserProfileCustomString" isEqualToString:call.method]) {
      [self handleReportUserProfileCustomString:call result:result];
  } else if ([@"reportUserProfileCustomNumber" isEqualToString:call.method]) {
      [self handleReportUserProfileCustomNumber:call result:result];
  } else if ([@"reportUserProfileCustomBoolean" isEqualToString:call.method]) {
      [self handleReportUserProfileCustomBoolean:call result:result];
  } else if ([@"reportUserProfileCustomCounter" isEqualToString:call.method]) {
      [self handleReportUserProfileCustomCounter:call result:result];
  } else if ([@"reportUserProfileUserName" isEqualToString:call.method]) {
      [self handleReportUserProfileUserName:call result:result];
  } else if ([@"reportUserProfileNotificationsEnabled" isEqualToString:call.method]) {
      [self handleReportUserProfileNotificationsEnabled:call result:result];
  } else if ([@"setStatisticsSending" isEqualToString:call.method]) {
      [self handleSetStatisticsSending:call result:result];
  } else if ([@"getLibraryVersion" isEqualToString:call.method]) {
      [self handleGetLibraryVersion:call result:result];
  } else if ([@"setUserProfileID" isEqualToString:call.method]) {
      [self handleSetUserProfileID:call result:result];
  } else if ([@"sendEventsBuffer" isEqualToString:call.method]) {
      [self handleSendEventsBuffer:call result:result];
  } else if ([@"reportReferralUrl" isEqualToString:call.method]) {
      [self handleReportReferralUrl:call result:result];
  } else if ([@"reportShowProductDetailsEvent" isEqualToString:call.method]) {
      [self handleReportShowProductDetailsEvent:call result:result];
  } else if ([@"reportAddToCartEvent" isEqualToString:call.method]) {
      [self handleReportAddToCartEvent:call result:result];
  } else if ([@"reportRemoveFromCartEvent" isEqualToString:call.method]) {
      [self handleReportRemoveFromCartEvent:call result:result];
  } else if ([@"reportBeginCheckoutEvent" isEqualToString:call.method]) {
      [self handleReportBeginCheckoutEvent:call result:result];
  } else if ([@"reportPurchaseEvent" isEqualToString:call.method]) {
      [self handleReportPurchaseEvent:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

- (FlutterError* _Nullable)getFlutterError:(NSError*)error {
  if (error == nil) return nil;

  return [FlutterError errorWithCode:[NSString stringWithFormat:@"Error %ld", (long)error.code]
                             message:error.domain
                             details:error.localizedDescription];
}

- (void)handleActivate:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* apiKey = call.arguments[@"apiKey"];
    NSInteger sessionTimeout = [call.arguments[@"sessionTimeout"] integerValue];
    BOOL locationTracking = [call.arguments[@"locationTracking"] boolValue];
    BOOL statisticsSending = [call.arguments[@"statisticsSending"] boolValue];
    BOOL crashReporting = [call.arguments[@"crashReporting"] boolValue];
    NSInteger maxReportsInDatabaseCount = [call.arguments[@"maxReportsInDatabaseCount"] integerValue];
    // Creating an extended library configuration.
    YMMYandexMetricaConfiguration *configuration = [[YMMYandexMetricaConfiguration alloc] initWithApiKey:apiKey];
    // Setting up the configuration.
    configuration.logs = YES;
    configuration.sessionTimeout = sessionTimeout;
    configuration.locationTracking = locationTracking;
    configuration.statisticsSending = statisticsSending;
    configuration.crashReporting = crashReporting;
    // maxReportsInDatabaseCount is not supported yet. Android only feature.
    //configuration.maxReportsInDatabaseCount = maxReportsInDatabaseCount;
    // Initializing the AppMetrica SDK.
    [YMMYandexMetrica activateWithConfiguration:configuration];
    result(nil);
}

- (void)handleReportEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* name = call.arguments[@"name"];

    if (![call.arguments[@"attributes"] isEqual:[NSNull null]]) {
        NSDictionary* attributes = call.arguments[@"attributes"];
        [YMMYandexMetrica reportEvent:name
            parameters:attributes
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }
        ];
    } else {
        [YMMYandexMetrica reportEvent:name
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }
        ];
    }

    result(nil);
}


- (void)handleReportUserProfileCustomString:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* key = call.arguments[@"key"];

    YMMMutableUserProfile* userProfile =[ [YMMMutableUserProfile alloc] init];
    if (![call.arguments[@"value"] isEqual:[NSNull null]]) {
        NSString* value = call.arguments[@"value"];
        [userProfile apply:[[YMMProfileAttribute customString:key] withValue:value]];
    } else {
        [userProfile apply:[[YMMProfileAttribute customString:key] withValueReset]];
    }

    [YMMYandexMetrica reportUserProfile:userProfile
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }];

    result(nil);
}

- (void)handleReportUserProfileCustomNumber:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* key = call.arguments[@"key"];

    YMMMutableUserProfile* userProfile =[ [YMMMutableUserProfile alloc] init];
    if (![call.arguments[@"value"] isEqual:[NSNull null]]) {
        double value = [call.arguments[@"value"] doubleValue];
        [userProfile apply:[[YMMProfileAttribute customNumber:key] withValue:value]];
    } else {
        [userProfile apply:[[YMMProfileAttribute customNumber:key] withValueReset]];
    }

    [YMMYandexMetrica reportUserProfile:userProfile
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }];

    result(nil);
}

- (void)handleReportUserProfileCustomBoolean:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* key = call.arguments[@"key"];

    YMMMutableUserProfile* userProfile =[ [YMMMutableUserProfile alloc] init];
    if (![call.arguments[@"value"] isEqual:[NSNull null]]) {
        BOOL value = [call.arguments[@"value"] boolValue];
        [userProfile apply:[[YMMProfileAttribute customBool:key] withValue:value]];
    } else {
        [userProfile apply:[[YMMProfileAttribute customBool:key] withValueReset]];
    }

    [YMMYandexMetrica reportUserProfile:userProfile
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }];

    result(nil);
}

- (void)handleReportUserProfileCustomCounter:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* key = call.arguments[@"key"];
    double value = [call.arguments[@"delta"] doubleValue];

    YMMMutableUserProfile* userProfile =[ [YMMMutableUserProfile alloc] init];
    [userProfile apply:[[YMMProfileAttribute customCounter:key] withDelta:value]];
    [YMMYandexMetrica reportUserProfile:userProfile
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }];

    result(nil);
}

- (void)handleReportUserProfileUserName:(FlutterMethodCall*)call result:(FlutterResult)result {
    YMMMutableUserProfile* userProfile =[ [YMMMutableUserProfile alloc] init];
    if (![call.arguments[@"userName"] isEqual:[NSNull null]]) {
        NSString* userName = call.arguments[@"userName"];
        [userProfile apply:[[YMMProfileAttribute name] withValue:userName]];
    } else {
        [userProfile apply:[[YMMProfileAttribute name] withValueReset]];
    }

    [YMMYandexMetrica reportUserProfile:userProfile
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }];

    result(nil);
}

- (void)handleReportUserProfileNotificationsEnabled:(FlutterMethodCall*)call result:(FlutterResult)result {
    YMMMutableUserProfile* userProfile =[ [YMMMutableUserProfile alloc] init];
    if (![call.arguments[@"notificationsEnabled"] isEqual:[NSNull null]]) {
        BOOL notificationsEnabled = [call.arguments[@"notificationsEnabled"] boolValue];
        [userProfile apply:[[YMMProfileAttribute notificationsEnabled] withValue:notificationsEnabled]];
    } else {
        [userProfile apply:[[YMMProfileAttribute notificationsEnabled] withValueReset]];
    }

    [YMMYandexMetrica reportUserProfile:userProfile
            onFailure:^(NSError *error) {
               result([self getFlutterError:error]);
            }];

    result(nil);
}

- (void)handleSetStatisticsSending:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL statisticsSending = [call.arguments[@"statisticsSending"] boolValue];

    [YMMYandexMetrica setStatisticsSending:statisticsSending];

    result(nil);
}

- (void)handleGetLibraryVersion:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([YMMYandexMetrica libraryVersion]);
}

- (void)handleSetUserProfileID:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* userProfileID = call.arguments[@"userProfileID"];

    [YMMYandexMetrica setUserProfileID:userProfileID];

    result(nil);
}

- (void)handleSendEventsBuffer:(FlutterMethodCall*)call result:(FlutterResult)result {
    [YMMYandexMetrica sendEventsBuffer];

    result(nil);
}

- (void)handleReportReferralUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* referral = call.arguments[@"referral"];
    NSURL *url = [[NSURL alloc] initWithString:referral];
    
    [YMMYandexMetrica reportReferralUrl:url];

    result(nil);
}


- (void)handleReportShowProductDetailsEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (![call.arguments[@"attributes"] isEqual:[NSNull null]]) {
        printf("report product details");
        NSDictionary* attributes = call.arguments[@"attributes"];
        NSString* productName = attributes[@"product"];
        NSString* productCode = attributes[@"productCode"];
        double priceValue = [attributes[@"price"] doubleValue];
        YMMECommerceAmount *actualFiat =
        [[YMMECommerceAmount alloc] initWithUnit:@"RUB" value:[[NSDecimalNumber alloc] initWithDouble:priceValue]];
        YMMECommercePrice *actualPrice = [[YMMECommercePrice alloc] initWithFiat:actualFiat];
        YMMECommerceProduct *product = [[YMMECommerceProduct alloc] initWithSKU:productCode
                                                                           name:productName
                                                             categoryComponents:nil
                                                                        payload:nil
                                                                    actualPrice:actualPrice
                                                                  originalPrice:nil
                                                                     promoCodes:nil];
        [YMMYandexMetrica reportECommerce:[YMMECommerce showProductDetailsEventWithProduct:product referrer:nil] onFailure:^(NSError *error) {
            result([self getFlutterError:error]);
         }];
    }

    result(nil);
}

- (void)handleReportAddToCartEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    printf("report add to cart");
    if (![call.arguments[@"attributes"] isEqual:[NSNull null]]) {
        NSDictionary* attributes = call.arguments[@"attributes"];
        YMMECommerceCartItem *addedItems = [self createCartItem: attributes];
        [YMMYandexMetrica reportECommerce:[YMMECommerce addCartItemEventWithItem:addedItems] onFailure:^(NSError *error) {
            result([self getFlutterError:error]);
         }];
        
    }
    result(nil);
}

- (void)handleReportRemoveFromCartEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    printf("report remove from cart");
    if (![call.arguments[@"attributes"] isEqual:[NSNull null]]) {
        NSDictionary* attributes = call.arguments[@"attributes"];
        YMMECommerceCartItem *removedItems = [self createCartItem: attributes];
        
        [YMMYandexMetrica reportECommerce:[YMMECommerce removeCartItemEventWithItem:removedItems] onFailure:^(NSError *error) {
            result([self getFlutterError:error]);
         }];
        
    }
    result(nil);
}

- (void)handleReportBeginCheckoutEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    printf("report remove from cart");
    if (![call.arguments[@"cartItems"] isEqual:[NSNull null]]) {
        NSDictionary* cartItems = call.arguments[@"cartItems"];
        NSString* cartId = call.arguments[@"cartId"];
        NSLog(@"%@", cartId);
        NSMutableArray <YMMECommerceCartItem *> *cartItemsArray = [self createCartItems:cartItems];
        for (YMMECommerceCartItem* v in cartItemsArray){
            NSLog(@"cartItem added");
            NSLog(@"%@", v.product.name);
        }
        
        YMMECommerceOrder *order = [[YMMECommerceOrder alloc] initWithIdentifier:cartId
                                                                       cartItems:cartItemsArray
                                                                         payload:nil];
        
        [YMMYandexMetrica reportECommerce:[YMMECommerce beginCheckoutEventWithOrder:order] onFailure:^(NSError *error) {
            result([self getFlutterError:error]);
         }];
    }
    result(nil);
}


- (void)handleReportPurchaseEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    printf("report purchase");
    if (![call.arguments[@"cartItems"] isEqual:[NSNull null]]) {
        NSDictionary* cartItems = call.arguments[@"cartItems"];
        NSString* cartId = call.arguments[@"cartId"];
        NSLog(@"%@", cartId);
        NSMutableArray <YMMECommerceCartItem *> *cartItemsArray = [self createCartItems:cartItems];
        for (YMMECommerceCartItem* v in cartItemsArray){
            NSLog(@"cartItem added");
            NSLog(@"%@", v.product.name);
        }
        
        YMMECommerceOrder *order = [[YMMECommerceOrder alloc] initWithIdentifier:cartId
                                                                       cartItems:cartItemsArray
                                                                         payload:nil];
        
        [YMMYandexMetrica reportECommerce:[YMMECommerce purchaseEventWithOrder:order] onFailure:^(NSError *error) {
            result([self getFlutterError:error]);
         }];
    }
    result(nil);
}

- (NSMutableArray <YMMECommerceCartItem *>*)createCartItems:(NSDictionary*) items{
    NSMutableArray <YMMECommerceCartItem *> *cartProducts = [[NSMutableArray alloc] initWithCapacity:items.count];
    for (NSDictionary* item in items){
        YMMECommerceCartItem* cartItem = [self createCartItem:item[@"attributes"]];
        [cartProducts addObject:cartItem];
    }
    return cartProducts;
}

- (YMMECommerceCartItem*)createCartItem:(NSDictionary*) attributes{
    NSString* productName = attributes[@"product"];
    NSString* productCode = attributes[@"productCode"];
    double priceValue = [attributes[@"price"] doubleValue];
    int quantityValue = [attributes[@"quantity"] intValue];
    YMMECommerceAmount *actualFiat =
    [[YMMECommerceAmount alloc] initWithUnit:@"RUB" value:[[NSDecimalNumber alloc] initWithDouble:priceValue]];
    YMMECommercePrice *actualPrice = [[YMMECommercePrice alloc] initWithFiat:actualFiat];
    YMMECommerceProduct *product = [[YMMECommerceProduct alloc] initWithSKU:productCode
                                                                       name:productName
                                                         categoryComponents:nil
                                                                    payload:nil
                                                                actualPrice:actualPrice
                                                              originalPrice:nil
                                                                 promoCodes:nil];
    YMMECommerceCartItem *cartItem = [[YMMECommerceCartItem alloc] initWithProduct:product quantity:[[NSDecimalNumber alloc] initWithInt:quantityValue] revenue:actualPrice referrer:nil];
    return cartItem;
}

@end
