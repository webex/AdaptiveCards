#pragma once

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"
#include <memory>

class TextinputElement
{
	std::shared_ptr<RendererQml::QmlTag> mTextinputElement;
	std::shared_ptr<RendererQml::QmlTag> mTextinputColElement;
	std::shared_ptr<RendererQml::QmlTag> mContainer;
	const std::shared_ptr<AdaptiveCards::TextInput> &mTextinput;
	const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;
	void initMultiLine();
	void initSingleLine();
	std::shared_ptr<RendererQml::QmlTag> createInputTextLabel(bool isRequired = false);
	std::shared_ptr<RendererQml::QmlTag> createErrorMessageText(std::string errorMessage);
	const std::string getColorFunction();
	void addInlineActionMode();
	std::shared_ptr<RendererQml::QmlTag> createSingleLineTextFieldElement();
	std::shared_ptr<RendererQml::QmlTag> createMultiLineTextAreaElement();
	std::shared_ptr<RendererQml::QmlTag> createMultiLineBackgroundElement();
public:
	TextinputElement(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
	std::shared_ptr<RendererQml::QmlTag> getQmlString();
	void initialize();

};

