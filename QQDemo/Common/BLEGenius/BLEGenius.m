//
// Created by fengshuai on 15/10/19.
// Copyright (c) 2015 yundongsports.com. All rights reserved.
//

#import "BLEGenius.h"

NSString *const PERIPHERAL_CONNECTED=@"PERIPHERAL_CONNECTED_NOTIFICATION";
NSString *const PERIPHERAL_DISCONNECTED=@"PERIPHERAL_DISCONNECTED_NOTIFICATION";
NSString *const PERIPHERAL_NAME_UPDATED=@"PERIPHERAL_NAME_UPDATED_NOTIFICATION";

@interface PeripheralProxy : NSObject
@property(nonatomic, strong) CBPeripheral *peripheral;

@property(nonatomic, copy) BLEDiscoverServiceBlock bleDiscoverServiceBlock;
@property(nonatomic, copy) BLEDiscoverCharacteristicBlock bleDiscoverCharacteristicBlock;
@property(nonatomic, copy) BLEConnectionCompletionBlock bleConnectionCompletionBlock;
@property(nonatomic, copy) BLEConnectionCompletionBlock bleDisconnectionCompletionBlock;
@property(nonatomic, copy) void(^rssiChanged)(NSNumber *rssi);

@property(nonatomic, strong) NSMutableDictionary <NSString *,BLEDataTrasferBlock> *bleCharacteristicDataNotifyBlokDict;
@property(nonatomic, strong) NSMutableDictionary <NSString *,BLECommonCompletionBlock> *bleCharacteristicSubscribeNotifyBlokDict;
@property(nonatomic, strong) NSMutableDictionary <NSString *,BLECommonCompletionBlock> *bleCharacteristicWriteNotifyBlokDict;

@end

@implementation PeripheralProxy

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _bleCharacteristicDataNotifyBlokDict= [NSMutableDictionary dictionary];
        _bleCharacteristicSubscribeNotifyBlokDict= [NSMutableDictionary dictionary];
        _bleCharacteristicWriteNotifyBlokDict= [NSMutableDictionary dictionary];
    }

    return self;
}

@end

@interface BLEGenius()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(nonatomic, strong) NSMutableDictionary<NSUUID *, PeripheralProxy *> *peripheralDict;

@property(nonatomic, copy) CentralManagerStateUpdateBlock centralManagerStateUpdateBlock;
@property(nonatomic, copy) RestorationHandler restorationHandler;
@property(nonatomic, copy) BLEDiscoverPeripheralBlock discoverPeripheralBlock;

@end


@implementation BLEGenius
{
    __strong dispatch_queue_t _centralQueue;
}

+ (BLEGenius *)sharedInstance
{
    static BLEGenius *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            _instance.peripheralDict= [NSMutableDictionary dictionary];
        }
    }

    return _instance;
}

-(PeripheralProxy *)retrieveProxyByPeripheral:(CBPeripheral *)peripheral
{
    PeripheralProxy *peripheralProxy=_peripheralDict[peripheral.identifier];
    if (peripheralProxy==nil)
    {
        peripheralProxy= [[PeripheralProxy alloc] init];
        peripheralProxy.peripheral=peripheral;
        peripheral.delegate=self;
        [_peripheralDict setObject:peripheralProxy forKey:peripheral.identifier];
    }
    return peripheralProxy;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(self.centralManagerStateUpdateBlock)
        self.centralManagerStateUpdateBlock(central.state);
    self.state = central.state;
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict
{
    if (self.restorationHandler)
        self.restorationHandler(dict);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (self.discoverPeripheralBlock)
        self.discoverPeripheralBlock(peripheral,advertisementData,RSSI);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.bleConnectionCompletionBlock)
        peripheralProxy.bleConnectionCompletionBlock(peripheralProxy.peripheral, nil);
    peripheralProxy.bleConnectionCompletionBlock=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_CONNECTED object:peripheralProxy.peripheral];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.bleConnectionCompletionBlock)
        peripheralProxy.bleConnectionCompletionBlock(peripheralProxy.peripheral, error);
    peripheralProxy.bleConnectionCompletionBlock=nil;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.bleDisconnectionCompletionBlock)
        peripheralProxy.bleDisconnectionCompletionBlock(peripheralProxy.peripheral, error);
    peripheralProxy.bleDisconnectionCompletionBlock=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_DISCONNECTED object:peripheralProxy.peripheral];

}

#pragma mark - CBPeripheralDelegate

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    //TODO: handle name upated event
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices
{
    //TODO: handle service invalidated event
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.rssiChanged)
        [peripheral readRSSI];
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.rssiChanged)
        peripheralProxy.rssiChanged(RSSI) ;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.bleDiscoverServiceBlock)
        peripheralProxy.bleDiscoverServiceBlock(peripheral.services,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.bleDiscoverServiceBlock)
        peripheralProxy.bleDiscoverServiceBlock(peripheral.services,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    if (peripheralProxy.bleDiscoverCharacteristicBlock)
        peripheralProxy.bleDiscoverCharacteristicBlock(service.characteristics,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    BLEDataTrasferBlock block=[self retrieveProxyByPeripheral:peripheral].bleCharacteristicDataNotifyBlokDict[characteristic.UUID.UUIDString];
    if (block)
        block(characteristic.value,error);

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    BLECommonCompletionBlock block=[self retrieveProxyByPeripheral:peripheral].bleCharacteristicWriteNotifyBlokDict[characteristic.UUID.UUIDString];
    if (block)
        block(error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    BLECommonCompletionBlock block=[self retrieveProxyByPeripheral:peripheral].bleCharacteristicSubscribeNotifyBlokDict[characteristic.UUID.UUIDString];
    if (block)
        block(error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    //TODO: handle descriptors discovered event

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
    //TODO: handle value of descriptor upated event
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error
{
    //TODO: handle write value of descriptor event
}

#pragma mark - Public Methods

- (void)setup:(CentralManagerStateUpdateBlock)stateBlock restoreEventHandler:(void (^)(NSDictionary<NSString *, id> *state))restoreEventHandler
{
    self.centralManagerStateUpdateBlock=stateBlock;
    self.restorationHandler=restoreEventHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        NSString *queueName= [NSString stringWithFormat:@"%@.ios.blegenius", [NSBundle mainBundle].bundleIdentifier];
        _centralQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
        if (restoreEventHandler)
            _centralManager= [[CBCentralManager alloc] initWithDelegate:self queue:_centralQueue options:@{
                    CBCentralManagerOptionRestoreIdentifierKey: [NSBundle mainBundle].bundleIdentifier,
                    CBCentralManagerOptionShowPowerAlertKey:@(YES)
            }];
        else
            _centralManager= [[CBCentralManager alloc] initWithDelegate:self queue:_centralQueue options:@{
                    CBCentralManagerOptionShowPowerAlertKey:@(YES)
            }];
    });


}


- (void)scanForPeripheralsWithServices:(nullable NSArray<NSString *> *)serviceUUIDs
                               options:(nullable NSDictionary<NSString *, id> *)options
                         discoverBlock:(void (^)(CBPeripheral *task, NSDictionary<NSString *, id> * advertisementData,NSNumber *RSSI))discoverBlock
{
    if (_centralManager.state==CBCentralManagerStatePoweredOn)
    {
        self.discoverPeripheralBlock=discoverBlock;

        NSMutableArray *uiArray= [NSMutableArray arrayWithCapacity:serviceUUIDs.count];
        for(NSString *string in serviceUUIDs)
        {
            [uiArray addObject:[CBUUID UUIDWithString:string]];
        }

        [_centralManager scanForPeripheralsWithServices:uiArray.count?uiArray:nil options:options];
    }
}

- (void)stopScan
{
    [_centralManager stopScan];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                  options:(nullable NSDictionary<NSString *, id> *)options
                 complete:(void(^)(CBPeripheral *peripheral1,NSError *error))completeBlock
            didDisconnect:(void(^)(CBPeripheral *peripheral1,NSError *error))disconnectBlock;
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];

    if (completeBlock)
        peripheralProxy.bleConnectionCompletionBlock=completeBlock;

    if (disconnectBlock)
        peripheralProxy.bleDisconnectionCompletionBlock=disconnectBlock;

    if (peripheral.state==CBPeripheralStateDisconnected)
        [_centralManager connectPeripheral:peripheral options:options];
    else if (peripheral.state==CBPeripheralStateConnected)
    {
        if (completeBlock)
            completeBlock(peripheralProxy.peripheral, nil);
    }
    else if (peripheral.state==CBPeripheralStateDisconnecting)
    {
        if (completeBlock)
            completeBlock(nil, [NSError errorWithDomain:@"设备正在解除连接" code:2060225 userInfo:nil]);
    }
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    [_centralManager cancelPeripheralConnection:peripheral];
    [_peripheralDict removeObjectForKey:peripheral.identifier];
}

- (NSArray<CBPeripheral *> *)retrievePeripheralsWithIdentifiers:(NSArray<NSString *> *)identifiers
{
    NSMutableArray *uiArray= [NSMutableArray arrayWithCapacity:identifiers.count];
    for(NSString *string in identifiers)
    {
        [uiArray addObject:[[NSUUID alloc] initWithUUIDString:string]];
    }
    return [_centralManager retrievePeripheralsWithIdentifiers:uiArray];
}

- (NSArray<CBPeripheral *> *)retrieveConnectedPeripheralsWithServices:(NSArray<NSString *> *)serviceUUIDs
{
    NSMutableArray *uiArray= [NSMutableArray arrayWithCapacity:serviceUUIDs.count];
    for(NSString *string in serviceUUIDs)
    {
        [uiArray addObject:[CBUUID UUIDWithString:string]];
    }
    return [_centralManager retrieveConnectedPeripheralsWithServices:uiArray.count?uiArray:@[]];
}

#pragma mark - 蓝牙外设方法

- (void)discoverServicesWithPeripheral:(CBPeripheral *)peripheral
                           andServices:(NSArray *)serviceUUIDs
                              complete:(BLEDiscoverServiceBlock)complete
{
   
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    peripheralProxy.bleDiscoverServiceBlock=complete;
    NSMutableArray *uiArray= [NSMutableArray arrayWithCapacity:serviceUUIDs.count];
    for(NSString *string in serviceUUIDs)
    {
        [uiArray addObject:[CBUUID UUIDWithString:string]];
    }
    [peripheral discoverServices:uiArray.count?uiArray:nil];
}

- (void)discoverIncludedServicesWithPeripheral:(CBPeripheral *)peripheral
                       andIncludedServiceUUIDs:(NSArray *)includedServiceUUIDs
                                    forService:(CBService *)service
                                      complete:(BLEDiscoverServiceBlock)complete
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    peripheralProxy.bleDiscoverServiceBlock=complete;
    NSMutableArray *uiArray= [NSMutableArray arrayWithCapacity:includedServiceUUIDs.count];
    for(NSString *string in includedServiceUUIDs)
    {
        [uiArray addObject:[CBUUID UUIDWithString:string]];
    }
    [peripheral discoverIncludedServices:uiArray.count?uiArray:nil forService:service];
}

- (void)discoverCharacteristicsWithPeripheral:(CBPeripheral *)peripheral
                          characteristicUUIDs:(nullable NSArray<NSString *> *)characteristicUUIDs
                                   forService:(CBService *)service
                                     complete:(BLEDiscoverCharacteristicBlock)complete
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    peripheralProxy.bleDiscoverCharacteristicBlock=complete;
    NSMutableArray *uiArray= [NSMutableArray arrayWithCapacity:characteristicUUIDs.count];
    for(NSString *string in characteristicUUIDs)
    {
        [uiArray addObject:[CBUUID UUIDWithString:string]];
    }
    [peripheral discoverCharacteristics:uiArray.count?uiArray:nil forService:service];
}


- (void)readValueWithPeripheral:(CBPeripheral *)peripheral
              forCharacteristic:(CBCharacteristic *)characteristic
                       complete:(void(^)(NSData *data,NSError *error))complete
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    peripheralProxy.bleCharacteristicDataNotifyBlokDict[characteristic.UUID.UUIDString]= [complete copy];
    [peripheral readValueForCharacteristic:characteristic];
}

- (void)subscribeValueWithPeripheral:(CBPeripheral *)peripheral
                   forCharacteristic:(CBCharacteristic *)characteristic
                            complete:(void(^)(NSError *error))complete
        notify:(void(^)(NSData *data, NSError *error))notify
{
    if (characteristic.properties&CBCharacteristicPropertyNotify)
    {
        PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
        peripheralProxy.bleCharacteristicSubscribeNotifyBlokDict[characteristic.UUID.UUIDString]= [complete copy];
        peripheralProxy.bleCharacteristicDataNotifyBlokDict[characteristic.UUID.UUIDString]= [notify copy];
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

- (void)subscribRSSIWithPeripheral:(CBPeripheral *)peripheral rssiChanged:(void (^)(NSNumber *))rssiChanged
{
    PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
    peripheralProxy.rssiChanged= [rssiChanged copy];
}


- (void)writeValueWithPeripheral:(CBPeripheral *)peripheral
                           value:(NSData *)data
               forCharacteristic:(CBCharacteristic *)characteristic
                            type:(CBCharacteristicWriteType)type
                        complete:(void(^)(NSError *error))complete
{
    if (characteristic.properties&(CBCharacteristicPropertyWrite|CBCharacteristicPropertyWriteWithoutResponse))
    {
        PeripheralProxy *peripheralProxy= [self retrieveProxyByPeripheral:peripheral];
        peripheralProxy.bleCharacteristicWriteNotifyBlokDict[characteristic.UUID.UUIDString]= [complete copy];
        [peripheral writeValue:data forCharacteristic:characteristic type:type];
    }
}


@end