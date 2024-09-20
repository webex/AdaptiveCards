#pragma once

#include <QObject>
#include <QColor>
#include <QFont>

#include "AdaptiveCardContext.h"
#include "TextInput.h"

class TextInputModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString label MEMBER mLabel CONSTANT)
    Q_PROPERTY(QString errorMessage MEMBER mErrorMessage CONSTANT)
    Q_PROPERTY(QString placeholder MEMBER mPlaceHolder CONSTANT)
    Q_PROPERTY(QString value MEMBER mValue CONSTANT)
    Q_PROPERTY(QString regex MEMBER mRegex CONSTANT)

    Q_PROPERTY(bool isVisible MEMBER mIsVisible CONSTANT)
    Q_PROPERTY(bool isRequired MEMBER mIsRequired CONSTANT)
    Q_PROPERTY(bool heightStreched MEMBER mHeightStreched CONSTANT)
    Q_PROPERTY(bool isMultiLineText MEMBER mIsMultiLineText CONSTANT)

    Q_PROPERTY(int maxLength MEMBER mMaxLength CONSTANT)

public:
    explicit TextInputModel(std::shared_ptr<AdaptiveCards::TextInput> input, QObject* parent = nullptr);
    ~TextInputModel();

private:

    void setVisualProperties(const std::shared_ptr<AdaptiveCards::TextInput>& input);

private:
    QString mLabel;
    QString mErrorMessage;
    QString mPlaceHolder;
    QString mValue;
    QString mRegex;

    bool mIsVisible{false};
    bool mIsRequired{false};
    bool mHeightStreched{false};
    bool mIsMultiLineText{false};

    int mMaxLength{0};
};
