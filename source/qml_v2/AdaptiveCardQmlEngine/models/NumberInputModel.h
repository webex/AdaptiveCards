#pragma once
#include "AdaptiveCardContext.h"
#include "NumberInput.h"
#include "OpenUrlAction.h"
#include "ToggleVisibilityAction.h"
#include "SubmitAction.h"

#include <QObject>
#include <QString>
#include <QColor>
#include <QFont>

class NumberInputModel : public QObject
{
    Q_OBJECT

public:
    explicit NumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, QObject* parent = nullptr);
    ~NumberInputModel();

};
