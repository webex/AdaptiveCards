#include "ImageModel.h"
#include "SharedAdaptiveCard.h"
#include <QDebug.h>
#include "Utils.h"
#include "MarkDownParser.h"


ImageModel::ImageModel(std::shared_ptr<AdaptiveCards::Image> image, QObject* parent)
    : QObject(parent),mImage(image)
{
    setImageLayoutProperties();
    setImageVisualProperties();
    setImageActionProperties();
 }

ImageModel::~ImageModel()
 {
 }
     
void ImageModel::setImageLayoutProperties()
{
    const auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();

    // If the image has a pixel width and height, use that else calculate the width and height based on the image size
    if (mImage->GetPixelWidth() != 0 || mImage->GetPixelHeight() != 0)
    {
        mImageHeight = mImage->GetPixelHeight() != 0 ? mImage->GetPixelHeight() : mImage->GetPixelWidth();
        mImageWidth = mImage->GetPixelWidth() != 0 ? mImage->GetPixelWidth() : mImage->GetPixelHeight();
    }
    else
    {
        switch (mImage->GetImageSize())
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
}

void ImageModel::setImageVisualProperties()
{
    mSourceImage = GetImagePath(mImage->GetUrl());
    mVisibleRect = mImage->GetIsVisible();
    mIsImage = true;

     // Image Background Color
    if (!mImage->GetBackgroundColor().empty())
    {
        mBgColor = QString::fromStdString(mImage->GetBackgroundColor());
    }

    // Image Horizontal Alignment
    const auto imageHorizontalAlignment = mImage->GetHorizontalAlignment().value_or(AdaptiveCards::HorizontalAlignment::Left);
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
    switch (mImage->GetImageStyle())
    {
        case AdaptiveCards::ImageStyle::Default:
            break;
        case AdaptiveCards::ImageStyle::Person:
            mRadius = mImageWidth / 2;
            break;
    }
}

void ImageModel::setImageActionProperties()
{
    // To Do: Need to implement the actions
    // Image selection action
    if (mImage->GetSelectAction() != nullptr)
    {
        bool mHoverEnabled = true;
        if (mImage->GetSelectAction()->GetElementTypeString() == "Action.Submit")
        {
            auto submitAction = std::dynamic_pointer_cast<AdaptiveCards::SubmitAction>(mImage->GetSelectAction());
            mActionType = QString::fromStdString(submitAction->GetElementTypeString());
            mSubmitJSON = QString::fromStdString(submitAction->GetDataJson());
            mHasAssociatedInputs = submitAction->GetAssociatedInputs() == AdaptiveCards::AssociatedInputs::Auto ? true : false;
        }
        else if (mImage->GetSelectAction()->GetElementTypeString() == "Action.OpenUrl")
        {
            auto openUrlAction = std::dynamic_pointer_cast<AdaptiveCards::OpenUrlAction>(mImage->GetSelectAction());
            mActionType = QString::fromStdString(openUrlAction->GetElementTypeString());
            mOpenUrl = QString::fromStdString(openUrlAction->GetUrl());
        }
        else if (mImage->GetSelectAction()->GetElementTypeString() == "Action.ToggleVisibility")
        {
            auto toggleVisibilityAction =std::dynamic_pointer_cast<AdaptiveCards::ToggleVisibilityAction>(mImage->GetSelectAction());
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
