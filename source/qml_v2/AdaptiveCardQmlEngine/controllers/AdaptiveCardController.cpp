#include "AdaptiveCardController.h"
#include "AdaptiveCardEnums.h"
#include "AdaptiveCardContext.h"


AdaptiveCardController::AdaptiveCardController(QObject* parent)
	: QObject(parent)
	, mAdaptiveCardModel(nullptr)
{
	// Initializing context
    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().initAdaptiveCardContext();

	// Initializing card theme 
	setCardTheme((int)AdaptiveCardEnums::AdaptiveCardTheme::DarkTheme);

	// Intializing card model
	initAdaptiveCardModel();
}

AdaptiveCardController::~AdaptiveCardController()
{
}

void AdaptiveCardController::setCardJSON(const QString& cardJSON)
{
	initAdaptiveCardModel(cardJSON);
}

QString AdaptiveCardController::getCardJSON() const
{
	return mCardJSON;
}

void AdaptiveCardController::setCardTheme(int selectionIndex)
{
	AdaptiveCardEnums::AdaptiveCardTheme theme = static_cast<AdaptiveCardEnums::AdaptiveCardTheme>(selectionIndex);
    AdaptiveCardQmlEngine::AdaptiveCardContext::getInstance().setAdaptiveCardTheme(theme);
}

void AdaptiveCardController::initAdaptiveCardModel(const QString& cardJSON)
{
	const QString defaultCardJSON = "{\"type\":\"AdaptiveCard\",\"$schema\":\"http://adaptivecards.io/schemas/adaptive-card.json\",\"version\":\"1.5\",\"body\":[]}";
    const QString newCardJSON = cardJSON.isEmpty() ? defaultCardJSON : cardJSON;

	std::shared_ptr<AdaptiveCards::ParseResult> mainCard = AdaptiveCards::AdaptiveCard::DeserializeFromString(newCardJSON.toStdString(), "2.0");
	mAdaptiveCardModel = new AdaptiveCardModel(mainCard->GetAdaptiveCard(), this);

	emit adaptiveCardModelChanged();
}
