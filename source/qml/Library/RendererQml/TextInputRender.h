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
    std::string mEscapedPlaceHolderString{ "" };
	std::shared_ptr<RendererQml::QmlTag> mTextinputElement;
	std::shared_ptr<RendererQml::QmlTag> mTextinputColElement;
	std::shared_ptr<RendererQml::QmlTag> mContainer;
	const std::shared_ptr<AdaptiveCards::TextInput>& mTextinput;
	const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;

private:
    void initialize();
	void initMultiLine();
	void initSingleLine();
    void addInlineActionMode();
    void addValidationToInputText(std::shared_ptr<RendererQml::QmlTag>& uiTextInput);

    std::shared_ptr<RendererQml::QmlTag> createSingleLineTextFieldElement();
    std::shared_ptr<RendererQml::QmlTag> createMultiLineTextAreaElement();
    std::shared_ptr<RendererQml::QmlTag> createMultiLineBackgroundElement();
	std::shared_ptr<RendererQml::QmlTag> createInputTextLabel(bool isRequired = false);
	std::shared_ptr<RendererQml::QmlTag> createErrorMessageText(std::string errorMessage, const std::shared_ptr<RendererQml::QmlTag> uiTextInput);

	const std::string getColorFunction();
	std::string getAccessibleName(std::shared_ptr<RendererQml::QmlTag> uiTextInput);
};

