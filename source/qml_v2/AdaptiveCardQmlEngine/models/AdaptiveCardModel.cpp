#include "AdaptiveCardModel.h"


AdaptiveCardModel::AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject *parent)
	: QObject(parent)
	, mMainCard(mainCard)
	, mCardBody(nullptr)
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

    // Card Background color
    auto hostConfig = AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().getHostConfig();
    mBackgroundColor  = QString::fromStdString(hostConfig->GetContainerStyles().defaultPalette.backgroundColor);
}
