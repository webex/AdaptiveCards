#include "SampleCardListModel.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QHash>
#include <QByteArray>
#include <QDebug>

SampleCardListModel::SampleCardListModel(QObject *parent)
	: QAbstractListModel(parent)
{
    populateCardDisplayNames();
	populateCardData();
}

SampleCardListModel::~SampleCardListModel()
{

}

void SampleCardListModel::populateCardData()
{
    QDir dir(SAMPLE_JSON_FOLDER);
	if (!dir.exists())
	{
		return;
	}

	QStringList files = dir.entryList(QStringList() << "*", QDir::Files);
    foreach(QString fileName, files)
    {
        QFile file(dir.absoluteFilePath(fileName));
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            qDebug() << "Could not open file:" << fileName;
            continue;
        }

        QTextStream in(&file);
        QString fileContent = in.readAll();
        file.close();


        CardData cardData;
        cardData[CardFileNameRole] = fileName;
        cardData[CardDisplayNameRole] = getDisplayName(fileName);
        cardData[CardJSONStringRole] = fileContent;

        mCardData.append(cardData);
    }
}

void SampleCardListModel::populateCardDisplayNames()
{
    mCardDisplayNames.insert("emptyCard.json", "Empty card");
    mCardDisplayNames.insert("textBlock.json", "TextBlock");
    mCardDisplayNames.insert("richTextBlock.json", "Rich text");
    mCardDisplayNames.insert("inputText.json", "Input text");
    mCardDisplayNames.insert("numberInput.json", "Input number");
    mCardDisplayNames.insert("actionInline.json", "Action Inline");
    mCardDisplayNames.insert("dateInput.json", "Input date");
    mCardDisplayNames.insert("checkBoxInput.json", "Input Toggle");
    mCardDisplayNames.insert("choiceSetInput.json", "Input ChoiceSet");
    mCardDisplayNames.insert("image.json", "Image");
    mCardDisplayNames.insert("factSet.json", "Fact Set");
    mCardDisplayNames.insert("container.json", "Container");
    mCardDisplayNames.insert("timeInput.json", "Input Time");
    mCardDisplayNames.insert("imageSet.json", "Image Set");
    mCardDisplayNames.insert("separator.json", "Seperator and Spacing");
    mCardDisplayNames.insert("simpleColumnSet.json", "ColumnSet");
    mCardDisplayNames.insert("columnSetWithBGImage.json", "ColumnSet With Background Image");
    mCardDisplayNames.insert("columnSetWithBleed.json", "ColumnSet With Bleed");
    mCardDisplayNames.insert("columnSetWithBleedColumns.json", "ColumnSet With Bleed Columns");
    mCardDisplayNames.insert("columnSetWithMinHeight.json", "ColumnSet With Min Height");
    mCardDisplayNames.insert("columnSetWithSeparator.json", "ColumnSet With Separator");
    mCardDisplayNames.insert("columnSetWithWeightedWidth.json", "ColumnSet With Weighted Width");
    mCardDisplayNames.insert("actionOpenUrl.json", "Action Open URL");
    mCardDisplayNames.insert("actionSubmit.json", "Action Submit 1");
    mCardDisplayNames.insert("cardflight.json", "Flight Iternery");
    mCardDisplayNames.insert("cardWeather.json", "Weather Card");
    mCardDisplayNames.insert("actionShowCard1.json", "Action Show Card 1");
    mCardDisplayNames.insert("actionShowCard2.json", "Action Show Card 2");
    mCardDisplayNames.insert("actionToggleVisibility.json", "Action Toggle Visibility");
    mCardDisplayNames.insert("actionSet.json", "Action Set");
    mCardDisplayNames.insert("selectActionCard.json", "Select Action - Card");
    mCardDisplayNames.insert("imageSelectAction.json", "Select Action - Image");
    mCardDisplayNames.insert("textRunSelectAction.json", "Select Action - TextRun");
    mCardDisplayNames.insert("containerSelectAction.json", "Select Action - Container");
    mCardDisplayNames.insert("columnSetSelectAction.json", "Select Action - ColumnSet");
    mCardDisplayNames.insert("selectActionImageSet.json", "Select Action Image Set");
    mCardDisplayNames.insert("selectActionWiz.json", "Select Action Wizard");
    mCardDisplayNames.insert("cardFoodOrder.json", "Food order");
    mCardDisplayNames.insert("showCardWiz.json", "Show card wizard");
    mCardDisplayNames.insert("toggleVisibilityWiz.json", "Toggle Visibility wizard");
    mCardDisplayNames.insert("backgroundImage.json", "Background Image");
    mCardDisplayNames.insert("bleed.json", "Bleed Properties");
    mCardDisplayNames.insert("inputElements.json", "Input Elements");
    mCardDisplayNames.insert("inputValidation.json", "Input Validation");
    mCardDisplayNames.insert("actionSetHorizontalAlign.json", "Action Set Alignment");
    mCardDisplayNames.insert("emptyCard.json", "Empty card");
}

QString SampleCardListModel::getDisplayName(const QString& fileName) const
{
    return mCardDisplayNames.value(fileName);
}

int SampleCardListModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid())
        return 0;

    return mCardData.size();
}

QVariant SampleCardListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid())
        return QVariant(QStringLiteral("error"));

    const int rowIndex = index.row();
    const auto& rowContent = mCardData.at(rowIndex);

    return rowContent[role];
}

QHash<int, QByteArray> SampleCardListModel::roleNames() const
{
    QHash<int, QByteArray> names;

    names[CardFileNameRole] = "CardFileName";
    names[CardDisplayNameRole] = "CardDisplayName";
    names[CardJSONStringRole] = "CardJSON";

    return names;
}
