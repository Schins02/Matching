#import "Card.h"

@interface Card()
@end

@implementation Card

/*- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    for(Card *card in otherCards){
        if ([card.contents isEqualToString:self.contents]){
            score = 1;
        }
    }
    
    return score;
}*/

-(int) match:(Card *)otherCard{
    return [self.contents isEqualToString:otherCard.contents];
}

@end

