//
//  ViewController.m
//  FirstWebChat
//
//  Created by Xinyuan Wang on 12/8/16.
//  Copyright © 2016 AlexW. All rights reserved.
//

#import "ViewController.h"
#import "ChatTableViewCell.h"

@interface ChatMessage : NSObject

@property(nonatomic, strong)NSString *message;
@property(nonatomic)BOOL isMe;
@property(nonatomic, strong)NSString *date;

@end

@implementation ChatMessage

@synthesize message, isMe;

@end

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong)NSURLSession *session;
@property(nonatomic, strong)NSURL *webUrl;
@property(nonatomic, strong)NSMutableArray * m_pool;
@property(nonatomic, strong)NSDateFormatter *formatter;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ViewController

/**********************************************************************/

#pragma mark - UIView LifeCycle                                        /

/**********************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"First Chat";
    self.m_pool = [NSMutableArray new];
    self.chatTable.tableFooterView = [UIView new];
    self.sendButton.layer.cornerRadius = 5;
    self.webUrl = [NSURL URLWithString:@"http://localhost/Webservice/jsonget.php"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config];
    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateFormat = @"MM_dd_yyyy-hh_mm_ss";
}
/**********************************************************************/

#pragma mark - Helper Fuctions

/**********************************************************************/

-(void)sendMessage: (NSString *)message{
    NSDate *now = [NSDate date];
    self.formatter.timeZone = [NSTimeZone localTimeZone];
    NSString *date = [self.formatter stringFromDate:now];
    ChatMessage *m = [ChatMessage new];
    m.message = self.inputTextField.text;
    m.isMe = YES;
    m.date = date;
    [self.m_pool addObject:m];
    [self.chatTable reloadData];
    //assemble the url
    NSURL *requestURL = [self assembleURLToServer: self.webUrl withQuery: @{@"message":message, @"timestamp":date}];
    //create communication task
    NSURLSessionTask *task = [self.session dataTaskWithURL:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            //define the return behavior in completion handler
            ChatMessage *m = [self parseJson:data];
            if(m != nil){
                [self.m_pool addObject:m];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.chatTable reloadData];
                });
            }
        }
    }];
    //start the task
    [task resume];
}
//helper function for parsing json format data
-(ChatMessage *)parseJson: (NSData *)data{
    NSError *error = nil;
    ChatMessage *m = nil;
    id respond = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error == nil){
        m = [ChatMessage new];
        m.message = respond[@"response"][@"message"];
        m.isMe = NO;
        m.date = respond[@"response"][@"timestamp"];
    }else{
        NSLog(@"%@", error.localizedDescription);
    }
    return m;
}

//helper function for sendMessage, assemble the URL with encoded query
-(NSURL *)assembleURLToServer:(NSURL *)baseUrl withQuery:(NSDictionary *)query{
    NSMutableString *url = [[NSString stringWithString: [baseUrl absoluteString]] mutableCopy];
    BOOL isFirst = true;
    for(NSString *key in query.allKeys){
        NSString *value = [query[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        if(isFirst){
            NSString *queryMessage = [NSString stringWithFormat:@"?%@=%@", key, value];
            [url appendString:queryMessage];
            isFirst = false;
        }else{
            NSString *queryMessage = [NSString stringWithFormat:@"&%@=%@", key, value];
            [url appendString:queryMessage];
        }
    }
    return [NSURL URLWithString:url];
}

/**********************************************************************/

#pragma mark - action methods

/**********************************************************************/

- (IBAction)sendButtonClicked {
    if([self.inputTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]].length > 0){
       
        [self sendMessage:self.inputTextField.text];
        self.inputTextField.text = @"";
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.m_pool.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatMessage *m = self.m_pool[indexPath.row];
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    cell.messageLabel.text = m.message;
    cell.isSender = m.isMe;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, tableView.bounds.size.width);
    return cell;
}

@end
