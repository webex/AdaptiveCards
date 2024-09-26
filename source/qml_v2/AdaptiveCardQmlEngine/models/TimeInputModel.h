#pragma once

#include <QObject>
#include <QColor>
#include <QFont>

#include "AdaptiveCardContext.h"
#include "TimeInput.h"

class TimeInputModel : public QObject
{
    Q_OBJECT

	public:
    explicit TimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, QObject* parent = nullptr);
    ~TimeInputModel();
};


