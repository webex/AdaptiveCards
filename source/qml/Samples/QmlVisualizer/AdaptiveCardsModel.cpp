#include "adaptivecardsmodel.h"

AdaptiveCardsModel::AdaptiveCardsModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

int AdaptiveCardsModel::rowCount(const QModelIndex& parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return 1;
}

QVariant AdaptiveCardsModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!

    switch (role)
    {
    case CardString:
        return QVariant(QStringLiteral("import QtQuick 2.15; import QtQuick.Layouts 1.3; Item{ id:adaptiveCard; implicitHeight: adaptiveCardLayout.implicitHeight;width: 600; ColumnLayout{ id: adaptiveCardLayout; width: adaptiveCard.width; Rectangle{ id: adaptiveCardRectangle; color:Qt.rgba(255, 255, 255, 1.00); Layout.margins: 15; Layout.fillWidth:true; Layout.preferredHeight:40; } } }"));
    }

    return QVariant();
}

bool AdaptiveCardsModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (data(index, role) != value) {
        // FIXME: Implement me!
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags AdaptiveCardsModel::flags(const QModelIndex& index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable; // FIXME: Implement me!
}

QHash<int, QByteArray> AdaptiveCardsModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[MessageRole::CardString] = "CardString";
    return names;
}
