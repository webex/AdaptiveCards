#include "CollectionItemModel.h"
#include "TextBlockModel.h"
#include "RichTextBlockModel.h"
#include "AdaptiveCardEnums.h"

CollectionItemModel::CollectionItemModel(std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>> elements, QObject* parent)
	: QAbstractListModel(parent)
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
    cardListModel[RichTextBlockRole] = "richTextBlockRole";
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
	case AdaptiveCards::CardElementType::RichTextBlock:
        populateRichTextBlockModel(std::dynamic_pointer_cast<AdaptiveCards::RichTextBlock>(element), rowContent);
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

void CollectionItemModel::populateRichTextBlockModel(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, RowContent& rowContent)
{
    rowContent[CollectionModelRole::DelegateType] = QVariant::fromValue(AdaptiveCardEnums::CardElementType::RichTextBlock);
    rowContent[CollectionModelRole::RichTextBlockRole] = QVariant::fromValue(new RichTextBlockModel(richTextBlock, nullptr));
}