// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSAuthCardButton.h"
#import "ACSTokenExchangeResource.h"

//cpp includes
#import "AuthCardButton.h"
#import "TokenExchangeResource.h"


#import "ACSAuthentication.h"
#import "Authentication.h"



@implementation  ACSAuthentication {
    std::shared_ptr<Authentication> mCppObj;
}

- (instancetype _Nonnull)initWithAuthentication:(const std::shared_ptr<Authentication>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getText
{
 
    auto getTextCpp = mCppObj->GetText();
    return [NSString stringWithUTF8String:getTextCpp.c_str()];

}

- (void)setText:(NSString * _Nonnull)
{
    auto Cpp = std::string([ UTF8String]);
 
    mCppObj->SetText(Cpp);
    
}

- (NSString * _Nullable)getConnectionName
{
 
    auto getConnectionNameCpp = mCppObj->GetConnectionName();
    return [NSString stringWithUTF8String:getConnectionNameCpp.c_str()];

}

- (void)setConnectionName:(NSString * _Nonnull)
{
    auto Cpp = std::string([ UTF8String]);
 
    mCppObj->SetConnectionName(Cpp);
    
}

- (ACSTokenExchangeResource * _Nullable)getTokenExchangeResource
{
 
    auto getTokenExchangeResourceCpp = mCppObj->GetTokenExchangeResource();
	if (getTokenExchangeResourceCpp)
        return [[ACSTokenExchangeResource alloc] initWithTokenExchangeResource:getTokenExchangeResourceCpp];
    return NULL;

}

- (void)setTokenExchangeResource:(ACSTokenExchangeResource * _Nonnull)
{
    // auto Cpp = [ACSTokenExchangeResourceConvertor convertObj:];
 
    // mCppObj->SetTokenExchangeResource(Cpp);
    
}

- (NSArray<ACSAuthCardButton *> * _Nonnull)getButtons
{
 
    auto getButtonsCpp = mCppObj->GetButtons();
    NSMutableArray*  objList = [NSMutableArray new];
    for (const auto& item: getButtonsCpp)
    {
        [objList addObject: [[ACSAuthCardButton alloc] initWithAuthCardButton:item]];
    }
    return objList;


}

- (void)setButtons:(NSArray<ACSAuthCardButton *>* _Nonnull)
{
	// 	    std::vector<AdaptiveCards::AuthCardButton> Vector;
    // for (id Obj in )
    // {
    //     Vector.push_back([ACSAuthCardButtonConvertor convertObj:Obj]);
    // }

 
    // mCppObj->SetButtons(Vector);
    
}


@end
