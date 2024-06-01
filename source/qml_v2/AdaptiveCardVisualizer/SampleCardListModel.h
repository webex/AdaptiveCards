#pragma once

#include <QAbstractListModel>
#include <QVector>

using CardData = QMap<int, QVariant>;
class SampleCardListModel  : public QAbstractListModel
{
	Q_OBJECT
    enum
    {
        CardFileNameRole = Qt::UserRole,
        CardDisplayNameRole,
        CardJSONStringRole
    };

public:
	explicit SampleCardListModel(QObject *parent);
	~SampleCardListModel();

    // Basic functionality:
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    void populateCardData();
    void populateCardDisplayNames();
    QString getDisplayName(const QString& fileName) const;  

	QVector<CardData> mCardData;
    QMap<QString, QString> mCardDisplayNames;
};
