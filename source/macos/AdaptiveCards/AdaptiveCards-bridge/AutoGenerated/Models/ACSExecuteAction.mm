// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSAssociatedInputsConvertor.h"

//cpp includes
#import "Enums.h"


#import "ACSExecuteAction.h"
#import "ExecuteAction.h"



@implementation  ACSExecuteAction {
    std::shared_ptr<ExecuteAction> mCppObj;
}

- (instancetype _Nonnull)initWithExecuteAction:(const std::shared_ptr<ExecuteAction>)cppObj
{
    if (self = [super initWithBaseActionElement: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getDataJson
{
 
    auto getDataJsonCpp = mCppObj->GetDataJson();
    return [NSString stringWithUTF8String:getDataJsonCpp.c_str()];

}

- (void)setDataJson:(NSString * _Nonnull)value
{
		
    auto valueCpp = std::string([value UTF8String]);
 
    mCppObj->SetDataJson(valueCpp);
    
}

- (NSString * _Nullable)getVerb
{
 
    auto getVerbCpp = mCppObj->GetVerb();
    return [NSString stringWithUTF8String:getVerbCpp.c_str()];

}

- (void)setVerb:(NSString * _Nonnull)verb
{
		
    auto verbCpp = std::string([verb UTF8String]);
 
    mCppObj->SetVerb(verbCpp);
    
}

- (ACSAssociatedInputs)getAssociatedInputs
{
 
    auto getAssociatedInputsCpp = mCppObj->GetAssociatedInputs();
    return [ACSAssociatedInputsConvertor convertCpp:getAssociatedInputsCpp];

}

- (void)setAssociatedInputs:(enum ACSAssociatedInputs)value
{
		
    auto valueCpp = [ACSAssociatedInputsConvertor convertObj:value];
 
    mCppObj->SetAssociatedInputs(valueCpp);
    
}




@end