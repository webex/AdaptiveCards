#pragma once

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"
#include <memory>

class TextInputElement
{
public:
    TextInputElement(std::shared_ptr<AdaptiveCards::TextInput>& input, std::shared_ptr<RendererQml::AdaptiveRenderContext>& context);
    TextInputElement() = delete;
    TextInputElement(const TextInputElement&) = delete;
    TextInputElement& operator= (const TextInputElement&) = delete;
	std::shared_ptr<RendererQml::QmlTag> getQmlTag();

private:
	std::string mOriginalElementId{ "" };
	std::string mLabelId{ "" };
	std::string mErrorMessageId{ "" };
    std::string mEscapedPlaceHolderString{ "" };
    std::string mEscapedLabelString{ "" };
    std::string mEscapedErrorString{ "" };
    std::string mEscapedValueString{ "" };
	std::shared_ptr<RendererQml::QmlTag> mTextinputElement;
	std::shared_ptr<RendererQml::QmlTag> mTextinputColElement;
	std::shared_ptr<RendererQml::QmlTag> mScrollViewWrapper;
	std::shared_ptr<RendererQml::QmlTag> mContainer;
	const std::shared_ptr<AdaptiveCards::TextInput>& mTextinput;
	const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;

private:
    void initialize();
	void initMultiLine();
	void initSingleLine();
    void addInlineActionMode();

    std::shared_ptr<RendererQml::QmlTag> createMultiLineTextAreaElement();
    std::shared_ptr<RendererQml::QmlTag> createMultiLineBackgroundElement();	
};

