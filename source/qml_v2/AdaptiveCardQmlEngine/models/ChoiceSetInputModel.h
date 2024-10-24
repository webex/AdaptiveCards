#pragma once
#include "AdaptiveCardContext.h"
#include "ChoiceSetInput.h"
#include "OpenUrlAction.h"
#include "ToggleVisibilityAction.h"
#include "SubmitAction.h"

#include <QObject>
#include <QString>
#include <QColor>
#include <QFont>

class ChoiceSetInputModel : public QObject
{
    Q_OBJECT

public:
    explicit ChoiceSetInputModel(std::shared_ptr<AdaptiveCards::ChoiceSetInput> choiceSetInput, QObject* parent = nullptr);
    ~ChoiceSetInputModel();
};
