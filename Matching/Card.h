@import Foundation;

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;

//- (int)match:(NSArray *)otherCards;
- (int)match:(Card *)otherCard;



@end



