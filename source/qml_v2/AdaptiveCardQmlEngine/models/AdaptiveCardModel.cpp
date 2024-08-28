#include "AdaptiveCardModel.h"
#include "Enums.h"

AdaptiveCardModel::AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject *parent)
	: QObject(parent)
	, mMainCard(mainCard)
	, mCardBody(nullptr)
    , mHasBackgroundImage(false)
{
	populateCardBody();
}

AdaptiveCardModel::~AdaptiveCardModel()
{
}

void AdaptiveCardModel::populateCardBody()
{
    std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>> cardBodyWithActions;
    for (auto& element : mMainCard->GetBody())
    {
        cardBodyWithActions.emplace_back(element);
    }

    // Card Body
    mCardBody = new CollectionItemModel(cardBodyWithActions, this);

    // Card minimum height
    mMinHeight = mMainCard->GetMinHeight();

    // Card Vertical Content Alignment
    switch (mMainCard->GetVerticalContentAlignment())
    {
    case AdaptiveCards::VerticalContentAlignment::Top:
        mVerticalAlignment = Qt::AlignTop;
        break;
    case AdaptiveCards::VerticalContentAlignment::Center:
        mVerticalAlignment = Qt::AlignVCenter;
        break;
    case AdaptiveCards::VerticalContentAlignment::Bottom:
        mVerticalAlignment = Qt::AlignBottom;
        break;
    }

    setupBaseCardProperties();
}

void AdaptiveCardModel::setupBaseCardProperties()
{
	auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();

    mBackgroundColor = QString::fromStdString(hostConfig->GetContainerStyles().defaultPalette.backgroundColor);

    mHasBackgroundImage = false;
    mBackgroundImageSource = "";

    if (mMainCard->GetBackgroundImage() != nullptr && mMainCard->GetBackgroundImage()->GetUrl() != "")
    {
        mHasBackgroundImage = true;
        mBackgroundImageSource = getImagePath(mMainCard->GetBackgroundImage()->GetUrl());

        mImageHorizontalAlignment = QString::fromStdString(AdaptiveCards::EnumHelpers::getHorizontalAlignmentEnum().toString(mMainCard->GetBackgroundImage()->GetHorizontalAlignment()));
        mImageVerticalAlignment = QString::fromStdString(AdaptiveCards::EnumHelpers::getVerticalAlignmentEnum().toString(mMainCard->GetBackgroundImage()->GetVerticalAlignment()));

        const auto fillMode = mMainCard->GetBackgroundImage()->GetFillMode();
        switch (fillMode)
        {
        case AdaptiveCards::ImageFillMode::Cover:
        {
            mFillMode = "PreserveAspectCrop";
            break;
        }
        case AdaptiveCards::ImageFillMode::RepeatHorizontally:
        {
            mFillMode = "TileHorizontally";
            break;
        }
        case AdaptiveCards::ImageFillMode::RepeatVertically:
        {
            mFillMode = "TileVertically";
            break;
        }
        case AdaptiveCards::ImageFillMode::Repeat:
        {
            mFillMode = "Tile";
            break;
        }
        default:
            break;
        }

    };
}

QString AdaptiveCardModel::getImagePath(const std::string url)
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
