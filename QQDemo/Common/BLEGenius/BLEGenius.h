//
// Created by fengshuai on 15/10/19.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *const PERIPHERAL_CONNECTED;
extern NSString *const PERIPHERAL_DISCONNECTED;
extern NSString *const PERIPHERAL_NAME_UPDATED;

typedef void (^BLECommonCompletionBlock)(NSError *error);
typedef void (^BLEConnectionCompletionBlock)(CBPeripheral *peripheral, NSError *error);
typedef void (^CentralManagerStateUpdateBlock)(CBCentralManagerState state);
typedef void (^RestorationHandler)(NSDictionary<NSString *, id> * dict);
typedef void (^BLEDiscoverPeripheralBlock)(CBPeripheral *peripheral, NSDictionary<NSString *, id> * advertisementData, NSNumber *RSSI);
typedef void (^BLEDiscoverServiceBlock)(NSArray<CBService *> *services,NSError *error);
typedef void (^BLEDiscoverCharacteristicBlock)(NSArray<CBCharacteristic *> *characteristics,NSError *error);
typedef void (^BLEDataTrasferBlock)(NSData *data,NSError *error); //

@interface BLEGenius : NSObject
@property(nonatomic, strong) CBCentralManager *centralManager;

@property(nonatomic,assign) CBCentralManagerState state;

+ (BLEGenius *)sharedInstance;


#pragma mark - 蓝牙中心方法

- (void)setup:(void(^)(CBCentralManagerState state))stateBlock restoreEventHandler:(void (^)(NSDictionary<NSString *, id> *state))restoreEventHandler;

- (void)scanForPeripheralsWithServices:(nullable NSArray<NSString *> *)serviceUUIDs
                               options:(nullable NSDictionary<NSString *, id> *)options
                            discoverBlock:(BLEDiscoverPeripheralBlock)discoverBlock;

- (void)stopScan;

- (void)connectPeripheral:(CBPeripheral *)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
                  complete:(void(^)(CBPeripheral *peripheral1,NSError *error))completeBlock
                  didDisconnect:(void(^)(CBPeripheral *peripheral1,NSError *error))disconnectBlock;

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

- (NSArray<CBPeripheral *> *)retrievePeripheralsWithIdentifiers:(NSArray<NSString *> *)identifiers;

- (NSArray<CBPeripheral *> *)retrieveConnectedPeripheralsWithServices:(NSArray<NSString *> *)serviceUUIDs;

#pragma mark - 蓝牙外设方法

- (void)discoverServicesWithPeripheral:(CBPeripheral *)peripheral
                           andServices:(nullable NSArray<NSString *> *)serviceUUIDs
                              complete:(BLEDiscoverServiceBlock)complete;

- (void)discoverIncludedServicesWithPeripheral:(CBPeripheral *)peripheral
                       andIncludedServiceUUIDs:(nullable NSArray<NSString *> *)includedServiceUUIDs
                      forService:(CBService *)service
                        complete:(BLEDiscoverServiceBlock)complete;

- (void)discoverCharacteristicsWithPeripheral:(CBPeripheral *)peripheral
                          characteristicUUIDs:(nullable NSArray<NSString *> *)characteristicUUIDs
                     forService:(CBService *)service
                       complete:(BLEDiscoverCharacteristicBlock)complete;

- (void)readValueWithPeripheral:(CBPeripheral *)peripheral
              forCharacteristic:(CBCharacteristic *)characteristic
                       complete:(BLEDataTrasferBlock)complete;

- (void)subscribeValueWithPeripheral:(CBPeripheral *)peripheral
                  forCharacteristic:(CBCharacteristic *)characteristic
                            complete:(BLECommonCompletionBlock)complete
                  notify:(BLEDataTrasferBlock)notify;

- (void)subscribRSSIWithPeripheral:(CBPeripheral *)peripheral
                       rssiChanged:(void (^)(NSNumber *))rssiChanged;

- (void)writeValueWithPeripheral:(CBPeripheral *)peripheral
                           value:(NSData *)data
               forCharacteristic:(CBCharacteristic *)characteristic
                type:(CBCharacteristicWriteType)type
    complete:(BLECommonCompletionBlock)complete;

@end