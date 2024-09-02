#pragma once

#include <QObject>
#include <QColor>
#include <QFont>

#include "AdaptiveCardContext.h"
#include "RichTextBlock.h"
#include "TextRun.h"

class RichTextBlockModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text MEMBER mText CONSTANT)
 
    Q_PROPERTY(bool textWrap MEMBER mTextWrap CONSTANT)

    Q_PROPERTY(QString color MEMBER mColor CONSTANT)
    Q_PROPERTY(QString selectionColor MEMBER mSelectionColor CONSTANT)

    Q_PROPERTY(int fontPixelSize MEMBER mFontPixelSize CONSTANT)
    Q_PROPERTY(QString fontWeight MEMBER mFontWeight CONSTANT)
    Q_PROPERTY(QString fontFamily MEMBER mFontFamily CONSTANT)

    Q_PROPERTY(int horizontalAlignment MEMBER mTextHorizontalAlignment CONSTANT)
    Q_PROPERTY(bool isVisible MEMBER mIsVisible CONSTANT)

    Q_PROPERTY(bool textUnderlineDecoration MEMBER mTextUnderlineDecoration CONSTANT)
    Q_PROPERTY(bool textStrikethroughDecoration MEMBER mTextStrikethroughDecoration CONSTANT)
 
public:
    explicit RichTextBlockModel(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, QObject* parent = nullptr);
    ~RichTextBlockModel();

private:
    QString textRunRender (const std::shared_ptr<AdaptiveCards::TextRun>& textRun,const std::string& selectaction);

private:
    QString mText;
    bool mTextWrap;

    QString mColor;
    QString mSelectionColor;
    QString mBackgroundColor;

    int mFontPixelSize;
    QString mFontWeight;
    QString mFontFamily;

    int mTextHorizontalAlignment;
    bool mIsVisible;
 
    QString mTextRun_all;
    bool mTextUnderlineDecoration;
    bool mTextStrikethroughDecoration;

};
