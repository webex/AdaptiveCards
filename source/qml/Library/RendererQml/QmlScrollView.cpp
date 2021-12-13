#include "QmlScrollView.h"

QmlScrollView::QmlScrollView(std::string id, std::shared_ptr<QmlTag> scrollTag) :
	QmlItem(id, scrollTag)
{
	
}

void QmlScrollView::setScrollViewHorizontalInteractive(const std::string isHorizontalInteractive)
{
	getQmltag()->Property("ScrollBar.vertical.interactive", isHorizontalInteractive);
}

void QmlScrollView::setScrollViewVerticalInteractive(const std::string isHorizontalInteractive)
{
	getQmltag()->Property("ScrollBar.horizontal.interactive", isHorizontalInteractive);
}

void QmlScrollView::setScrollViewHorizontalVisible(const std::string visible)
{
	getQmltag()->Property("ScrollBar.horizontal.visible", visible);
}
