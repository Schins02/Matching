#import "PlayingCard.h"

@interface PlayingCard()

+ (BOOL) sameColor:(NSString *) suitOne :(NSString *) suitTwo;
+ (BOOL) sameSuit:(NSString *) suitOne :(NSString *) suitTwo;
+ (BOOL) sameRank:(char) rankOne :(char) rankTwo;

@end

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *)contents{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits{
    return @[@"♥", @"♣", @"♦", @"♠"];
}

+ (NSUInteger)maxRank{
    return [[self rankStrings] count] - 1;
}

- (void)setSuite:(NSString *)suit{
    if ([[PlayingCard validSuits] containsObject: suit])
        _suit = suit;
}

+ (NSArray *)rankStrings{
    return @[@"?",@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

-(NSString *)suit{
    return _suit ? _suit : @"?";
}

-(void)setRank:(NSUInteger)rank{
    if(rank <= [PlayingCard maxRank])
        _rank = rank;
}

-(int) match:(PlayingCard *)otherCard{
    int score = 0;
    
    if([[self class]sameColor:self.suit :otherCard.suit])
        score = 1;
    
    if([[self class] sameSuit:self.suit :otherCard.suit])
        score = 2;
    
    if([[self class] sameRank:self.rank :otherCard.rank])
        score = 8;
    
    if([[self class]sameColor:self.suit :otherCard.suit] && [[self class]sameRank: self.rank :otherCard.rank])
        score = 16;
    
    if([[self class] sameSuit:self.suit :otherCard.suit] && [[self class] sameRank:self.rank :otherCard.rank])
        score = 32;
    
    return score;
}

+ (BOOL) sameColor:(NSString *) suitOne :(NSString *) suitTwo{
    
    return ([@[@"♥", @"♦"] containsObject:suitOne] &&
            [@[@"♥", @"♦"] containsObject:suitTwo]) ||
    ([@[@"♣", @"♠"] containsObject:suitOne] &&
     [@[@"♣", @"♠"] containsObject:suitTwo]);
    
}

+ (BOOL) sameSuit:(NSString *) suitOne :(NSString *) suitTwo{
    return ([suitOne isEqualToString:suitTwo]);
}

+ (BOOL) sameRank:(char) rankOne :(char) rankTwo{
    return rankOne == rankTwo;
}

/*-(int) match:(Card *)otherCard{
 int score = 0;
 
 char suitChar = [self.contents characterAtIndex:[self.contents length] - 1];
 NSString* thisSuit = [NSString stringWithFormat:@"%c" , suitChar];
 
 char otherSuitChar = [otherCard.contents characterAtIndex:[otherCard.contents length] - 1];
 NSString* otherSuit = [NSString stringWithFormat:@"%c" , otherSuitChar];
 
 char rank = [self.contents characterAtIndex:0];
 char otherRank = [otherCard.contents characterAtIndex:0];
 
 score = [[self class]sameColor:thisSuit:otherSuit];
 
 if([[self class] sameSuit:thisSuit:otherSuit])
 score = 2;
 
 if([[self class] sameRank:rank :otherRank])
 score = 8;
 
 if([[self class]sameColor:thisSuit:otherSuit] && [[self class] sameRank:rank :otherRank])
 score = 16;
 
 if([[self class] sameSuit:thisSuit:otherSuit] && [[self class] sameRank:rank :otherRank])
 score = 32;
 
 return score;
 
 }*/













@end