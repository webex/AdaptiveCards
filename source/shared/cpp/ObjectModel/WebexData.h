// Copyright (c) Microsoft Corporation. All rights reserved.

// Licensed under the MIT License.

#pragma once

#include "pch.h"
#include "ParseContext.h"

namespace AdaptiveCards
{
class WebexData
{
public:
    WebexData();

    Json::Value SerializeToJsonValue() const;

    bool ShouldSerialize() const;
    std::string Serialize() const;
    
    CardWidth GetCardWidth() const;
    void SetCardWidth(const CardWidth value);

    static std::shared_ptr<WebexData> Deserialize(ParseContext& context, const Json::Value& root);
    static std::shared_ptr<WebexData> DeserializeFromString(ParseContext& context, const std::string& jsonString);

private:
    CardWidth m_cardWidth;
};

} // namespace AdaptiveCards
