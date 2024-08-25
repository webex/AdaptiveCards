cmake_minimum_required(VERSION 3.14)

if(WIN32)
    project(AdaptiveCardQmlEngine LANGUAGES CXX)
elseif(UNIX)
    project(AdaptiveCardQmlEngine)
endif()

set(CMAKE_CONFIGURATION_TYPES "Debug" CACHE STRING "" FORCE)
set(CMAKE_CXX_STANDARD 17)

# Shared Code Inclusion

set(SHARED_CODE_DIR "${CMAKE_SOURCE_DIR}/../shared/cpp/ObjectModel")

file(GLOB_RECURSE SHARED_CODE_SOURCES
    "${SHARED_CODE_DIR}/*.h"
    "${SHARED_CODE_DIR}/*.cpp"
)

add_library(AdaptiveCardShared STATIC ${SHARED_CODE_SOURCES})
target_include_directories(AdaptiveCardShared PUBLIC ${SHARED_CODE_DIR})

# Qt Inclusion

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_PREFIX_PATH $ENV{QTDIR})
find_package(Qt5Core REQUIRED)
find_package(Qt5Widgets REQUIRED)
find_package(Qt5Quick REQUIRED)

# Project Files Inclusion

file(GLOB_RECURSE ALL_QML_FILES LIST_DIRECTORIES false *.qml *.js *.json)

# This is a dummy just to show the files in the IDE  
add_library(qml INTERFACE ${ALL_QML_FILES})
set_target_properties(qml PROPERTIES FOLDER "AdaptiveCardQmlEngine")

file(GLOB_RECURSE SOURCES
    "resourceEngine.qrc"
	"AdaptiveCardUtils.cpp"
	"AdaptiveCardContext.cpp"
	"AdaptiveCardConfig.cpp"
	"AdaptiveRenderArgs.cpp"
	"Formatter.cpp"
	"Utils.cpp"
	"stdafx.cpp"
	
	"AdaptiveCardController.cpp"
	"AdaptiveCardModel.cpp"
	"CollectionItemModel.cpp"
	
	"TextBlockModel.cpp"
	"ImageModel.cpp"
	
	"AdaptiveCardQmlTypes.h"
	"AdaptiveCardUtils.cpp"
	"AdaptiveCardEnums.h"
	"AdaptiveCardContext.h"
	"AdaptiveCardConfig.h"
	"AdaptiveCardDarkThemeConfig.h"
	"AdaptiveCardLightThemeConfig.h"
	"AdaptiveRenderArgs.h"
	"Formatter.h"
	"Utils.h"
	"stdafx.h"
	
    "AdaptiveCardController.h"
    "AdaptiveCardModel.h"
    "CollectionItemModel.h"
	
    "TextBlockModel.h"	
    "ImageModel.h"
)

# Setup Library

set(CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_AUTOUIC_SEARCH_PATHS} ${CMAKE_CURRENT_SOURCE_DIR})

add_library(AdaptiveCardQmlEngine STATIC ${SOURCES})
target_include_directories(AdaptiveCardQmlEngine PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(AdaptiveCardQmlEngine PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/models")
target_include_directories(AdaptiveCardQmlEngine PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/controllers")
target_include_directories(AdaptiveCardQmlEngine PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/utils")

target_link_libraries(AdaptiveCardQmlEngine Qt5::Widgets)
target_link_libraries(AdaptiveCardQmlEngine Qt5::Quick)
target_link_libraries(AdaptiveCardQmlEngine AdaptiveCardShared)


