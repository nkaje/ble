#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "bt.h"

// cb.m: C functions for interfacing with CoreBluetooth.  This is necessary
// because Go code cannot execute some objective C constructs directly.

void
cb_scan(void *cm, bool allow_dup)
{
    [(CMgr *)cm scan:allow_dup];
}

void
cb_stop_scan(void *cm)
{
    [(CMgr *)cm stopScan];
}

int
cb_connect(void *cm, const char *peer_uuid)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    int rc = [(CMgr *)cm connect:nsuuid];

    [nsuuid release];
    return rc;
}

int
cb_att_mtu(void *cm, const char *peer_uuid)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    int rc = [(CMgr *)cm attMTUForPeriphWithUUID:nsuuid];

    [nsuuid release];
    return rc;
}

int
cb_discover_svcs(void *cm, const char *peer_uuid, const char **svc_uuids, int num_svcs)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);

    NSMutableArray *arr = NULL;
    if (num_svcs > 0) {
        arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < num_svcs; i++) {
            NSString *ns = [[NSString alloc] initWithCString:svc_uuids[i] encoding:NSUTF8StringEncoding];
            CBUUID *cu = [CBUUID UUIDWithString:ns];
            [arr addObject:cu];
        }
    }

    int rc = [(CMgr *)cm discoverServices:nsuuid services:arr];

    [arr release];
    [nsuuid release];
    return rc;
}

int
cb_discover_chrs(void *cm, const char *peer_uuid, uintptr_t svc_id, const char **chr_uuids, int num_chrs)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);

    NSMutableArray *arr = NULL;
    if (num_chrs > 0) {
        arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < num_chrs; i++) {
            NSString *ns = [[NSString alloc] initWithCString:chr_uuids[i] encoding:NSUTF8StringEncoding];
            CBUUID *cu = [CBUUID UUIDWithString:ns];
            [arr addObject:cu];
        }
    }

    CBService *svc = (CBService *)svc_id;
    int rc = [(CMgr *)cm discoverCharacteristics:nsuuid service:svc characteristics:arr];

    [arr release];
    [nsuuid release];
    return rc;
}

int
cb_discover_dscs(void *cm, const char *peer_uuid, uintptr_t chr_id)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBCharacteristic *chr = (CBCharacteristic *)chr_id;
    int rc = [(CMgr *)cm discoverDescriptors:nsuuid characteristic:chr];

    [nsuuid release];
    return rc;
}

int
cb_read_chr(void *cm, const char *peer_uuid, uintptr_t chr_id)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBCharacteristic *chr = (CBCharacteristic *)chr_id;
    int rc = [(CMgr *)cm readCharacteristic:nsuuid characteristic:chr];

    [nsuuid release];
    return rc;
}

int
cb_write_chr(void *cm, const char *peer_uuid, uintptr_t chr_id, struct byte_arr *val, bool no_rsp)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBCharacteristic *chr = (CBCharacteristic *)chr_id;
    int rc = [(CMgr *)cm writeCharacteristic:nsuuid characteristic:chr value:val noResponse:no_rsp];

    [nsuuid release];
    return rc;
}

int
cb_read_dsc(void *cm, const char *peer_uuid, uintptr_t dsc_id)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBDescriptor *dsc = (CBDescriptor *)dsc_id;
    int rc = [(CMgr *)cm readDescriptor:nsuuid descriptor:dsc];

    [nsuuid release];
    return rc;
}

int
cb_write_dsc(void *cm, const char *peer_uuid, uintptr_t dsc_id, struct byte_arr *val)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBDescriptor *dsc = (CBDescriptor *)dsc_id;
    int rc = [(CMgr *)cm writeDescriptor:nsuuid descriptor:dsc value:val];

    [nsuuid release];
    return rc;
}

int
cb_subscribe(void *cm, const char *peer_uuid, uintptr_t chr_id)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBCharacteristic *chr = (CBCharacteristic *)chr_id;
    int rc = [(CMgr *)cm subscribe:nsuuid characteristic:chr];

    [nsuuid release];
    return rc;
}

int
cb_unsubscribe(void *cm, const char *peer_uuid, uintptr_t chr_id)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    CBCharacteristic *chr = (CBCharacteristic *)chr_id;
    int rc = [(CMgr *)cm unsubscribe:nsuuid characteristic:chr];

    [nsuuid release];
    return rc;
}

int
cb_read_rssi(void *cm, const char *peer_uuid)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    int rc = [(CMgr *)cm readRSSI:nsuuid];

    [nsuuid release];
    return rc;
}

int
cb_cancel_connection(void *cm, const char *peer_uuid)
{
    NSUUID *nsuuid = uuid_from_str(peer_uuid);
    int rc = [(CMgr *)cm cancelConnection:nsuuid];

    [nsuuid release];
    return rc;
}

uintptr_t
cb_cmgr_id(void *cm)
{
    return [(CMgr *)cm ID];
}

CMgr *
cb_alloc_cmgr(void)
{
    return [[CMgr alloc] init];
}
