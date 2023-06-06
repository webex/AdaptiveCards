// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"


//cpp includes


#import "ACSChoicesData.h"
#import "ChoicesData.h"



@implementation  ACSChoicesData {
    std::shared_ptr<ChoicesData> mCppObj;
}

- (instancetype _Nonnull)initWithChoicesData:(const std::shared_ptr<ChoicesData>)cppObj
{
    if (self = [super init])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (NSString * _Nullable)getChoicesDataType
{
 
    auto getChoicesDataTypeCpp = mCppObj->GetChoicesDataType();
    return [NSString stringWithUTF8String:getChoicesDataTypeCpp.c_str()];

}

- (void)setChoicesDataType:(NSString * _Nonnull)type
{
		
    auto typeCpp = std::string([type UTF8String]);
 
    mCppObj->SetChoicesDataType(typeCpp);
    
}

- (NSString * _Nullable)getDataset
{
 
    auto getDatasetCpp = mCppObj->GetDataset();
    return [NSString stringWithUTF8String:getDatasetCpp.c_str()];

}

- (void)setDataset:(NSString * _Nonnull)dataset
{
		
    auto datasetCpp = std::string([dataset UTF8String]);
 
    mCppObj->SetDataset(datasetCpp);
    
}


@end