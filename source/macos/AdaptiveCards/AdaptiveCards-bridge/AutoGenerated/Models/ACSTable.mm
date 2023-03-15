// DO NOT EDIT - Auto generated

// Generated with objc_viewmodel.j2

#import "SwiftInterfaceHeader.h"

#import "ACSHorizontalAlignmentConvertor.h"
#import "ACSVerticalContentAlignmentConvertor.h"
#import "ACSContainerStyleConvertor.h"
#import "ACSTableColumnDefinition.h"
#import "ACSTableRow.h"

//cpp includes
#import "Enums.h"
#import "TableColumnDefinition.h"
#import "TableRow.h"


#import "ACSTable.h"
#import "Table.h"



@implementation  ACSTable {
    std::shared_ptr<Table> mCppObj;
}

- (instancetype _Nonnull)initWithTable:(const std::shared_ptr<Table>)cppObj
{
    if (self = [super initWithCollectionCoreElement: cppObj])
    {
        mCppObj = cppObj;
    }
    return self;
}

- (bool)getShowGridLines
{
 
    auto getShowGridLinesCpp = mCppObj->GetShowGridLines();
    return getShowGridLinesCpp;

}

- (void)setShowGridLines:(bool)value
{
    auto valueCpp = value;
 
    mCppObj->SetShowGridLines(valueCpp);
    
}

- (bool)getFirstRowAsHeaders
{
 
    auto getFirstRowAsHeadersCpp = mCppObj->GetFirstRowAsHeaders();
    return getFirstRowAsHeadersCpp;

}

- (void)setFirstRowAsHeaders:(bool)value
{
    auto valueCpp = value;
 
    mCppObj->SetFirstRowAsHeaders(valueCpp);
    
}

- (ACSHorizontalAlignment _Nullable)getHorizontalCellContentAlignment
{
 
    auto getHorizontalCellContentAlignmentCpp = mCppObj->GetHorizontalCellContentAlignment();
    return [ACSHorizontalAlignmentConvertor convertCpp:getHorizontalCellContentAlignmentCpp];

}

- (void)setHorizontalCellContentAlignment:(enum ACSHorizontalAlignment _Nullable)value
{
    auto valueCpp = [ACSHorizontalAlignmentConvertor convertObj:value];
 
    mCppObj->SetHorizontalCellContentAlignment(valueCpp);
    
}

- (ACSVerticalContentAlignment _Nullable)getVerticalCellContentAlignment
{
 
    auto getVerticalCellContentAlignmentCpp = mCppObj->GetVerticalCellContentAlignment();
    return [ACSVerticalContentAlignmentConvertor convertCpp:getVerticalCellContentAlignmentCpp];

}

- (void)setVerticalCellContentAlignment:(enum ACSVerticalContentAlignment _Nullable)value
{
    auto valueCpp = [ACSVerticalContentAlignmentConvertor convertObj:value];
 
    mCppObj->SetVerticalCellContentAlignment(valueCpp);
    
}

- (ACSContainerStyle)getGridStyle
{
 
    auto getGridStyleCpp = mCppObj->GetGridStyle();
    return [ACSContainerStyleConvertor convertCpp:getGridStyleCpp];

}

- (void)setGridStyle:(enum ACSContainerStyle)value
{
    auto valueCpp = [ACSContainerStyleConvertor convertObj:value];
 
    mCppObj->SetGridStyle(valueCpp);
    
}

- (NSArray<ACSTableColumnDefinition *> * _Nonnull)getColumns
{
 
    auto getColumnsCpp = mCppObj->GetColumns();
    NSMutableArray*  objList = [NSMutableArray new];
    for (const auto& item: getColumnsCpp)
    {
        [objList addObject: [[ACSTableColumnDefinition alloc] initWithTableColumnDefinition:item]];
    }
    return objList;


}

- (void)setColumns:(NSArray<ACSTableColumnDefinition *>* _Nonnull)value
{
	// 	    std::vector<AdaptiveCards::TableColumnDefinition> valueVector;
    // for (id valueObj in value)
    // {
    //     valueVector.push_back([ACSTableColumnDefinitionConvertor convertObj:valueObj]);
    // }

 
    // mCppObj->SetColumns(valueVector);
    
}

- (NSArray<ACSTableRow *> * _Nonnull)getRows
{
 
    auto getRowsCpp = mCppObj->GetRows();
    NSMutableArray*  objList = [NSMutableArray new];
    for (const auto& item: getRowsCpp)
    {
        [objList addObject: [[ACSTableRow alloc]  ACSTableRow:item]];
    }
    return objList;


}

- (void)setRows:(NSArray<ACSTableRow *>* _Nonnull)value
{
	// 	    std::vector<AdaptiveCards::TableRow> valueVector;
    // for (id valueObj in value)
    // {
    //     valueVector.push_back([ACSTableRowConvertor convertObj:valueObj]);
    // }

 
    // mCppObj->SetRows(valueVector);
    
}


@end
