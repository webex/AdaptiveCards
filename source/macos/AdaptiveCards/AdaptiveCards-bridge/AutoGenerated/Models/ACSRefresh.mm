// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSBaseActionElement.h"

//cpp includes
#import "BaseActionElement.h"


#import "ACSRefresh.h"
#import "Refresh.h"



@implementation  ACSRefresh {
    std::shared_ptr<Refresh> mCppObj;
}

- (instancetype _Nonnull)initWithRefresh:(const std::shared_ptr<Refresh>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (ACSBaseActionElement * _Nullable)getAction
{
 
    auto getActionCpp = mCppObj->GetAction();
    if (getActionCpp)
        return [[ACSBaseActionElement alloc] initWithBaseActionElement:getActionCpp];
    return NULL;

}

- (void)setAction:(ACSBaseActionElement * _Nonnull)value
{
    // auto Cpp = [ACSBaseActionElementConvertor convertObj:];
 
    // mCppObj->SetAction(Cpp);
    
}

- (NSArray<NSString *> * _Nonnull)getUserIds
{
 
    auto getUserIdsCpp = mCppObj->GetUserIds();
    NSMutableArray*  objList = [NSMutableArray new];
    for (const auto& item: getUserIdsCpp)
    {
        [objList addObject: [NSString stringWithUTF8String:item.c_str()]];
    }
    return objList;


}

- (void)setUserIds:(NSArray<NSString *>* _Nonnull)value
{
    // std::vector<std::string> Vector;
    // for (id Obj in )
    // {
    //     Vector.push_back(std::string([Obj UTF8String]));
    // }

 
    // mCppObj->SetUserIds(Vector);
    
}


@end
