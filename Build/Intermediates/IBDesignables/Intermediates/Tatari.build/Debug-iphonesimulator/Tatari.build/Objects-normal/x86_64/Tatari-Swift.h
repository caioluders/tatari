// Generated by Apple Swift version 2.1 (swiftlang-700.1.101.6 clang-700.1.76)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
@import Foundation;
@import CoreLocation;
@import FBSDKLoginKit;
#endif

#import "/Users/deborahmesquita1/Documents/Code/tatari/Bridging-Header.h"

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;
@class NSURL;
@class NSData;
@class NSError;
@class PushNotificationManager;

SWIFT_CLASS("_TtC6Tatari11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate, PushNotificationDelegate>
@property (nonatomic, strong) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (BOOL)application:(UIApplication * __nonnull)application openURL:(NSURL * __nonnull)url sourceApplication:(NSString * __nullable)sourceApplication annotation:(id __nullable)annotation;
- (void)applicationWillResignActive:(UIApplication * __nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * __nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * __nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * __nonnull)application;
- (void)applicationWillTerminate:(UIApplication * __nonnull)application;
- (void)application:(UIApplication * __nonnull)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData * __nonnull)deviceToken;
- (void)application:(UIApplication * __nonnull)application didFailToRegisterForRemoteNotificationsWithError:(NSError * __nonnull)error;
- (void)application:(UIApplication * __nonnull)application didReceiveRemoteNotification:(NSDictionary * __nonnull)userInfo;
- (void)onPushAccepted:(PushNotificationManager * __null_unspecified)pushManager withNotification:(NSDictionary * __null_unspecified)pushNotification onStart:(BOOL)onStart;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCoder;

SWIFT_CLASS("_TtC6Tatari18BorderFeedCellView")
@interface BorderFeedCellView : UIView
- (void)drawRect:(CGRect)rect;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSBundle;

SWIFT_CLASS("_TtC6Tatari20ConfigViewController")
@interface ConfigViewController : UIViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (IBAction)btLogoutPressed:(id __nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC6Tatari22DesafiosViewController")
@interface DesafiosViewController : UIViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITableView;
@class NSMutableData;
@class NSIndexPath;
@class UITableViewCell;
@class NSMutableURLRequest;
@class UIActivityIndicatorView;

SWIFT_CLASS("_TtC6Tatari14FeedController")
@interface FeedController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView * __null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * __null_unspecified activityFeed;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull items;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull itemsTitle;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull itemsBody;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> * __nonnull arrayOfMessages;
@property (nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> * __nonnull arraySorted;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * __nonnull messageDict;
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> * __nonnull challengeDict;
@property (nonatomic, strong) NSMutableData * __nonnull data;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (void)tableView:(UITableView * __nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (CGFloat)tableView:(UITableView * __nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (NSString * __nonnull)JSONStringify:(id __nonnull)value prettyPrinted:(BOOL)prettyPrinted;
- (void)HTTPsendRequest:(NSMutableURLRequest * __nonnull)request callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (void)HTTPPostJSON:(NSString * __nonnull)url jsonObj:(id __nonnull)jsonObj callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UITextView;
@class UIImageView;

SWIFT_CLASS("_TtC6Tatari17FeedTableViewCell")
@interface FeedTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblTitle;
@property (nonatomic, weak) IBOutlet UITextView * __null_unspecified txtBody;
@property (nonatomic, weak) IBOutlet UIImageView * __null_unspecified imgMessageTagType;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * __nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class CMMotionManager;
@class CLLocationManager;
@class UISegmentedControl;
@class CLLocation;

SWIFT_CLASS("_TtC6Tatari14MainController")
@interface MainController : UIViewController <CLLocationManagerDelegate>
@property (nonatomic, strong) CMMotionManager * __nonnull motionManager;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)updateSensorDataArray;
@property (nonatomic, strong) CLLocationManager * __null_unspecified locationManager;
- (IBAction)accuracyChanged:(UISegmentedControl * __nonnull)sender;
- (void)locationManager:(CLLocationManager * __nonnull)manager didUpdateToLocation:(CLLocation * __nonnull)newLocation fromLocation:(CLLocation * __nonnull)oldLocation;
- (IBAction)btSauda:(id __nonnull)sender;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface NSNumber (SWIFT_EXTENSION(Tatari))
@property (nonatomic, readonly) BOOL isBool;
@end

@class CAShapeLayer;
@class UIColor;

SWIFT_CLASS("_TtC6Tatari12PinImageView")
@interface PinImageView : UIView
@property (nonatomic, strong) CAShapeLayer * __null_unspecified backgroundLayer;
@property (nonatomic, strong) UIColor * __nonnull backgroundLayerColor;
@property (nonatomic) CGFloat lineWidth;
- (void)layoutSubviews;
- (void)setBackgroundLayer;
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImage;
@class UITextField;
@class NSString;
@class UIButton;

SWIFT_CLASS("_TtC6Tatari16SearchController")
@interface SearchController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * __null_unspecified activityLoadingSearch;
@property (nonatomic, weak) IBOutlet UITableView * __null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UITextField * __null_unspecified txtFieldSearch;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull people;
@property (nonatomic, copy) NSArray<UIImage *> * __nonnull imgPeople;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull fbIds;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull idsLikes;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)textFieldDidChange:(UITextField * __nonnull)textField;
- (BOOL)textFieldShouldReturn:(UITextField * __nonnull)textField;
- (void)search_people:(NSString * __nonnull)ssearch;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (void)viewDidAppear:(BOOL)animated;
- (void)showChallengeView:(NSString * __nonnull)fbId;
- (void)buttonDesafiarAction:(UIButton * __null_unspecified)sender;
- (void)send_chall:(NSString * __nonnull)fb_id challenge_desc:(NSString * __nonnull)challenge_desc;
- (CGFloat)tableView:(UITableView * __nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (NSString * __nonnull)JSONStringify:(id __nonnull)value prettyPrinted:(BOOL)prettyPrinted;
- (void)HTTPsendRequest:(NSMutableURLRequest * __nonnull)request callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (void)HTTPPostJSON:(NSString * __nonnull)url jsonObj:(id __nonnull)jsonObj callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface UIApplication (SWIFT_EXTENSION(Tatari))
+ (void)tryURL:(NSArray<NSString *> * __nonnull)urls;
@end

@class FBSDKLoginButton;
@class FBSDKLoginManagerLoginResult;

SWIFT_CLASS("_TtC6Tatari14ViewController")
@interface ViewController : UIViewController <FBSDKLoginButtonDelegate>
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)loginButton:(FBSDKLoginButton * __null_unspecified)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult * __null_unspecified)result error:(NSError * __null_unspecified)error;
- (void)loginButtonDidLogOut:(FBSDKLoginButton * __null_unspecified)loginButton;
- (void)getFBUserData;
- (NSString * __nonnull)JSONStringify:(id __nonnull)value prettyPrinted:(BOOL)prettyPrinted;
- (void)HTTPsendRequest:(NSMutableURLRequest * __nonnull)request callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (void)HTTPPostJSON:(NSString * __nonnull)url jsonObj:(id __nonnull)jsonObj callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIImagePickerController;

SWIFT_CLASS("_TtC6Tatari14VoteController")
@interface VoteController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate>
@property (nonatomic, strong) UIImagePickerController * __null_unspecified imagePicker;
@property (nonatomic, strong) UITableView * __null_unspecified tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView * __null_unspecified activityVote;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull items;
@property (nonatomic, copy) NSArray<UIImage *> * __nonnull pictures;
@property (nonatomic, copy) NSArray<NSNumber *> * __nonnull qtdVotes;
@property (nonatomic, copy) NSArray<NSNumber *> * __nonnull voted;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull names;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull ids;
@property (nonatomic, copy) NSArray<NSString *> * __nonnull idsVotadas;
@property (nonatomic, strong) NSMutableData * __nonnull data;
@property (nonatomic, copy) NSString * __nonnull idBotaoVoto;
- (void)viewDidLoad;
- (void)getDataFromServer;
- (void)cleanAllArrays;
- (void)didReceiveMemoryWarning;
- (IBAction)btParticipar:(id __nonnull)sender;
- (void)imagePickerController:(UIImagePickerController * __nonnull)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> * __nonnull)info;
- (NSInteger)tableView:(UITableView * __nonnull)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell * __nonnull)tableView:(UITableView * __nonnull)tableView cellForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (void)buttonVoteAction:(UIButton * __null_unspecified)sender;
- (void)tableView:(UITableView * __nonnull)tableView didSelectRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (CGFloat)tableView:(UITableView * __nonnull)tableView heightForRowAtIndexPath:(NSIndexPath * __nonnull)indexPath;
- (NSString * __nonnull)JSONStringify:(id __nonnull)value prettyPrinted:(BOOL)prettyPrinted;
- (void)HTTPsendRequest:(NSMutableURLRequest * __nonnull)request callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (void)HTTPPostJSON:(NSString * __nonnull)url jsonObj:(id __nonnull)jsonObj callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (void)vote_for:(NSInteger)id;
- (void)add_photo:(UIImage * __nonnull)img;
- (nonnull instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC6Tatari17VotoTableViewCell")
@interface VotoTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblVoteCount;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified btVote;
@property (nonatomic, weak) IBOutlet UIImageView * __null_unspecified imgPerson;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblName;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (IBAction)btVotePressed:(id __nonnull)sender;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * __nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC6Tatari19personTableViewCell")
@interface personTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView * __null_unspecified imgPessoa;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblCurtir;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblDesafiar;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblFacebook;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified btCurtir;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified btFacebook;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified btDesafiar;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified lblNome;
@property (nonatomic, weak) IBOutlet UIView * __null_unspecified borderView;
@property (nonatomic, copy) NSString * __nonnull fbId;
- (void)awakeFromNib;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (IBAction)btFacebookPressed:(UIButton * __nonnull)sender;
- (IBAction)btDesafiarPressed:(UIButton * __nonnull)sender;
- (IBAction)btCurtirPressed:(id __nonnull)sender;
- (void)send_chall:(NSString * __nonnull)fb_id challenge_desc:(NSString * __nonnull)challenge_desc;
- (NSString * __nonnull)JSONStringify:(id __nonnull)value prettyPrinted:(BOOL)prettyPrinted;
- (void)HTTPsendRequest:(NSMutableURLRequest * __nonnull)request callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (void)HTTPPostJSON:(NSString * __nonnull)url jsonObj:(id __nonnull)jsonObj callback:(void (^ __nonnull)(NSString * __nonnull, NSString * __nullable))callback;
- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * __nullable)reuseIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
