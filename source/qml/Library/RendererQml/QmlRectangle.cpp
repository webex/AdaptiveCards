#include "QmlRectangle.h"

QmlRectangle::QmlRectangle(std::string id, std::shared_ptr<QmlTag> rectTag) :
	QmlItem(id, rectTag)
{
}

void QmlRectangle::setBorderColor(const std::string borderColor)
{
	getQmltag()->Property("border.color", borderColor);
}

void QmlRectangle::setBorderWidth(const std::string borderWidth)
{
	getQmltag()->Property("border.width", borderWidth);
}

void QmlRectangle::setRadius(const std::string radius)
{
	getQmltag()->Property("radius", radius);
}

void QmlRectangle::setColor(const std::string color)
{
	getQmltag()->Property("color", color);
}
