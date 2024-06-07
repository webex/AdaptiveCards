#include "AdaptiveCardModel.h"

AdaptiveCardModel::AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject *parent)
	: QObject(parent)
	, mMainCard(mainCard)
{
	populateCardBody();
}

AdaptiveCardModel::~AdaptiveCardModel()
{
}

void AdaptiveCardModel::populateCardBody()
{
}
