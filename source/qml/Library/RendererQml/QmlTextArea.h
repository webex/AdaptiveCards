#pragma once
#include "QmlTextEdit.h"
class QmlTextArea :
    public QmlTextEdit
{
public:
    explicit QmlTextArea(std::string id, std::shared_ptr<QmlTag> textAreaType);
    QmlTextArea() = delete;
    QmlTextArea(const QmlTextArea&) = delete;
    QmlTextArea& operator = (const QmlTextArea&) = delete;
    void setPlaceHolderColor(const std::string placeHolderColor);
};

