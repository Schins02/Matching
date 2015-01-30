#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♣", @"♦", @"♠"];
}

+ (NSUInteger)maxRank {return [[self rankStrings] count] - 1; }

- (void)setSuite:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject: suit]){
        _suit = suit;
    }
    
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

-(void)setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

@end