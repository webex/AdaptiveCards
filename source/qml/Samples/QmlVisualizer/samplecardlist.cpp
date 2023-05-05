#pragma once

#include "stdafx.h"
#include "samplecardlist.h"

SampleCardList::SampleCardList(QObject *parent) : QObject(parent)
{
    mCards.append({ QStringLiteral("Empty card"), getJsonString("emptyCard")});
    mCards.append({ QStringLiteral("TextBlock"), getJsonString("textBlock")});
    mCards.append({ QStringLiteral("Rich text"), getJsonString("richTextBlock")});
    mCards.append({ QStringLiteral("Input text"), getJsonString("inputText") } );
    mCards.append({ QStringLiteral("Action Inline"), getJsonString("actionInline") } );
    mCards.append({ QStringLiteral("Input number"), getJsonString("inputNumber") } );
    mCards.append({ QStringLiteral("Input date"), getJsonString("dateInput") } );
    mCards.append({ QStringLiteral("Input Toggle"), getJsonString("checkboxInput") } );
    mCards.append({ QStringLiteral("Input ChoiceSet"), getJsonString("choiceSetInput") } );
    mCards.append({ QStringLiteral("Image"), getJsonString("image") } );
    mCards.append({ QStringLiteral("Fact Set"), getJsonString("factSet") } );
	mCards.append({ QStringLiteral("Container"), getJsonString("container") } );
	mCards.append({ QStringLiteral("Input Time"), getJsonString("timeInput") } );
	mCards.append({ QStringLiteral("Image Set"), getJsonString("imageSet") } );
	mCards.append({ QStringLiteral("Seperator and Spacing"), getJsonString("separator") } );
	mCards.append({ QStringLiteral("ColumnSet"), getJsonString("simpleColumnSet") } );
	mCards.append({ QStringLiteral("ColumnSet With Background Image"), getJsonString("columnSetWithBGImage") } );
	mCards.append({ QStringLiteral("ColumnSet With Bleed"), getJsonString("columnSetWithBleed") } );
	mCards.append({ QStringLiteral("ColumnSet With Bleed Columns"), getJsonString("columnSetWithBleedColumns") } );
	mCards.append({ QStringLiteral("ColumnSet With Min Height"), getJsonString("columnSetWithMinHeight") } );
	mCards.append({ QStringLiteral("ColumnSet With Separator"), getJsonString("columnSetWithSeparator") } );
	mCards.append({ QStringLiteral("ColumnSet With Weighted Width"), getJsonString("columnSetWithWeightedWidth") } );
    mCards.append({ QStringLiteral("Action Open URL"), getJsonString("actionOpenUrl") } );
	mCards.append({ QStringLiteral("Action Submit 1"), getJsonString("actionSubmit") } );
	mCards.append({ QStringLiteral("Flight Iternery"), getJsonString("cardflight") } );
	mCards.append({ QStringLiteral("Weather Card"), getJsonString("cardWeather") } );
	mCards.append({ QStringLiteral("Action Show Card 1"), getJsonString("actionShowCard1") } );
    mCards.append({ QStringLiteral("Action Show Card 2"), getJsonString("actionShowCard2") } );
	mCards.append({ QStringLiteral("Action Toggle Visibility"), getJsonString("actionToggleVisibility") } );
    mCards.append({ QStringLiteral("Action Set"), getJsonString("actionSet") } );
    mCards.append({ QStringLiteral("Select Action - Card"), getJsonString("selectActionCard") } );
    mCards.append({ QStringLiteral("Select Action - Image"), getJsonString("imageSelectAction") } );
    mCards.append({ QStringLiteral("Select Action - TextRun"), getJsonString("textRunSelectAction") } );
    mCards.append({ QStringLiteral("Select Action - Container"), getJsonString("containerSelectAction") } );
    mCards.append({ QStringLiteral("Select Action - ColumnSet"), getJsonString("columnSetSelectAction") } );
    mCards.append({ QStringLiteral("Select Action Image Set"), getJsonString("selectActionImageSet") } );
    mCards.append({ QStringLiteral("Select Action Wizard"), getJsonString("selectActionWiz") } );
    mCards.append({ QStringLiteral("Food order"), getJsonString("cardFoodOrder") } );
    mCards.append({ QStringLiteral("Show card wizard"), getJsonString("showCardWiz") } );
	mCards.append({ QStringLiteral("Toggle Visibility wizard"), getJsonString("toggleVisibilityWiz") } );
	mCards.append({ QStringLiteral("Background Image"), getJsonString("backgroundImage") } );
	mCards.append({ QStringLiteral("Bleed Properties"), getJsonString("bleed") } );
	mCards.append({ QStringLiteral("Input Elements"), getJsonString("inputElements") } );
    mCards.append({ QStringLiteral("Input Validation"), getJsonString("inputValidation") });
    mCards.append({ QStringLiteral("Action Set Alignment"), getJsonString("actionSetHorizontalAlign") });
}

QVector<Card> SampleCardList::cardList() const
{
    return mCards;
}

QString SampleCardList::getJsonString(std::string fileNameWithoutExtension)
{
    const std::string SolutionDir = SOLUTION_DIR;
    const std::string jsonFolder = "Samples\\QmlVisualizer\\JSONSamples\\";
    std::ifstream file(SolutionDir + jsonFolder + fileNameWithoutExtension + ".json");

    std::string content((std::istreambuf_iterator<char>(file)),
        (std::istreambuf_iterator<char>()));

    return QString::fromStdString(content);
}
