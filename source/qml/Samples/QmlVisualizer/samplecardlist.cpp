#include "samplecardlist.h"
#include "SampleCardJson.h"

SampleCardList::SampleCardList(QObject *parent) : QObject(parent)
{
    mCards.append({ QStringLiteral("Empty card"), QString::fromStdString(Samples::card_Empty) });
    mCards.append({ QStringLiteral("TextBlock"), QString::fromStdString(Samples::card_TextBlock) });
    mCards.append({ QStringLiteral("Rich text"), QString::fromStdString(Samples::card_richText) });
    mCards.append({ QStringLiteral("Input text"), QString::fromStdString(Samples::card_InputText) });
    mCards.append({ QStringLiteral("Input number"), QString::fromStdString(Samples::card_InputNumber) });
    mCards.append({ QStringLiteral("Input date"), QString::fromStdString(Samples::card_dateInput) });
    mCards.append({ QStringLiteral("Input Toggle"), QString::fromStdString(Samples::card_CheckboxInput) });
    mCards.append({ QStringLiteral("Input ChoiceSet"), QString::fromStdString(Samples::card_ChoiceSetInput) });
}

QVector<Card> SampleCardList::cardList() const
{
    return mCards;
}
