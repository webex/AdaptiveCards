#pragma once
#include "QmlItem.h"
class QmlTextField :
    public QmlItem
{
public:
    explicit QmlTextField(std::string id, std::shared_ptr<QmlTag> textFieldTag);
    QmlTextField() = delete;
    QmlTextField(const QmlTextField&) = delete;
    QmlTextField& operator = (const QmlTextField&) = delete;
};

