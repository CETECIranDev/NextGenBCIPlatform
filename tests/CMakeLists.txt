# PluginAPI/CMakeLists.txt

# تعریف یک کتابخانه از نوع INTERFACE.
# این کتابخانه هیچ فایلی را کامپایل نمی‌کند، فقط مسیرهای include را فراهم می‌کند.
add_library(PluginAPI INTERFACE)

# تعریف مسیرهای include عمومی (public) این کتابخانه.
# هر پروژه‌ای که به PluginAPI لینک شود، به طور خودکار این مسیر را به include path خود اضافه می‌کند.
target_include_directories(PluginAPI
    INTERFACE 
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)