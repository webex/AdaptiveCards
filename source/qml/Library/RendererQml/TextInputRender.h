#pragma once

#include "AdaptiveCardQmlRenderer.h"
#include "QmlTag.h"
#include <memory>

class TextinputElement
{
public:
	TextinputElement(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<RendererQml::AdaptiveRenderContext> context);
	TextinputElement() = delete;
	TextinputElement(const TextinputElement&) = delete;
	TextinputElement& operator= (const TextinputElement&) = delete;
	std::shared_ptr<RendererQml::QmlTag> getQmlString();
	void initialize();

private:
	std::shared_ptr<RendererQml::QmlTag> mTextinputElement;
	std::shared_ptr<RendererQml::QmlTag> mTextinputColElement;
	std::shared_ptr<RendererQml::QmlTag> mContainer;
	const std::shared_ptr<AdaptiveCards::TextInput>& mTextinput;
	const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;

private:
	void initMultiLine();
	void initSingleLine();
	std::shared_ptr<RendererQml::QmlTag> createInputTextLabel(bool isRequired = false);
	std::shared_ptr<RendererQml::QmlTag> createErrorMessageText(std::string errorMessage, const std::shared_ptr<RendererQml::QmlTag> uiTextInput);
	const std::string getColorFunction();
	std::string getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiTextInput);
	void addInlineActionMode();
	std::shared_ptr<RendererQml::QmlTag> createSingleLineTextFieldElement();
	std::shared_ptr<RendererQml::QmlTag> createMultiLineTextAreaElement();
	std::shared_ptr<RendererQml::QmlTag> createMultiLineBackgroundElement();
	void addValidationToInputText(std::shared_ptr<RendererQml::QmlTag>& uiTextInput);
};

