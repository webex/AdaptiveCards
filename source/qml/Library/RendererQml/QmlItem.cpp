#include "QmlItem.h"


QmlItem::QmlItem(std::string id, std::shared_ptr<QmlTag> qmlTag) :
	mId(id),
	mQmlTag(qmlTag)
{
	if (id != "")
	{
		getQmltag()->Property("id", id);
	}
}

std::string QmlItem::getId() const
{
	return mId;
}

std::shared_ptr<QmlTag>& QmlItem::getQmltag()
{
	return mQmlTag;
}

std::shared_ptr<QmlTag> QmlItem::getQmlString() const
{
	return mQmlTag;
}

void QmlItem::setWidth(const std::string width)
{
	mQmlTag->Property("width", width);
}

void QmlItem::setHeight(const std::string height)
{
	mQmlTag->Property("height", height);
}

void QmlItem::setImplicitWidth(const std::string implicitWidth)
{
	mQmlTag->Property("implicitWidth", implicitWidth);
}

void QmlItem::setImplicitHeight(const std::string implicitHeight)
{
	mQmlTag->Property("implicitHeight", implicitHeight);
}

void QmlItem::setVisible(const std::string visible)
{
	mQmlTag->Property("visible", visible);
}

void QmlItem::addChild(const std::shared_ptr<QmlTag>& childElem)
{
	mQmlTag->AddChild(childElem);
}

void QmlItem::setFont(const std::string font)
{
	throw("undefined function setFont"); 
}

void QmlItem::setHorizontalAlignment(const std::string horizontalAlignment)
{
	throw("undefined function setHorizontalAlignment");
}

void QmlItem::setVerticalAlignment(const std::string verticalAlignment)
{
	throw("undefined function setVerticalAlignment");
}

void QmlItem::setLeftPadding(const std::string leftPadding)
{
	throw("undefined function setLeftPadding");
}

void QmlItem::setWrapMode(const std::string wrapMode)
{
	throw("undefined function setWrapMode");
}

void QmlItem::setElide(const std::string elide)
{
	throw("undefined function setElide");
}

void QmlItem::setScrollViewHorizontalInteractive(const std::string isHorizontalInteractive)
{
	throw("undefined function setScrollViewHorizontalInteractive");
}

void QmlItem::setScrollViewVerticalInteractive(const std::string isHorizontalInteractive)
{
	throw("undefined function setScrollViewVerticalInteractive");
}

void QmlItem::setScrollViewHorizontalVisible(const std::string visible)
{
	throw("undefined function setScrollViewHorizontalVisible");
}

void QmlItem::setBorderColor(const std::string borderColor)
{
	throw("undefined function setBorderColor");
}

void QmlItem::setBorderWidth(const std::string borderWidth)
{
	throw("undefined function setBorderWidth");
}
void QmlItem::setRadius(const std::string radius)
{
	throw("undefined function setRadius");
}

void QmlItem::setColor(const std::string color)
{
	throw("undefined function setColor");
}
