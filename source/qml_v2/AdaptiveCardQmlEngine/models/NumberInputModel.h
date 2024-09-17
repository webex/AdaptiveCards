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

    Q_PROPERTY(QString placeHolder MEMBER mPlaceholder CONSTANT);
    Q_PROPERTY(QString escapedLabelString MEMBER mEscapedLabelString CONSTANT);
    Q_PROPERTY(QString defaultValue MEMBER mDefaultValue CONSTANT);
    Q_PROPERTY(QString escapedErrorString MEMBER mEscapedErrorString CONSTANT);

    Q_PROPERTY(double minValue MEMBER mMinValue CONSTANT);
    Q_PROPERTY(double maxValue MEMBER mMaxValue CONSTANT);

    Q_PROPERTY(bool visible MEMBER mVisible CONSTANT);
    Q_PROPERTY(bool isRequired MEMBER mIsRequired CONSTANT);
    Q_PROPERTY(bool validationRequired MEMBER mValidationRequired CONSTANT);

    Q_PROPERTY(int value MEMBER mValue CONSTANT);

public:
    explicit NumberInputModel(std::shared_ptr<AdaptiveCards::NumberInput> numberInput, QObject* parent = nullptr);
    ~NumberInputModel();

private:
    void initialize();
    void createInputLabel();
    void createErrorMessage();

private:
    const std::shared_ptr<AdaptiveCards::NumberInput>& mInput;

    QString mPlaceholder;
    QString mEscapedLabelString;
    QString mDefaultValue;
    QString mEscapedErrorString;

    double mMinValue;
    double mMaxValue;

    bool mVisible;
    bool mIsRequired;
    bool mValidationRequired;

    int mValue;
};
