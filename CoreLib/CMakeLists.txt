cmake_minimum_required(VERSION 3.16)

project(CoreLib VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Network Concurrent)

# کتابخانه اصلی
qt_add_library(CoreLib STATIC
    src/DataTypes.cpp
    src/Node.cpp
    src/NodePort.cpp
    src/NodeGraph.cpp
    src/NodeRegistry.cpp
    src/ProcessingPipeline.cpp
    src/PluginManager.cpp
    src/DeviceManager.cpp
)

target_link_libraries(CoreLib PUBLIC
    Qt6::Core
    Qt6::Qml
    Qt6::Network
)

target_include_directories(CoreLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../PluginAPI/include
)

target_compile_definitions(CoreLib PUBLIC
    CORE_LIB_VERSION="${PROJECT_VERSION}"
)

install(TARGETS CoreLib
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)

install(DIRECTORY include/
    DESTINATION include/CoreLib
)
