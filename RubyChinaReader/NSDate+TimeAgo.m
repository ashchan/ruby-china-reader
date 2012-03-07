#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)


-(NSString *)timeAgo {
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if(deltaSeconds < 5) {
        return @"刚刚";
    } else if(deltaSeconds < 60) {
        return [NSString stringWithFormat:@"%d秒前", (int)deltaSeconds];
    } else if(deltaSeconds < 120) {
        return @"一分钟前";
    } else if (deltaMinutes < 60) {
        return [NSString stringWithFormat:@"%d分钟前", (int)deltaMinutes];
    } else if (deltaMinutes < 120) {
        return @"一小时前";
    } else if (deltaMinutes < (24 * 60)) {
        return [NSString stringWithFormat:@"%d小时前", (int)floor(deltaMinutes/60)];
    } else if (deltaMinutes < (24 * 60 * 2)) {
        return @"昨天";
    } else if (deltaMinutes < (24 * 60 * 7)) {
        return [NSString stringWithFormat:@"%d天前", (int)floor(deltaMinutes/(60 * 24))];
    } else if (deltaMinutes < (24 * 60 * 14)) {
        return @"上周";
    } else if (deltaMinutes < (24 * 60 * 31)) {
        return [NSString stringWithFormat:@"%d周前", (int)floor(deltaMinutes/(60 * 24 * 7))];
    } else if (deltaMinutes < (24 * 60 * 61)) {
        return @"上个月";
    } else if (deltaMinutes < (24 * 60 * 365.25)) {
        return [NSString stringWithFormat:@"%d月前", (int)floor(deltaMinutes/(60 * 24 * 30))];
    } else if (deltaMinutes < (24 * 60 * 731)) {
        return @"去年";
    }
    return [NSString stringWithFormat:@"%d年前", (int)floor(deltaMinutes/(60 * 24 * 365))];
}

@end