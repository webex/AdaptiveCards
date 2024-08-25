#include "ImageModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"


ImageModel::ImageModel(std::shared_ptr<AdaptiveCards::Image> image, QObject* parent)
    : QObject(parent),
    mSourceImage(""), mImageHeight(0), mImageWidth(0), mRadius(0),
    mIsImage(false), mVisibleRect(false), mBgColor("transparent"),
    mAnchorCenter(""), mAnchorRight(""), mAnchorLeft("")
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();
    const auto rendererConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getCardConfig();

    mSourceImage = GetImagePath(image->GetUrl());
    mVisibleRect = image->GetIsVisible();
    mIsImage = true;

    // If the image has a pixel width and height, use that else calculate the width and height based on the image size
    if (image->GetPixelWidth() != 0 || image->GetPixelHeight() != 0)
    {
        mImageHeight = image->GetPixelHeight() != 0 ? image->GetPixelHeight() : image->GetPixelWidth();
        mImageWidth = image->GetPixelWidth() != 0 ? image->GetPixelWidth() : image->GetPixelHeight();
    }
    else 
    {
        switch (image->GetImageSize())
        {
        case AdaptiveCards::ImageSize::None:
        case AdaptiveCards::ImageSize::Auto:
        case AdaptiveCards::ImageSize::Small:

            mImageWidth = hostConfig->GetImageSizes().smallSize;
            mImageHeight = hostConfig->GetImageSizes().smallSize;
            break;

        case AdaptiveCards::ImageSize::Medium:

            mImageWidth = hostConfig->GetImageSizes().mediumSize;
            mImageHeight = hostConfig->GetImageSizes().mediumSize;
            break;

        case AdaptiveCards::ImageSize::Large:
            mImageWidth = hostConfig->GetImageSizes().largeSize;
            mImageHeight = hostConfig->GetImageSizes().largeSize;
            break;
        }

    }

    // Image Background Color
    if (!image->GetBackgroundColor().empty())
    {
        mBgColor = QString::fromStdString(image->GetBackgroundColor()); 
    }

    // Image Horizontal Alignment
    const auto imageHorizontalAlignment = image->GetHorizontalAlignment().value_or(AdaptiveCards::HorizontalAlignment::Left);
    switch (imageHorizontalAlignment)
    {
    case AdaptiveCards::HorizontalAlignment::Left:
        mAnchorLeft = "left";
		break;
    case AdaptiveCards::HorizontalAlignment::Center:
        mAnchorCenter = "center";
        break;
    case AdaptiveCards::HorizontalAlignment::Right:
        mAnchorRight = "right";
        break;
    default:
        mAnchorLeft = "left";
        break;
    }

    // Image Style
    switch (image->GetImageStyle())
    {
    case AdaptiveCards::ImageStyle::Default:
        break;
    case AdaptiveCards::ImageStyle::Person:
        mRadius = mImageWidth/2;
        break;
    }

    // To Do: Need to implement the actions
    // Image selection action
    if (image->GetSelectAction() != nullptr)
    {
        bool mHoverEnabled = true;
        if (image->GetSelectAction()->GetElementTypeString() == "Action.Submit")
        {
             auto submitAction = std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(image->GetSelectAction());
             mActionType  = QString::fromStdString(submitAction->GetElementTypeString());
             mSubmitJSON = QString::fromStdString(submitAction->GetDataJson());
             mHasAssociatedInputs = submitAction->GetAssociatedInputs() == AdaptiveCards::AssociatedInputs::Auto ? true : false;
        }
        else if (image->GetSelectAction()->GetElementTypeString() == "Action.OpenUrl")
        {
            auto openUrlAction = std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(image->GetSelectAction());
            mActionType = QString::fromStdString(openUrlAction->GetElementTypeString());
            mOpenUrl = QString::fromStdString(openUrlAction->GetUrl());
        }
        else if (image->GetSelectAction()->GetElementTypeString() == "Action.ToggleVisibility")
        {
            auto toggleVisibilityAction = std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(image->GetSelectAction());
            mActionType = QString::fromStdString(toggleVisibilityAction->GetElementTypeString());
            mToggleVisibility = !mToggleVisibility;
        }
    } 
}

QString ImageModel::GetImagePath(const std::string url)
{
    // To Do: Need to download the file and save it in a local forder called "images" first.
    //        For now images are saved manually prior to render the image from local path.

    // Extracting the file name from the url
    QString newUrl = QString::fromStdString(url);
    const auto imageName = newUrl.split("://").at(1).split("/").last().split(".").first() + ".jpg";

    // Setting up the local path for the image
    QString file_path = __FILE__;
    QString dir_path = file_path.left(file_path.lastIndexOf("\\models"));
    dir_path.append("\\images\\" + imageName);
    std::replace(dir_path.begin(), dir_path.end(), '\\', '/');
    dir_path = "file:/" + dir_path;

    return dir_path;
}

ImageModel::~ImageModel()
{
}
