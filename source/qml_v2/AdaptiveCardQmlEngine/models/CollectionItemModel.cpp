#include "CollectionItemModel.h"
#include "TextBlockModel.h"
#include "ImageModel.h"
#include "RichTextBlockModel.h"
#include "DateInputModel.h"
#include "NumberInputModel.h"
#include "TextInputModel.h"
#include "TimeInputModel.h"
#include "ToggleInputModel.h"
#include "ChoiceSetInputModel.h"
#include "AdaptiveCardEnums.h"

CollectionItemModel::CollectionItemModel(std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>> elements, QObject* parent) :
    QAbstractListModel(parent)
{
    for (auto& element : elements)
    {
        populateRowData(element);
    }
}

CollectionItemModel::~CollectionItemModel()
{
}

int CollectionItemModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return mRows.size();
}

QVariant CollectionItemModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const int rowIndex = index.row();
    const auto& rowContent = mRows.at(rowIndex);
    const auto& dataIt = rowContent.find(role);
    return dataIt != rowContent.end() ? dataIt->second : QVariant();
}

QHash<int, QByteArray> CollectionItemModel::roleNames() const
{
    QHash<int, QByteArray> cardListModel;
    cardListModel[DelegateType] = "delegateType";
    cardListModel[TextBlockRole] = "textBlockRole";
    cardListModel[ImageRole] = "imageRole";
    cardListModel[RichTextBlockRole] = "richTextBlockRole";
    cardListModel[DateInputRole] = "dateInputRole";
    cardListModel[NumberInputRole] = "numberInputRole";
    cardListModel[TextInputRole] = "textInputRole";
    cardListModel[TimeInputRole] = "timeInputRole";
    cardListModel[ToggleInputRole] = "toggleInputRole";
    cardListModel[ChoiceSetInputRole] = "choiceSetInputRole";
    cardListModel[FillHeightRole] = "fillHeightRole";

    return cardListModel;
}

void CollectionItemModel::populateRowData(std::shared_ptr<AdaptiveCards::BaseCardElement> element)
{
    RowContent rowContent;
    rowContent[CollectionModelRole::FillHeightRole] = (element->GetHeight() == AdaptiveCards::HeightType::Stretch);

    switch (element->GetElementType())
    {
    case AdaptiveCards::CardElementType::TextBlock:
        populateTextBlockModel(std::dynamic_pointer_cast<AdaptiveCards::TextBlock>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::Image:
        populateImageModel(std::dynamic_pointer_cast<AdaptiveCards::Image>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::RichTextBlock:
        populateRichTextBlockModel(std::dynamic_pointer_cast<AdaptiveCards::RichTextBlock>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::DateInput:
        populateDateInputModel(std::dynamic_pointer_cast<AdaptiveCards::DateInput>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::NumberInput:
        populateNumberInputModel(std::dynamic_pointer_cast<AdaptiveCards::NumberInput>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::TextInput:
        populateTextInputModel(std::dynamic_pointer_cast<AdaptiveCards::TextInput>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::TimeInput:
        populateTimeInputModel(std::dynamic_pointer_cast<AdaptiveCards::TimeInput>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::ToggleInput:
        populateToggleInputModel(std::dynamic_pointer_cast<AdaptiveCards::ToggleInput>(element), rowContent);
        break;
    case AdaptiveCards::CardElementType::ChoiceSetInput:
        populateChoiceSetInputModel(std::dynamic_pointer_cast<AdaptiveCards::ChoiceSetInput>(element), rowContent);
        break;
    default:
        break;
    }

    mRows.push_back(rowContent);
}

void CollectionItemModel::populateTextBlockModel(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::TextBlock);
    rowContent[CollectionModelRole::TextBlockRole] = QVariant::fromValue(new TextBlockModel(textBlock, nullptr));
}
void CollectionItemModel::populateImageModel(std::shared_ptr<AdaptiveCards::Image> image, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::Image);
    rowContent[CollectionModelRole::ImageRole] = QVariant::fromValue(new ImageModel(image, nullptr));
}
void CollectionItemModel::populateRichTextBlockModel(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::RichTextBlock);
    rowContent[CollectionModelRole::RichTextBlockRole] = QVariant::fromValue(new RichTextBlockModel(richTextBlock, nullptr));
}
void CollectionItemModel::populateDateInputModel(std::shared_ptr<AdaptiveCards::DateInput> dateInput, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::DateInput);
    rowContent[CollectionModelRole::DateInputRole] = QVariant::fromValue(new DateInputModel(dateInput, nullptr));
}
void CollectionItemModel::populateNumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::NumberInput);
    rowContent[CollectionModelRole::NumberInputRole] = QVariant::fromValue(new NumberInputModel(numberInput, nullptr));
}
void CollectionItemModel::populateTextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::TextInput);
    rowContent[CollectionModelRole::TextInputRole] = QVariant::fromValue(new TextInputModel(input, nullptr));
}
void CollectionItemModel::populateTimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::TimeInput);
    rowContent[CollectionModelRole::TimeInputRole] = QVariant::fromValue(new TimeInputModel(input, nullptr));
}
void CollectionItemModel::populateToggleInputModel(std::shared_ptr<AdaptiveCards::ToggleInput> toggleInput, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::ToggleInput);
    rowContent[CollectionModelRole::ToggleInputRole] = QVariant::fromValue(new ToggleInputModel(toggleInput, nullptr));
}
void CollectionItemModel::populateChoiceSetInputModel(std::shared_ptr<AdaptiveCards::ChoiceSetInput> choiceSetInput, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::ChoiceSetInput);
    rowContent[CollectionModelRole::ChoiceSetInputRole] = QVariant::fromValue(new ChoiceSetInputModel(choiceSetInput, nullptr));
}
