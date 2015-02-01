@import Foundation;
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame: NSObject

//designated initializer
//- (instancetype)initWithCardCount:(NSUInteger) count :(Deck *)deck;
- (instancetype)initWithCardCountAndGameMode:(NSUInteger) count :(Deck *)deck :(BOOL) twoCardMode;
- (void) chooseCardAtIndex:(NSUInteger) index;
- (Card *)cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;

@end
