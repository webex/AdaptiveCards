#pragma once
#include <QObject>

#include "MarkDownParser.h"
#include "ParseResult.h"
#include "SharedAdaptiveCard.h"

#include "../models/AdaptiveCardModel.h"

class AdaptiveCardController : public QObject 
{
	Q_OBJECT

	Q_PROPERTY(AdaptiveCardModel* adaptiveCardModel MEMBER mAdaptiveCardModel NOTIFY adaptiveCardModelChanged)
    Q_PROPERTY(QString cardJSON MEMBER mCardJSON WRITE setCardJSON)
    Q_PROPERTY(int minHeight MEMBER mMinHeight CONSTANT)
    Q_PROPERTY(Qt::AlignmentFlag verticalAlignment MEMBER mVerticalAlignment CONSTANT)

public:
	explicit AdaptiveCardController(QObject* parent  =  nullptr);
	~AdaptiveCardController();

public slots:
	Q_INVOKABLE void setCardJSON(const QString& cardJSON);
    Q_INVOKABLE QString getCardJSON() const;
    Q_INVOKABLE void setCardTheme(int selectionIndex);

signals:
	void adaptiveCardModelChanged();

private:
	void initAdaptiveCardModel(const QString& cardJSON = QString());

private:
    int mMinHeight;
    QString mCardJSON;

	Qt::AlignmentFlag mVerticalAlignment;
	AdaptiveCardModel* mAdaptiveCardModel;
};
