//
//  ViewController.m
//  Matching
//
//  Created by John  Schindler on 1/29/15.
//  Copyright (c) 2015 John  Schindler. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMatchingScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesPLayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageScoreLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation ViewController

-( Deck *) deck{
    if(!_deck) _deck = [self createDeck];
    return _deck;
}

- (Deck *) createDeck{
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)game{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCountAndGameMode:[self.cardButtons count]: [self createDeck] :true];
     return _game;
}

const char DIAMOND = 'f';
const char HEART = 'e';

- (IBAction)touchCardButton:(UIButton *)sender{
    
    /*
    if(sender.currentTitle.length){
        [sender setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                          forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    }else{
        
        Card *randomCard = [self.deck drawRandomCard];
        NSString *contents;
        contents = randomCard.contents;
        char suit = [contents characterAtIndex:[contents length] - 1];
        [sender setTitle:contents forState:UIControlStateNormal];
        if(suit == DIAMOND || suit == HEART)
            [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        else
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if(randomCard){
            [sender setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            [sender setTitle:randomCard.contents forState:UIControlStateNormal];
        }
        
    }*/
    //int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

-(void) updateUI{
    for(UIButton *cardButton in self.cardButtons){
        //int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        //@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
        //@property (weak, nonatomic) IBOutlet UILabel *lastMatchingScoreLabel;
        //@property (weak, nonatomic) IBOutlet UILabel *gamesPLayedLabel;
        //@property (weak, nonatomic) IBOutlet UILabel *averageScoreLabel;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)[self.game score]];
        
        
        
                                 
        self.lastMatchingScoreLabel.text = [NSString stringWithFormat:@"Last Matching Score: %ld", (long)[self.game lastMatchingScore]];
        /*self.gamesPLayedLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
        self.averageScoreLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];*/
        cardButton.enabled = !card.matched;
        
    }
}
         
-(NSString *) titleForCard:(Card *)card{
    return card.chosen ? card.contents : @"";
}

-(UIImage *) backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.chosen ? @"cardFront" : @"cardBack"];
}

- (IBAction)touchGameModeButton:(id)sender {
}

- (IBAction)touchPeekButton:(id)sender {
}



- (IBAction)touchResetButton:(id)sender {
}



/*- (void)viewDidLoad {
 [super viewDidLoad];
 /// _btn.layer.borderWidth=1.0f;
 //_btn.layer.borderColor=[[UIColor blackColor] CGColor];
 }
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }*/

@end
