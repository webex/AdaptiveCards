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
	std::shared_ptr<RendererQml::QmlTag> mTextinputColElement;
	const std::shared_ptr<AdaptiveCards::TextInput>& mTextinput;
	const std::shared_ptr<RendererQml::AdaptiveRenderContext>& mContext;

private:
    void initialize();
    void addActions();
};

