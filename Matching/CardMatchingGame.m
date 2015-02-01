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
@property (nonatomic, strong) NSMutableArray *cards;  //of type Card
@property (nonatomic) BOOL twoCardMode;
@property (nonatomic) NSInteger lastIndexFlipped;
@property (nonatomic) NSInteger cardsUp;
@property (nonatomic) NSInteger cardsInGame;
//-(void) twoCardModeDraw: (Card *) card;
//-(void) threeCardModeDraw: (Card *) card;

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
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


static int MISMATCH_PENALTY = 1;
-(void) chooseCardAtIndex:(NSUInteger)index{
    
    Card *card = [self cardAtIndex:index];
    
    //if user taps on same card they previously just tapped flip it back over
    if(index == self.lastIndexFlipped){ //maybe checl for flipping??
        card.chosen = false;
        self.cardsUp = 0;
        self.lastIndexFlipped = -1;
        return;
    } else
        self.lastIndexFlipped = index;
    
    /*if(index == self.lastIndexFlipped && self.cardsUp == 1){
        card.chosen = false;
        self.cardsUp = 0;
        return;
    }*/
    
    if(!card.matched){
        
        self.score -= MISMATCH_PENALTY;
        self.cardsUp += 1;
        card.chosen = true;
        
        if(self.twoCardMode && self.cardsUp == 2){
            [self twoCardModeMatch:card];
        }else if(self.cardsUp == 3){
            [self threeCardModeMatch:card];;
        }
        
    }
    
}

-(void) twoCardModeMatch: (Card *) card{
    
    //Match against another card
    card.chosen = false;
    
    for(Card *otherCard in self.cards) {
        if(otherCard.chosen && !otherCard.matched){
            
            self.score += [card match:otherCard];
            card.matched = true;
            otherCard.matched = true;
            card.chosen = true;
            self.cardsUp = 0;
            break;
            
        }
    }
    
}


-(void) threeCardModeMatch: (Card *) card{
    
    //Match all three cards
    card.chosen = false;
    int indexOfSecondCard = -1;
    int indexOfThirdCard = -1;
    
    
    for(int i = 0; i < self.cardsInGame; i++){
        Card *otherCard = self.cards[i];
        
        if(otherCard.chosen && !otherCard.matched){
            
            if(indexOfSecondCard == -1)
                indexOfSecondCard = i;
            else
                indexOfThirdCard = i;
     
            self.score += [card match:otherCard];
        }
    }
    
    card.chosen = true;
    Card *secondCard = self.cards[indexOfSecondCard];
    Card *thirdCard = self.cards[indexOfThirdCard];
    
    self.score += [secondCard match:thirdCard];
    
    card.matched = true;
    secondCard.matched = true;
    thirdCard.matched = true;
    self.cardsUp = 0;
    
}


@end


