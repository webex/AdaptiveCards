#pragma once

#include <QObject>
#include "SharedAdaptiveCard.h" 

class AdaptiveCardModel  : public QObject
{
    Q_OBJECT
public:
    explicit AdaptiveCardModel(std::shared_ptr<AdaptiveCards::AdaptiveCard> mainCard, QObject* parent = nullptr);
    ~AdaptiveCardModel();

private:
    void populateCardBody();

private:
    
    std::shared_ptr<AdaptiveCards::AdaptiveCard> mMainCard;
};
