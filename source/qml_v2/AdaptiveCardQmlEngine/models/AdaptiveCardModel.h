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
    Q_PROPERTY(bool hasBackgroundImage MEMBER mHasBackgroundImage CONSTANT)
    Q_PROPERTY(QString backgroundImageSource MEMBER mBackgroundImageSource CONSTANT)
    Q_PROPERTY(CollectionItemModel* cardBodyModel MEMBER mCardBody CONSTANT)
    Q_PROPERTY(QString fillMode MEMBER mFillMode CONSTANT)
    Q_PROPERTY(QString imageHorizontalAlignment MEMBER mImageHorizontalAlignment CONSTANT)
    Q_PROPERTY(QString imageVerticalAlignment MEMBER mImageVerticalAlignment CONSTANT) 
  
public:
    explicit AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject* parent = nullptr);
    ~AdaptiveCardModel();

private:
    void populateCardBody();
    void setupBaseCardProperties();

    QString AdaptiveCardModel::getImagePath(const std::string url);

private:
    int mMinHeight;

    QString mBackgroundColor;
    QString mBackgroundImageSource;
    bool mHasBackgroundImage;
    QString mFillMode;
    QString mImageHorizontalAlignment;
    QString mImageVerticalAlignment;

    Qt::AlignmentFlag mVerticalAlignment;
    std::shared_ptr<AdaptiveCards::AdaptiveCard> mMainCard;
    CollectionItemModel* mCardBody;
};
