#include "AdaptiveCardController.h"


AdaptiveCardController::AdaptiveCardController(QObject* parent)
	: QObject(parent)
	, mAdaptiveCardModel(nullptr)
{
	initAdaptiveCardModel();
}

AdaptiveCardController::~AdaptiveCardController()
{
}

void AdaptiveCardController::setCardJSON(const QString& cardJSON)
{
	initAdaptiveCardModel(cardJSON);
}

void AdaptiveCardController::initAdaptiveCardModel(const QString& cardJSON)
{
	const QString defaultCardJSON = "{\"type\":\"AdaptiveCard\",\"$schema\":\"http://adaptivecards.io/schemas/adaptive-card.json\",\"version\":\"1.5\",\"body\":[]}";
    const QString newCardJSON = cardJSON.isEmpty() ? defaultCardJSON : cardJSON;
	
	std::shared_ptr<AdaptiveCards::ParseResult> mainCard = AdaptiveCards::AdaptiveCard::DeserializeFromString(newCardJSON.toStdString(), "2.0");
	mAdaptiveCardModel = new AdaptiveCardModel(mainCard->GetAdaptiveCard(), this);

	emit adaptiveCardModelChanged();
}
