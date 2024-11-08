#pragma once

#include <QAbstractListModel>
#include <SharedAdaptiveCard.h>
#include <TextBlock.h>
#include <Image.h>
#include <DateInput.h>
#include<ToggleInput.h>
#include <TextInput.h>
#include "RichTextBlock.h"
#include <DateInput.h>
#include <NumberInput.h>
#include <ChoiceSetInput.h>
#include "TimeInput.h"
#include "Enums.h"

class TextBlockModel;
class ImageModel;
class RichTextBlockModel;
class DateInputModel;
class NumberInputModel;
class TextInputModel;
class TimeInputModel;
class ToggleInputModel;
class ChoiceSetInputModel;

class CollectionItemModel : public QAbstractListModel
{
    Q_OBJECT

    enum CollectionModelRole
    {
        DelegateType = Qt::UserRole + 1,
        TextBlockRole,
        ImageRole,
        RichTextBlockRole,
        DateInputRole,
        NumberInputRole,
        TextInputRole,
        TimeInputRole,
        ToggleInputRole,
        ChoiceSetInputRole,
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
    void populateRichTextBlockModel(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, RowContent& rowContent);
    void populateDateInputModel(std::shared_ptr<AdaptiveCards::DateInput> dateInput, RowContent& rowContent);
    void populateNumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, RowContent& rowContent);
    void populateTextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, RowContent& rowContent);
    void populateTimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, RowContent& rowContent);
    void populateToggleInputModel(std::shared_ptr<AdaptiveCards::ToggleInput> toggleInput, RowContent& rowContent);
    void populateChoiceSetInputModel(std::shared_ptr<AdaptiveCards::ChoiceSetInput> choiceSetInput, RowContent& rowContent);
};
