// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSAuthCardButton.h"
#import "AuthCardButton.h"



@implementation  ACSAuthCardButton {
    std::shared_ptr<AuthCardButton> mCppObj;
}

- (instancetype _Nonnull)initWithAuthCardButton:(const std::shared_ptr<AuthCardButton>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getType
{
 
    auto getTypeCpp = mCppObj->GetType();
    return [NSString stringWithUTF8String:getTypeCpp.c_str()];

}

- (void)setType:(NSString * _Nonnull)value
{
    auto Cpp = std::string([value UTF8String]);
 
    mCppObj->SetType(Cpp);
    
}

- (NSString * _Nullable)getTitle
{
 
    auto getTitleCpp = mCppObj->GetTitle();
    return [NSString stringWithUTF8String:getTitleCpp.c_str()];

}

- (void)setTitle:(NSString * _Nonnull)value
{
    auto Cpp = std::string([value UTF8String]);
 
    mCppObj->SetTitle(Cpp);
    
}

- (NSString * _Nullable)getImage
{
 
    auto getImageCpp = mCppObj->GetImage();
    return [NSString stringWithUTF8String:getImageCpp.c_str()];

}

- (void)setImage:(NSString * _Nonnull)value
{
    auto Cpp = std::string([value UTF8String]);
 
    mCppObj->SetImage(Cpp);
    
}

- (NSString * _Nullable)getValue
{
 
    auto getValueCpp = mCppObj->GetValue();
    return [NSString stringWithUTF8String:getValueCpp.c_str()];

}

- (void)setValue:(NSString * _Nonnull)value
{
    auto Cpp = std::string([value UTF8String]);
 
    mCppObj->SetValue(Cpp);
    
}


@end
