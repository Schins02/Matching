
#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "Math.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMatchingScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamesPLayedLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Deck *deck;
@property (nonatomic) int gamesPlayed;
@property (nonatomic) double avgScore;
@property (nonatomic) int cardCount;
@property (nonatomic) int cumulativeScore;
@property (nonatomic) BOOL peekMode;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _gamesPlayed = 0;
    _cardCount = [self.cardButtons count];
    _cumulativeScore = 0;
    _peekMode = false;
    [self.gameModeSwitch addTarget:self action:@selector(gameModeChanged:) forControlEvents:UIControlEventValueChanged];
}

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

- (void)gameModeChanged:(UISwitch *)switchState{
    if([switchState isOn]){
        self.game.twoCardMode = true;
        self.gameModeLabel.text = @"2 Card";
    }else{
        self.game.twoCardMode = false;
        self.gameModeLabel.text = @"3 Card";
    }
}

//const char DIAMOND = 'L♦';
//const char DIAMOND = 'f';
//const char HEART = 'e';
const NSString *HEART = @"♥︎";
const NSString *DIAMOND = @"⬥";


- (IBAction)touchCardButton:(UIButton *)sender{
    
    if(self.peekMode) return; //eveything disabled until peek is toggled off again
    
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    self.cardCount = self.game.cardsInGame;
    [self updateUI];
    
}

-(void) updateUI{
    
    for(UIButton *cardButton in self.cardButtons){
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        if(card.chosen){
            
            if(card.matched){
               [cardButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            }else{
                
                //char suit = [card.contents characterAtIndex:[card.contents length] - 1];
                NSString *suit = [card.contents substringWithRange:NSMakeRange(1,1)];
                if(suit == DIAMOND || suit == HEART)
                if([suit isEqualToString:HEART] || [suit isEqualToString:DIAMOND])
                    [cardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                else
                    [cardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)[self.game score]];
        self.lastMatchingScoreLabel.text = [NSString stringWithFormat:@"Last Matching Score: %ld", (long)[self.game lastMatchingScore]];
        self.gamesPLayedLabel.text = [NSString stringWithFormat:@"Games Played: %d", self.gamesPlayed];
        if(self.gamesPlayed > 0){
            double avgScore = self.cumulativeScore / (float) self.gamesPlayed;
            self.averageScoreLabel.text = [NSString stringWithFormat:@"Average Score: %.3f", avgScore];
        }
        cardButton.enabled = !card.matched;
        
        /*if((self.cardCount == 0)){
         self.cumulativeScore += self.game.score;
         self.game = nil;
         for(UIButton *cardButton in self.cardButtons){
         cardButton.enabled = true;
         }
         
         self.cardCount = 30;
         self.gamesPlayed += 1;
         [self updateUI];
         
         }*/
        
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
    if(!self.peekMode){
        
        self.peekMode = true;
        [self.game addPeakPenalty];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)[self.game score]];
        
        
        for(UIButton *cardButton in self.cardButtons){
            NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
            Card *card = [self.game cardAtIndex:cardButtonIndex];
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
            [cardButton setBackgroundImage:[UIImage imageNamed:@"cardFront"] forState:UIControlStateNormal];
            
            char suit = [card.contents characterAtIndex:[card.contents length] - 1];
            /*if(suit == DIAMOND || suit == HEART)
                [cardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            else
                [cardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];*/
        }
        
    }else{
            
            self.peekMode = false;
        
            for(UIButton *cardButton in self.cardButtons){
                NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
                Card *card = [self.game cardAtIndex:cardButtonIndex];
                if(!card.chosen){
                    [cardButton setTitle:@"" forState:UIControlStateNormal];
                    [cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
                }
                
                
                
                
            }
            
        }
    
    
        
}

-(void) setTextColor:(Card *)card{
    
}
    
    
    
- (IBAction)touchResetButton:(id)sender {
        self.cumulativeScore += self.game.score;
        self.game = nil;
        for(UIButton *cardButton in self.cardButtons){
            cardButton.enabled = true;
        }
        
        self.cardCount = 30;
        self.gamesPlayed += 1;
        [self updateUI];
        
    }
    
    
@end