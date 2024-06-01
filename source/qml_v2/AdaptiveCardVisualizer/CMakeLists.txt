cmake_minimum_required(VERSION 3.14)

if(WIN32)
    project(AdaptiveCardVisualizer LANGUAGES CXX)
elseif(UNIX)
    project(AdaptiveCardVisualizer)
endif()

set(CMAKE_CONFIGURATION_TYPES "Debug" "Release" CACHE STRING "" FORCE)
set(CMAKE_CXX_STANDARD 17)

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

file(GLOB_RECURSE ALL_QML_FILES LIST_DIRECTORIES false *.qml *.js)

# This is a dummy just to show the files in the IDE  
add_library(qmlFiles INTERFACE ${ALL_QML_FILES})

#set_target_properties(VisualizerQmlFiles PROPERTIES FOLDER "Visualizer")

add_definitions( -DSAMPLE_JSON_FOLDER="${CMAKE_CURRENT_SOURCE_DIR}/JSONSamples" )

file(GLOB_RECURSE SOURCES
    "qmlFiles/resource.qrc"
	"main.cpp"
	"SampleCardListModel.cpp"
	"SampleCardController.cpp"
	"SampleCardListModel.h"
	"SampleCardController.h"
)

# Setup Executable

set(CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_AUTOUIC_SEARCH_PATHS} ${CMAKE_CURRENT_SOURCE_DIR})

if(WIN32)
    add_executable(AdaptiveCardVisualizer WIN32 ${SOURCES})
elseif(UNIX)
    add_executable(AdaptiveCardVisualizer ${SOURCES})
endif()

target_include_directories(AdaptiveCardVisualizer PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(AdaptiveCardVisualizer Qt5::Widgets)
target_link_libraries(AdaptiveCardVisualizer Qt5::Quick)
#target_link_libraries(AdaptiveCardVisualizer RendererQml)

