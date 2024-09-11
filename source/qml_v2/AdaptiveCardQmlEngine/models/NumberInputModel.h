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

    Q_PROPERTY(bool visible MEMBER mVisible CONSTANT);
    Q_PROPERTY(QString placeHolder MEMBER mPlaceholder CONSTANT);
    Q_PROPERTY(QString value MEMBER mValue CONSTANT);
    Q_PROPERTY(bool defaultValue MEMBER mDefaultValue CONSTANT);
    Q_PROPERTY(QString minValue MEMBER mMinValue CONSTANT);
    Q_PROPERTY(QString maxValue MEMBER mMaxValue CONSTANT);
    Q_PROPERTY(QString escapedLabelString MEMBER mEscapedLabelString CONSTANT);

public:
    explicit NumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, QObject* parent = nullptr);
    ~NumberInputModel();

private:
    void createInputLabel();
    const std::shared_ptr<AdaptiveCards::NumberInput>& mInput;

private:
    bool mVisible;
    QString mPlaceholder;
    QString mValue;
    bool mDefaultValue;
    QString mMinValue;
    QString mMaxValue;
    QString mEscapedLabelString;
};
