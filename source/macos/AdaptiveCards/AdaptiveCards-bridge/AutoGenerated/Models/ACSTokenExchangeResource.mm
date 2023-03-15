// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSTokenExchangeResource.h"
#import "TokenExchangeResource.h"



@implementation  ACSTokenExchangeResource {
    std::shared_ptr<TokenExchangeResource> mCppObj;
}

- (instancetype _Nonnull)initWithTokenExchangeResource:(const std::shared_ptr<TokenExchangeResource>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getId
{
 
    auto getIdCpp = mCppObj->GetId();
    return [NSString stringWithUTF8String:getIdCpp.c_str()];

}

- (void)setId:(NSString * _Nonnull)
{
		
    auto Cpp = std::string([ UTF8String]);
 
    mCppObj->SetId(Cpp);
    
}

- (NSString * _Nullable)getUri
{
 
    auto getUriCpp = mCppObj->GetUri();
    return [NSString stringWithUTF8String:getUriCpp.c_str()];

}

- (void)setUri:(NSString * _Nonnull)
{
		
    auto Cpp = std::string([ UTF8String]);
 
    mCppObj->SetUri(Cpp);
    
}

- (NSString * _Nullable)getProviderId
{
 
    auto getProviderIdCpp = mCppObj->GetProviderId();
    return [NSString stringWithUTF8String:getProviderIdCpp.c_str()];

}

- (void)setProviderId:(NSString * _Nonnull)
{
		
    auto Cpp = std::string([ UTF8String]);
 
    mCppObj->SetProviderId(Cpp);
    
}


@end
