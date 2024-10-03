#pragma once

#include <QObject>
#include <QColor>
#include <QFont>
#include <QRegExp.h>

#include "AdaptiveCardContext.h"
#include "TimeInput.h"

class TimeInputModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString label MEMBER mLabel CONSTANT)
    Q_PROPERTY(QString errorMessage MEMBER mErrorMessage CONSTANT)
    Q_PROPERTY(QString placeholder MEMBER mPlaceHolder CONSTANT)
    Q_PROPERTY(QString value MEMBER mValue CONSTANT)
    Q_PROPERTY(QString inputMask MEMBER mInputMask CONSTANT)

    Q_PROPERTY(QRegExp regex MEMBER mRegex CONSTANT)

    Q_PROPERTY(bool isVisible MEMBER mIsVisible CONSTANT)
    Q_PROPERTY(bool isRequired MEMBER mIsRequired CONSTANT)
    Q_PROPERTY(bool is12hour MEMBER mIs12hour CONSTANT)
    Q_PROPERTY(bool validationRequired MEMBER mValidationRequired CONSTANT);

public:
    explicit TimeInputModel(std::shared_ptr<AdaptiveCards::TimeInput> input, QObject* parent = nullptr);
    ~TimeInputModel();

    Q_INVOKABLE QString minHour() const
    {
        return mMinHour;
    }

    Q_INVOKABLE QString maxHour() const
    {
        return mMaxHour;
    }

    Q_INVOKABLE QString minMinute() const
    {
        return mMinMinute;
    }

    Q_INVOKABLE QString maxMinute() const
    {
        return mMaxMinute;
    }

    Q_INVOKABLE QString currHour() const
    {
        return mCurrHour;
    }

    Q_INVOKABLE QString currMinute() const
    {
        return mCurrMinute;
    }

private:
    const AdaptiveCardQmlEngine::InputTimeConfig mTimeInputConfig;

private:
    QString mLabel;
    QString mErrorMessage;
    QString mPlaceHolder;
    QString mValue;
    QString mInputMask;

    QString mMinHour = "0";
    QString mMaxHour = "23";
    QString mMinMinute = "0";
    QString mMaxMinute = "59";
    QString mCurrHour = "-1";
    QString mCurrMinute = "-1";

    QRegExp mRegex;

    bool mIsVisible{false};
    bool mIsRequired{false};
    bool mIs12hour;
    bool mValidationRequired;
};
