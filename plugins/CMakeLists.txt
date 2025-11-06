cmake_minimum_required(VERSION 3.16)

# پیکربندی پلاگین‌ها
set(PLUGIN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/plugins)

# ماکرو برای ساخت پلاگین
function(add_bci_plugin plugin_name)
    cmake_parse_arguments(ARG "" "" "SOURCES;HEADERS;QML_FILES" ${ARGN})
    
    qt_add_plugin(${plugin_name} SHARED
        ${ARG_SOURCES}
    )
    
    target_link_libraries(${plugin_name} PRIVATE
        CoreLib
        PluginAPI
        Qt6::Core
        Qt6::Qml
    )
    
    target_include_directories(${plugin_name} PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/../PluginAPI/include
    )
    
    if(ARG_QML_FILES)
        qt_add_resources(${plugin_name} "qml_${plugin_name}"
            PREFIX "/plugins/${plugin_name}"
            FILES ${ARG_QML_FILES}
        )
    endif()
    
    set_target_properties(${plugin_name} PROPERTIES
        LIBRARY_OUTPUT_DIRECTORY ${PLUGIN_OUTPUT_DIR}
        RUNTIME_OUTPUT_DIRECTORY ${PLUGIN_OUTPUT_DIR}
    )
endfunction()

# پلاگین‌های اصلی
add_subdirectory(EEGProcessing)
add_subdirectory(P300Paradigm)