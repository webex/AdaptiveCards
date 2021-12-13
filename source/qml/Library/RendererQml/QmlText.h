#pragma once
#include "IQmlBase.h"
#include "QmlItem.h"

class QmlText :
    public QmlItem
{
public:
    explicit QmlText(std::string id, std::shared_ptr<QmlTag> textType, std::string text);
    QmlText() = delete;
    QmlText(const QmlText&) = delete;
    QmlText& operator = (const QmlText&) = delete;
    void setFont(const std::string font) override;
    void setHorizontalAlignment(const std::string horizontalAlignment) override;
    void setVerticalAlignment(const std::string verticalAlignment) override;
    void setLeftPadding(const std::string leftPadding) override;
    void setColor(const std::string color) override;
    void setWrapMode(const std::string wrapMode) override;
    void setElide(const std::string elide) override;
};

