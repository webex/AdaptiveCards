#pragma once
#include "QmlItem.h"

class QmlRectangle :
    public QmlItem
{
public:
    explicit QmlRectangle(std::string id, std::shared_ptr<QmlTag> scrollTag);
    QmlRectangle() = delete;
    QmlRectangle(const QmlRectangle&) = delete;
    QmlRectangle& operator = (const QmlRectangle&) = delete;
    void setBorderColor(const std::string borderColor) override;
    void setBorderWidth(const std::string borderWidth) override;
    void setRadius(const std::string radius) override;
    void setColor(const std::string color) override;
};

