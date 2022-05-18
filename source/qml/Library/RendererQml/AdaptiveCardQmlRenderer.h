#pragma once
#include "pch.h"

#include "AdaptiveCardsRendererBase.h"
#include "AdaptiveCardRenderConfig.h"
#include "RenderedQmlAdaptiveCard.h"
#include "AdaptiveRenderContext.h"

#include "TextBlock.h"
#include "RichTextBlock.h"
#include "Inline.h"
#include "TextRun.h"
#include "Image.h"
#include "Media.h"
#include "Container.h"
#include "Column.h"
#include "ColumnSet.h"
#include "FactSet.h"
#include "Fact.h"
#include "ImageSet.h"
#include "ActionSet.h"
#include "ChoiceSetInput.h"
#include "ChoiceInput.h"
#include "CollectionTypeElement.h"
#include "TextInput.h"
#include "NumberInput.h"
#include "DateInput.h"
#include "TimeInput.h"
#include "ToggleInput.h"
#include "SubmitAction.h"
#include "OpenUrlAction.h"
#include "ShowCardAction.h"
#include "ToggleVisibilityAction.h"
#include "MarkDownParser.h"

namespace RendererQml
{
    class AdaptiveCardQmlRenderer : public AdaptiveCardsRendererBase<QmlTag, AdaptiveRenderContext>
    {
    public:
        AdaptiveCardQmlRenderer();
        AdaptiveCardQmlRenderer(std::shared_ptr<AdaptiveCards::HostConfig> hostConfig, std::shared_ptr<AdaptiveCardRenderConfig> renderConfig);

        std::pair<std::shared_ptr<RenderedQmlAdaptiveCard>, int> RenderCard(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, int contentIndex);
        static std::shared_ptr<QmlTag> GetClearIconButton(std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> AdaptiveActionRender(std::shared_ptr<AdaptiveCards::BaseActionElement> adaptiveAction, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> GetIconTag(std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> GetStretchRectangle(std::shared_ptr<QmlTag> element);
        static std::shared_ptr<QmlTag> GetTextBlockMouseArea(std::string id, bool isButton = false);
        static std::shared_ptr<QmlTag> AddAccessibilityToTextBlock(std::shared_ptr<QmlTag> uiTextBlock, std::shared_ptr<AdaptiveRenderContext> context);

    protected:
        static void addSelectAction(const std::shared_ptr<QmlTag>& parent, const std::string& rectId, const std::shared_ptr<AdaptiveCards::BaseActionElement>& selectAction, const std::shared_ptr<AdaptiveRenderContext>& context, const std::string parentName, const bool hasBackgroundImage = false);
        static void addTextRunSelectActions(const std::shared_ptr<AdaptiveRenderContext>& context);
        static void AddActions(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseActionElement>>& actions, std::shared_ptr<AdaptiveRenderContext> context, bool removeBottomMargin = true);
		static void AddContainerElements(std::shared_ptr<QmlTag> uiContainer, const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& elements, std::shared_ptr<AdaptiveRenderContext> context);
		static void AddSeparator(std::shared_ptr<QmlTag> uiContainer, std::shared_ptr<AdaptiveCards::BaseCardElement> adaptiveElement, std::shared_ptr<AdaptiveRenderContext> context, const bool isShowCard = false, const std::string loaderId = "");
        static std::shared_ptr<QmlTag> AdaptiveCardRender(std::shared_ptr<AdaptiveCards::AdaptiveCard> card, std::shared_ptr<AdaptiveRenderContext> context, bool isChildCard);

        static std::shared_ptr<QmlTag> TextBlockRender(std::shared_ptr<AdaptiveCards::TextBlock> textBlock, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> RichTextBlockRender(std::shared_ptr<AdaptiveCards::RichTextBlock> richTextBlock, std::shared_ptr<AdaptiveRenderContext> context);
        static std::string TextRunRender(const std::shared_ptr<AdaptiveCards::TextRun>& textRun, const std::shared_ptr<AdaptiveRenderContext>& context, const std::string& selectaction);

        static std::shared_ptr<QmlTag> ImageRender(std::shared_ptr<AdaptiveCards::Image> image, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> MediaRender(std::shared_ptr<AdaptiveCards::Media> media, std::shared_ptr<AdaptiveRenderContext> context);

        static std::shared_ptr<QmlTag> ContainerRender(std::shared_ptr<AdaptiveCards::Container> container, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> ColumnRender(std::shared_ptr<AdaptiveCards::Column> column, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> ColumnSetRender(std::shared_ptr<AdaptiveCards::ColumnSet> columnSet, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> FactSetRender(std::shared_ptr<AdaptiveCards::FactSet> factSet, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> ImageSetRender(std::shared_ptr<AdaptiveCards::ImageSet> imageSet, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> ActionSetRender(std::shared_ptr<AdaptiveCards::ActionSet> actionSet, std::shared_ptr<AdaptiveRenderContext> context);

        static std::shared_ptr<QmlTag> ChoiceSetRender(std::shared_ptr<AdaptiveCards::ChoiceSetInput> choiceSet, std::shared_ptr<AdaptiveRenderContext> context);
		static std::shared_ptr<QmlTag> TextInputRender(std::shared_ptr<AdaptiveCards::TextInput> input, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> NumberInputRender(std::shared_ptr<AdaptiveCards::NumberInput> input, std::shared_ptr<AdaptiveRenderContext> context);

        static std::shared_ptr<QmlTag> DateInputRender(std::shared_ptr<AdaptiveCards::DateInput> input, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> TimeInputRender(std::shared_ptr<AdaptiveCards::TimeInput> input, std::shared_ptr<AdaptiveRenderContext> context);
        static std::shared_ptr<QmlTag> ToggleInputRender(std::shared_ptr<AdaptiveCards::ToggleInput> input, std::shared_ptr<AdaptiveRenderContext> context);
        
        
    private:
        void SetObjectTypes();
		static std::shared_ptr<QmlTag> GetComponent(const std::string& componentId, const std::shared_ptr<QmlTag>& uiCard);

		template <typename CardElement>
		static std::shared_ptr<QmlTag> GetNewColumn(CardElement cardElement, std::shared_ptr<AdaptiveRenderContext> context);

		template <typename CardElement>
		static std::shared_ptr<QmlTag> GetNewContainer(CardElement cardElement, std::shared_ptr<AdaptiveRenderContext> context);

		static std::shared_ptr<QmlTag> GetBackgroundImage(std::shared_ptr<AdaptiveCards::BackgroundImage> backgroundImage, std::shared_ptr<AdaptiveRenderContext> context, const std::string& imgSource);

        static void addSubmitActionButtonClickFunc(const std::shared_ptr<AdaptiveRenderContext>& context);
        static void addShowCardButtonClickFunc(const std::shared_ptr<AdaptiveRenderContext>& context);
        static void addShowCardLoaderComponents(const std::shared_ptr<AdaptiveRenderContext>& context);

        static const std::string getActionOpenUrlClickFunc(const std::shared_ptr<AdaptiveCards::OpenUrlAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context);
        static const std::string getActionSubmitClickFunc(const std::shared_ptr<AdaptiveCards::SubmitAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context, std::string elementType);
		static const std::string getActionShowCardClickFunc(const std::shared_ptr<QmlTag>& buttonElement, const std::shared_ptr<AdaptiveRenderContext>& context);
		static const std::string getActionToggleVisibilityClickFunc(const std::shared_ptr<AdaptiveCards::ToggleVisibilityAction>& action, const std::shared_ptr<AdaptiveRenderContext>& context);

		static const std::string getStretchWidth();
		static const std::string getStretchHeight();
		static const std::string getMinWidth();
		static const std::string getMinWidthActionSet();
		static const std::string getMinWidthFactSet();
		static const std::string getSelectLinkFunction();
        static const std::string getCardHeightFunction();

		template <typename CardElement>
		static const std::shared_ptr<QmlTag> applyHorizontalBleed(CardElement cardElement, std::shared_ptr<QmlTag> uiContainer, std::shared_ptr<AdaptiveRenderContext> context);
		static const std::shared_ptr<QmlTag> applyVerticalBleed(std::shared_ptr<QmlTag> elementsParent, std::shared_ptr<QmlTag> source);
		static const std::shared_ptr<QmlTag> addColumnSetElements(std::shared_ptr<AdaptiveCards::ColumnSet> columnSet, std::shared_ptr<QmlTag> uiFrame, std::shared_ptr<AdaptiveRenderContext> context);

        static std::shared_ptr<QmlTag> getDummyElementforNumberInput(bool isTop);

        static void ValidateLastBodyElementIsShowCard(const std::vector<std::shared_ptr<AdaptiveCards::BaseCardElement>>& bodyElements, std::shared_ptr<AdaptiveRenderContext> context);
        static void ValidateShowCardInActions(const std::vector<std::shared_ptr<AdaptiveCards::BaseActionElement>>& actions, std::shared_ptr<AdaptiveRenderContext> context);

        static const std::string RemoveBottomMarginValue(std::vector<std::string> showCardsList);

        static const std::string GetImagePath(std::shared_ptr<AdaptiveRenderContext> context, const std::string url);

        static std::shared_ptr<QmlTag> AddCornerRectangles(std::shared_ptr<QmlTag> uiCard, int rectangleSize);

        static std::shared_ptr<QmlTag> GetOpacityMask(std::string parentId);
    };
}
