#pragma once

#include <QObject>
#include <QColor>
#include <QFont>

#include "AdaptiveCardContext.h"
#include "TextInput.h"

class TextInputModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isVisible MEMBER mIsVisible CONSTANT)
    Q_PROPERTY(bool isRequired MEMBER mIsRequired CONSTANT)
    Q_PROPERTY(QString label MEMBER mLabel CONSTANT)
    Q_PROPERTY(QString errorMessage MEMBER mErrorMessage CONSTANT)
    Q_PROPERTY(QString placeholder MEMBER mPlaceHolder CONSTANT)
    Q_PROPERTY(QString value MEMBER mValue CONSTANT)
    Q_PROPERTY(int maxLength MEMBER mMaxLength CONSTANT)
    Q_PROPERTY(QString regex MEMBER mRegex CONSTANT)
    Q_PROPERTY(bool heightStreched MEMBER mHeightStreched CONSTANT)

public:
    explicit TextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, QObject* parent = nullptr);
    ~TextInputModel();

private:
    bool mIsVisible;
    bool mIsRequired;

    QString mLabel;
    QString mErrorMessage;
    QString mPlaceHolder;
    QString mValue;

    int mMaxLength;
    QString mRegex;
    bool mHeightStreched;
    
};
