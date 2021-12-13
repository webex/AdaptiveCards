#pragma once
#include <memory>
#include "QmlTag.h"

using namespace RendererQml;
class IQmlBase
{
public :
    virtual std::string getId() const = 0;
	virtual std::shared_ptr<QmlTag> getQmlString() const = 0;
    virtual void setWidth(const std::string width) = 0;
    virtual void setHeight(const std::string height) = 0;
    virtual void setImplicitWidth(const std::string implicitWidth) = 0;
    virtual void setImplicitHeight(const std::string implicitHeight) = 0;
    virtual void setFont(const std::string font) = 0;
    virtual void setHorizontalAlignment(const std::string horizontalAlignment) = 0;
    virtual void setVerticalAlignment(const std::string verticalAlignment) = 0;
    virtual void setLeftPadding(const std::string leftPadding) = 0;
    virtual void setColor(const std::string color) = 0;
    virtual void setWrapMode(const std::string wrapMode) = 0;
    virtual void setElide(const std::string elide) = 0;
    virtual void setVisible(const std::string visible) = 0;
    virtual void setScrollViewHorizontalInteractive(const std::string isHorizontalInteractive) = 0;
    virtual void setScrollViewVerticalInteractive(const std::string isHorizontalInteractive) = 0;
    virtual void setScrollViewHorizontalVisible(const std::string visible) = 0;
    virtual void addChild(const std::shared_ptr<QmlTag>& childElem) = 0;
    virtual void setBorderColor(const std::string borderColor) = 0;
    virtual void setBorderWidth(const std::string borderWidth) = 0;
    virtual void setRadius(const std::string borderColor) = 0;
/*
    // TextEdit
    virtual void setWrapMode(const std::string wrapMode) = 0;
    virtual void setSelectByMouse(const std::string selectbyMouse) = 0;
    virtual void setSelectedTextColor(const std::string selectedTextColor) = 0;
    virtual void setTopPadding(const std::string topPadding) = 0;
    virtual void setBottomPadding(const std::string bottomPadding) = 0;
    virtual void setLeftPadding(const std::string leftPadding) = 0;
    virtual void setRightPadding(const std::string rightPadding) = 0;


    // TextArea
    virtual void setPlaceHolderColor(const std::string placeHolderColor) = 0;
    virtual void setOnTextChanged(const std::string onTextChanged) = 0;
    virtual void setBackGround(const std::string background) = 0;
    virtual void onPressed(const std::string onPressed) = 0;
    virtual void onReleased(const std::string onReleased) = 0;
  */  






 };

