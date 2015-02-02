//
//  CardMatchingGame.m
//  Matching
//
//  Created by John  Schindler on 1/31/15.
//  Copyright (c) 2015 John  Schindler. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastMatchingScore;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic) NSInteger lastIndexFlipped;
@property (nonatomic) NSInteger cardsUp;
@property (nonatomic, readwrite) int cardsInGame;

@end

@implementation CardMatchingGame

- (NSMutableArray *) cards{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype) initWithCardCountAndGameMode:(NSUInteger)count :(Deck *)deck :(BOOL) twoCardMode{
    
    self = [super init];
    if(self){
        for(int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if(card){
                [self.cards addObject:card];
            }else{
                self = nil;
                break;
            }
        }
    }
    
    self.cardsInGame = count;
    self.twoCardMode = twoCardMode;
    self.lastIndexFlipped = -1;
    self.cardsUp = 0;
    self.lastMatchingScore = 0;
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void) addPeakPenalty{
    self.score -= 15;
}

static int FLIP_PENALTY = 1;
-(void) chooseCardAtIndex:(NSUInteger)index{
    
    Card *card = [self cardAtIndex:index];
    
    //if user taps on same card they previously just tapped flip it back over
    if(index == self.lastIndexFlipped){ //maybe check for flipping??
        card.chosen = false;
        self.cardsUp = 0;
        self.lastIndexFlipped = -1;
        return;
    } else
        self.lastIndexFlipped = index;
    
    if(!card.matched){
        
        self.score -= FLIP_PENALTY;
        self.cardsUp += 1;
        card.chosen = true;
        
        if(self.twoCardMode && self.cardsUp == 2)
            [self twoCardModeMatch:card];
        else if(self.cardsUp == 3)
            [self threeCardModeMatch:card];;
        
    }
    
}

-(void) twoCardModeMatch: (Card *) card{
    
    //Match against one other card
    card.chosen = false;
    
    for(Card *otherCard in self.cards) {
        if(otherCard.chosen && !otherCard.matched){
            
            self.lastMatchingScore = [card match:otherCard];
            self.score += self.lastMatchingScore;
    
            card.matched = true;
            otherCard.matched = true;
            card.chosen = true;
            self.cardsUp = 0;
            self.cardsInGame -= 2;
            break;
            
        }
    }
    
}

-(void) threeCardModeMatch: (Card *) card{
    
    //Match all three cards
    card.chosen = false;
    self.lastMatchingScore = 0;
    int indexOfSecondCard = -1;
    int indexOfThirdCard = -1;
    
    
    for(int i = 0; i < [self.cards count]; i++){
        Card *otherCard = self.cards[i];
        
        if(otherCard.chosen && !otherCard.matched){
            
            if(indexOfSecondCard == -1)
                indexOfSecondCard = i;
            else
                indexOfThirdCard = i;
            
            self.lastMatchingScore = [card match:otherCard];
        }
    }
    
    card.chosen = true;
    Card *secondCard = self.cards[indexOfSecondCard];
    Card *thirdCard = self.cards[indexOfThirdCard];
    
    self.lastMatchingScore += [secondCard match:thirdCard];
    self.score += self.lastMatchingScore;
    
    card.matched = true;
    secondCard.matched = true;
    thirdCard.matched = true;
    self.cardsInGame -= 3;
    self.cardsUp = 0;
}

@end


