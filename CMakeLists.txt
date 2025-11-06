# BCIStudio/CMakeLists.txt

cmake_minimum_required(VERSION 3.16)

project(BCIStudio VERSION 1.0 LANGUAGES CXX)
cmake_minimum_required(VERSION 3.16)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# تنظیمات سراسری برای همه زیرپروژه‌های Qt
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# --- پیدا کردن Qt6 ---
# این بخش فقط یک بار در سطح بالا انجام می‌شود.
# زیرپروژه‌ها به طور خودکار به آن دسترسی خواهند داشت.
find_package(Qt6 COMPONENTS Core Quick QuickControls2 ShaderTools Core5Compat  REQUIRED)

# --- اضافه کردن زیرشاخه‌ها ---
# ترتیب اینجا مهم است! ماژول‌هایی که دیگران به آن‌ها وابسته هستند باید اول بیایند.




# زیرپروژه‌ها
add_subdirectory(CoreLib)
add_subdirectory(PluginAPI)
add_subdirectory(plugins)
add_subdirectory(BCIStudioApp)

# کپی پلاگین‌ها پس از build
# add_custom_command(TARGET BCIAstudioApp POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_directory
#     ${CMAKE_BINARY_DIR}/plugins
#     $<TARGET_FILE_DIR:BCIAstudioApp>/plugins
# )
