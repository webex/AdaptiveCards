#pragma once
#include "AdaptiveCardContext.h"
#include "Image.h"
#include "OpenUrlAction.h"
#include "ToggleVisibilityAction.h"
#include "SubmitAction.h"

#include <QObject>
#include <QString>
#include <QColor>
#include <QFont>

class ImageModel : public QObject
{
	Q_OBJECT
    
    Q_PROPERTY(QString sourceImage MEMBER mSourceImage CONSTANT);
    Q_PROPERTY(QString bgColor MEMBER mBgColor CONSTANT);
    Q_PROPERTY(QString anchorCenter MEMBER mAnchorCenter CONSTANT);
    Q_PROPERTY(QString anchorRight MEMBER mAnchorRight CONSTANT);
    Q_PROPERTY(QString anchorLeft MEMBER mAnchorLeft CONSTANT);

    Q_PROPERTY(QString actionType MEMBER mActionType CONSTANT);
    Q_PROPERTY(QString submitData MEMBER mSubmitJSON CONSTANT);
    Q_PROPERTY(QString openUrl MEMBER mOpenUrl CONSTANT);

    Q_PROPERTY(bool hasAssociatedInputs MEMBER mHasAssociatedInputs CONSTANT);
    Q_PROPERTY(bool visibleRect MEMBER mVisibleRect CONSTANT);
    Q_PROPERTY(bool isImage MEMBER mIsImage CONSTANT);
    Q_PROPERTY(bool toggleVisibility MEMBER mToggleVisibility CONSTANT);
    
    Q_PROPERTY(int imageHeight MEMBER mImageHeight CONSTANT);
    Q_PROPERTY(int imageWidth MEMBER mImageWidth CONSTANT);
    Q_PROPERTY(int radius MEMBER mRadius CONSTANT);

public:
    explicit ImageModel(std::shared_ptr<AdaptiveCards::Image> image, QObject* parent = nullptr);
    ~ImageModel();

private:
    QString GetImagePath(const std::string url);

private :
    QString mSourceImage;
    QString mBgColor;
    QString mAnchorCenter;
    QString mAnchorRight;
    QString mAnchorLeft;

    QString mActionType;
    QString mSubmitJSON;
    QString mOpenUrl;

    bool mHasAssociatedInputs; 
    bool mVisibleRect;
    bool mIsImage;
    bool mToggleVisibility;

    int mImageHeight;
    int mImageWidth;
    int mRadius;
};
