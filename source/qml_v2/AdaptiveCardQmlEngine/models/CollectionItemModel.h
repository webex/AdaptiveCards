#pragma once

#include <QAbstractListModel>
#include <SharedAdaptiveCard.h>

#include <TextBlock.h>
#include <RichTextBlock.h>
#include <Image.h>
#include <TextInput.h>
#include <TimeInput.h>
#include "Enums.h"

class TextBlockModel;
class RichTextBlockModel;
class ImageModel;
class TextInputModel;
class TimeInputModel;

class CollectionItemModel : public QAbstractListModel
{
    Q_OBJECT

    enum CollectionModelRole
    {
        DelegateType = Qt::UserRole + 1,
        TextBlockRole,
        ImageRole,
        RichTextBlockRole,
        TextInputRole,
        TimeInputRole,
        FillHeightRole
    };

public:
    using RowContent = std::unordered_map<int, QVariant>;

    explicit CollectionItemModel(std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>> elements, QObject* parent = nullptr);
    ~CollectionItemModel();

    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    std::vector<RowContent> mRows;

private:
    void populateRowData(std::shared_ptr<AdaptiveCards::BaseCardElement> element);
    void populateTextBlockModel(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, RowContent& rowContent);
    void populateImageModel(std::shared_ptr<AdaptiveCards::Image> image, RowContent& rowContent);
    void populateRichTextBlockModel(std::shared_ptr<AdaptiveCards::RichTextBlock> rightTextBlock, RowContent& rowContent);
    void populateTextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, RowContent& rowContent);
    void populateTimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, RowContent& rowContent);
};
