#include "samplecardmodel.h"
#include "samplecardlist.h"

SampleCardModel::SampleCardModel(QObject *parent)
    : QAbstractListModel(parent)
    , mList(nullptr)
{
}

int SampleCardModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !mList)
        return 0;

    return mList->cardList().size();
}

QVariant SampleCardModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !mList)
        return QVariant(QStringLiteral("error"));

    const Card card = mList->cardList().at(index.row());

    switch (role)
    {
    case CardNameRole:
        return QVariant(card.CardName);
    case CardJsonString:
        return QVariant(card.CardJson);
    }
    return QVariant();
}

QHash<int, QByteArray> SampleCardModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[CardNameRole] = "CardName";
    names[CardJsonString] = "CardJson";
    return names;
}

SampleCardList *SampleCardModel::list() const
{
    return mList;
}

void SampleCardModel::setList(SampleCardList *list)
{
    beginResetModel();

    if(mList)
    {
        mList->disconnect(this);
    }
    mList = list;

    endResetModel();
}
