#pragma once
#include<string>

namespace RendererQml
{
	class InputTextConfig {

	public:
		std::string height;
		std::string leftPadding;
		std::string rightPadding;
		std::string radius;
	};

	class RenderConfig
	{
	public:
		InputTextConfig textInputConfig;
	};

}

