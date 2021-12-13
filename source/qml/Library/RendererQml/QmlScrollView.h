#pragma once
#include "QmlItem.h"

class QmlScrollView :
    public QmlItem
{
public:
    explicit QmlScrollView(std::string id, std::shared_ptr<QmlTag> scrollTag);
    QmlScrollView() = delete;
    QmlScrollView(const QmlScrollView&) = delete;
    QmlScrollView& operator = (const QmlScrollView&) = delete;
    void setScrollViewHorizontalInteractive(const std::string isHorizontalInteractive) override;
    void setScrollViewVerticalInteractive(const std::string isHorizontalInteractive) override;
    void setScrollViewHorizontalVisible(const std::string visible) override;
};

