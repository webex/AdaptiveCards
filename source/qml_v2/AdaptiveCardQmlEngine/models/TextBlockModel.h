#pragma once

#include <QObject>
#include <QColor>
#include <QFont>

#include "AdaptiveCardContext.h"
#include "TextBlock.h"

class TextBlockModel : public QObject 
{
    Q_OBJECT
    Q_PROPERTY(QString text MEMBER mText CONSTANT)
    Q_PROPERTY(int maxLines MEMBER mTextMaxLines CONSTANT)
    Q_PROPERTY(bool textWrap MEMBER mTextWrap CONSTANT)

    Q_PROPERTY(QString color MEMBER mColor CONSTANT)
    Q_PROPERTY(QString selectionColor MEMBER mSelectionColor CONSTANT)

    Q_PROPERTY(int fontPixelSize MEMBER mFontPixelSize CONSTANT)
    Q_PROPERTY(QString fontWeight MEMBER mFontWeight CONSTANT)
    Q_PROPERTY(QString fontFamily MEMBER mFontFamily CONSTANT)
    
    Q_PROPERTY(int horizontalAlignment MEMBER mTextHorizontalAlignment CONSTANT)
    Q_PROPERTY(bool isVisible MEMBER mIsVisible CONSTANT)

    Q_PROPERTY(bool isInTabOrder MEMBER mIsInTabOrder CONSTANT)     

public:
    explicit TextBlockModel(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, QObject* parent = nullptr);
    ~TextBlockModel();

private:
    QString mText;
    int mTextMaxLines{INT_MAX};
    bool mTextWrap;

    QString mColor;
    QString mSelectionColor;

    int mFontPixelSize;
    QString mFontWeight;
    QString mFontFamily;

    int mTextHorizontalAlignment;
    bool mIsVisible;
    bool mIsInTabOrder;
};
