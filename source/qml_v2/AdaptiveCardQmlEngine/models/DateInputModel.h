#pragma once
#include "AdaptiveCardContext.h"
#include "DateInput.h"
#include "OpenUrlAction.h"
#include "ToggleVisibilityAction.h"
#include "SubmitAction.h"

#include <QObject>
#include <QString>
#include <QColor>
#include <QFont>

class DateInputModel : public QObject
{
    Q_OBJECT

   

public:
    explicit DateInputModel(std::shared_ptr<AdaptiveCards::DateInput> dateInput, QObject* parent = nullptr);
    ~DateInputModel();

};
