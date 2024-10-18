#pragma once
#include "AdaptiveCardContext.h"
#include "ToggleInput.h"

#include <QObject>
#include <QString>
#include <QColor>
#include <QFont>

class ToggleInputModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString escapedLabelString MEMBER mEscapedLabelString CONSTANT);
    Q_PROPERTY(QString escapedErrorString MEMBER mEscapedErrorString CONSTANT);
    Q_PROPERTY(QString spacing MEMBER mSpacing CONSTANT);
    Q_PROPERTY(QString escapedValueOn MEMBER mEscapedValueOn CONSTANT);
    Q_PROPERTY(QString escapedValueOff MEMBER mEscapedValueOff CONSTANT);
    Q_PROPERTY(QString text MEMBER mText CONSTANT);
    Q_PROPERTY(QString cbTitle MEMBER mCbTitle CONSTANT);
    Q_PROPERTY(QString cbisWrap MEMBER mCbisWrap CONSTANT);

    Q_PROPERTY(bool visible MEMBER mVisible CONSTANT);
    Q_PROPERTY(bool isRequired MEMBER mIsRequired CONSTANT);
    Q_PROPERTY(bool cbIsChecked MEMBER mCbIsChecked CONSTANT);

public:
    explicit ToggleInputModel(std::shared_ptr<AdaptiveCards::ToggleInput> dateInput, QObject* parent = nullptr);
    ~ToggleInputModel();

private:
    void initialize();
    void addInputLabel();
    void addCheckBox();

private:
    const std::shared_ptr<AdaptiveCards::ToggleInput>& mToggleInput;

     QString mEscapedLabelString;
     QString mEscapedErrorString;
     QString mSpacing;
     QString mEscapedValueOn;
     QString mEscapedValueOff;
     QString mText;
     QString mCbTitle;
     QString mCbisWrap;

     bool mCbIsChecked{false};
     bool mVisible{false};
     bool mIsRequired{false};

};
