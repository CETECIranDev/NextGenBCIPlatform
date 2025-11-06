cmake_minimum_required(VERSION 3.16)

project(PluginAPI VERSION 1.0.0 LANGUAGES CXX)

# کتابخانه interface برای پلاگین‌ها
add_library(PluginAPI INTERFACE)

target_include_directories(PluginAPI INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(PluginAPI INTERFACE
    Qt6::Core
)

target_compile_definitions(PluginAPI INTERFACE
    PLUGIN_API_VERSION=1
)

install(TARGETS PluginAPI EXPORT PluginAPITargets)
install(DIRECTORY include/ DESTINATION include/PluginAPI)