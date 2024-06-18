#pragma once

#include <QObject>
#include "SharedAdaptiveCard.h"

#include "AdaptiveCardContext.h"
#include "HostConfig.h"
#include "AdaptiveCardConfig.h"

#include "CollectionItemModel.h" 

class AdaptiveCardModel  : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int minHeight MEMBER mMinHeight CONSTANT)
    Q_PROPERTY(Qt::AlignmentFlag verticalAlignment MEMBER mVerticalAlignment CONSTANT)
    Q_PROPERTY(QString  backgroundColor MEMBER mBackgroundColor CONSTANT)
    Q_PROPERTY(CollectionItemModel* cardBodyModel MEMBER mCardBody CONSTANT)
    
    
public:
    explicit AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject* parent = nullptr);
    ~AdaptiveCardModel();

private:
    void populateCardBody();

private:
    int mMinHeight;
    QString mBackgroundColor;

    Qt::AlignmentFlag mVerticalAlignment;
    std::shared_ptr<AdaptiveCards::AdaptiveCard> mMainCard;
    CollectionItemModel* mCardBody;
};
