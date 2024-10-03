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

    Q_PROPERTY(QString escapedLabelString MEMBER mEscapedLabelString CONSTANT);
    Q_PROPERTY(QString placeHolder MEMBER mPlaceholder CONSTANT);
    Q_PROPERTY(QString escapedErrorString MEMBER mEscapedErrorString CONSTANT);
    Q_PROPERTY(QString spacing MEMBER mSpacing CONSTANT);
    Q_PROPERTY(QString minDate MEMBER mMinDate CONSTANT);
    Q_PROPERTY(QString maxDate MEMBER mMaxDate CONSTANT);
    Q_PROPERTY(QString currentDate MEMBER mCurrentDate CONSTANT);
    Q_PROPERTY(QString dateInputFormat MEMBER mDateInputFormat CONSTANT);
    Q_PROPERTY(QString dateFormat MEMBER mDateFormat CONSTANT);
    Q_PROPERTY(QString InputMask MEMBER mInputMask CONSTANT);
    Q_PROPERTY(QString regex MEMBER mRegex CONSTANT);
    

    Q_PROPERTY(bool visible MEMBER mVisible CONSTANT);
    Q_PROPERTY(bool isRequired MEMBER mIsRequired CONSTANT);
    Q_PROPERTY(bool validationRequired MEMBER mValidationRequired CONSTANT);

    Q_PROPERTY(int minWidth MEMBER mMinWidth CONSTANT);

public:
    explicit DateInputModel(std::shared_ptr<AdaptiveCards::DateInput> dateInput, QObject* parent = nullptr);
    ~DateInputModel();

private:
    void initialize();
    void addDateFormat();
    const AdaptiveCardQmlEngine::InputDateConfig mDateConfig;

private:
    const std::shared_ptr<AdaptiveCards::DateInput>& mDateInput;

    QString mPlaceholder;
    QString mEscapedLabelString;
    QString mEscapedErrorString;
    QString mSpacing;
    QString mMinDate;
    QString mMaxDate;
    QString mCurrentDate;
    QString mDateInputFormat;
    QString mDateFormat;
    QString mInputMask;
    QString mRegex;

    bool mVisible;
    bool mIsRequired;
    bool mValidationRequired;

    int mMinWidth;
};
