#pragma once
#include "IQmlBase.h"

class QmlItem :
    public IQmlBase
{
    std::shared_ptr<QmlTag> mQmlTag;
    const std::string mId;
protected:
    std::shared_ptr<QmlTag>& getQmltag();
public:
    explicit QmlItem(std::string id, std::shared_ptr<QmlTag> qmlTag);
    QmlItem() = delete;
    QmlItem(const QmlItem&) = delete;
    QmlItem& operator = (const QmlItem&) = delete;
    std::shared_ptr<QmlTag> getQmlString() const override;
    std::string getId() const override;
    void setWidth(const std::string width) override;
    void setHeight(const std::string height) override;
    void setImplicitWidth(const std::string implicitWidth) override;
    void setImplicitHeight(const std::string implicitHeight) override;
    void setVisible(const std::string visible) override;
    void addChild(const std::shared_ptr<QmlTag>& childElem) override;
    void setFont(const std::string font) override;
    void setHorizontalAlignment(const std::string horizontalAlignment) override;
    void setVerticalAlignment(const std::string verticalAlignment) override;
    void setLeftPadding(const std::string leftPadding) override;
    void setColor(const std::string color) override;
    void setWrapMode(const std::string wrapMode) override;
    void setElide(const std::string elide) override;
    void setScrollViewHorizontalInteractive(const std::string isHorizontalInteractive) override;
    void setScrollViewVerticalInteractive(const std::string isHorizontalInteractive) override;
    void setScrollViewHorizontalVisible(const std::string visible) override;
    void setBorderColor(const std::string borderColor) override;
    void setBorderWidth(const std::string borderWidth) override;
    void setRadius(const std::string radius) override;
};

