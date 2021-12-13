#pragma once
#include "QmlItem.h"
class QmlTextEdit :
    public QmlItem
{
public:
    explicit QmlTextEdit(std::string id, std::shared_ptr<QmlTag> textEditType);
    QmlTextEdit() = delete;
    QmlTextEdit(const QmlTextEdit&) = delete;
    QmlTextEdit& operator = (const QmlTextEdit&) = delete;
    void setColor(const std::string color) override;
    void setWrapMode(const std::string wrapMode);
    void setSelectByMouse(const std::string selectbyMouse);
    void setSelectedTextColor(const std::string selectedTextColor);
    void setTopPadding(const std::string topPadding);
    void setBottomPadding(const std::string bottomPadding);
    void setLeftPadding(const std::string leftPadding);
    void setRightPadding(const std::string rightPadding);
};

