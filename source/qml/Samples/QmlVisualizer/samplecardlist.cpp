#include "samplecardlist.h"

SampleCardList::SampleCardList(QObject *parent) : QObject(parent)
{
    mCards.append({ QStringLiteral("card1"), QStringLiteral("Card Json 1") });
    mCards.append({ QStringLiteral("card2"), QStringLiteral("Card Json 2") });
    mCards.append({ QStringLiteral("card3"), QStringLiteral("Card Json 3") });
    mCards.append({ QStringLiteral("card4"), QStringLiteral("Card Json 4") });
}

QVector<Card> SampleCardList::cardList() const
{
    return mCards;
}
