#include <QAbstractListModel>

class AdaptiveCardsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit AdaptiveCardsModel(QObject* parent = nullptr);

    enum MessageRole
    {
        CardString = Qt::UserRole
    };

    // Basic functionality:
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;

    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex& index, const QVariant& value,
        int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

private:
};
