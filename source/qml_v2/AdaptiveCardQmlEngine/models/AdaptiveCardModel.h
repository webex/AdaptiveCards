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
  
    Q_PROPERTY(Qt::AlignmentFlag verticalAlignment MEMBER mVerticalAlignment CONSTANT)
    Q_PROPERTY(CollectionItemModel* cardBodyModel MEMBER mCardBody CONSTANT)

    Q_PROPERTY(QString backgroundColor MEMBER mBackgroundColor CONSTANT)  
    Q_PROPERTY(QString backgroundImageSource MEMBER mBackgroundImageSource CONSTANT)  
    Q_PROPERTY(QString fillMode MEMBER mFillMode CONSTANT)
    Q_PROPERTY(QString imageHorizontalAlignment MEMBER mImageHorizontalAlignment CONSTANT)
    Q_PROPERTY(QString imageVerticalAlignment MEMBER mImageVerticalAlignment CONSTANT)

    Q_PROPERTY(bool hasBackgroundImage MEMBER mHasBackgroundImage CONSTANT)

    Q_PROPERTY(int minHeight MEMBER mMinHeight CONSTANT)
    
public:
    explicit AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject* parent = nullptr);
    ~AdaptiveCardModel();

private:
    QString AdaptiveCardModel::getImagePath(const std::string url);

    void populateCardBody();
    void setupBaseCardProperties();

private:
    std::shared_ptr<AdaptiveCards::AdaptiveCard> mMainCard;

    Qt::AlignmentFlag mVerticalAlignment;
    CollectionItemModel* mCardBody;

    QString mBackgroundColor;
    QString mBackgroundImageSource;  
    QString mFillMode;
    QString mImageHorizontalAlignment;
    QString mImageVerticalAlignment;

    bool mHasBackgroundImage;

    int mMinHeight;
};
