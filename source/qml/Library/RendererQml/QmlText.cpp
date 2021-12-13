#include "QmlText.h"

QmlText::QmlText(std::string id, std::shared_ptr<QmlTag> textTag, std::string text) :
	QmlItem(id, textTag)
{
	getQmltag()->Property("text", text);
}

 void QmlText::setFont(const std::string font)
 {
	 getQmltag()->Property("font", font);
 }
 void QmlText::setHorizontalAlignment(const std::string horizontalAlignment)
 {
	 getQmltag()->Property("horizontalAlignment", horizontalAlignment);
 }
 void QmlText::setVerticalAlignment(const std::string verticalAlignment)
 {
	 getQmltag()->Property("verticalAlignment", verticalAlignment);
 }
 void QmlText::setLeftPadding(const std::string leftPadding)
 {
	 getQmltag()->Property("leftPadding", leftPadding);
 }
 void QmlText::setColor(const std::string color)
 {
	 getQmltag()->Property("color", color);
 }
 void QmlText::setWrapMode(const std::string wrapMode)
 {
	 getQmltag()->Property("wrapMode", wrapMode);
 }
 void QmlText::setElide(const std::string elide)
 {
	 getQmltag()->Property("elide", elide);
 }

