cmake_minimum_required(VERSION 3.21)
project(${SKBUILD_PROJECT_NAME} LANGUAGES C)

# Find required packages
find_package(Python 3.12 EXACT REQUIRED
    COMPONENTS Interpreter Development.Module Development.Embed)
find_package(PkgConfig REQUIRED)
include(UseCython)

# Find SDL2 and related libraries
pkg_check_modules(SDL2 REQUIRED sdl2)
pkg_check_modules(SDL2_IMAGE REQUIRED SDL2_image)
pkg_check_modules(SDL2_TTF REQUIRED SDL2_ttf)
pkg_check_modules(SDL2_MIXER REQUIRED SDL2_mixer)

# Find additional libraries
find_library(JPEG_LIBRARY jpeg REQUIRED)
find_library(PNG_LIBRARY png REQUIRED)

# Global settings
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${SDL2_INCLUDE_DIRS}
)

set(CYTHON_ARGS
    -X embedsignature=True
    -I${CMAKE_CURRENT_SOURCE_DIR}/include)

# Static build configuration
option(PYGAME_SDL2_STATIC "Build static version" OFF)
if(DEFINED ENV{PYGAME_SDL2_STATIC})
    if (ENV{PYGAME_SDL2_STATIC})
        set(PYGAME_SDL2_STATIC ON)
    endif()
endif()

# Function to create Cython extension
function(add_cython_extension name)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs SOURCES LIBRARIES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Convert module name to path
    string(REPLACE "." "/" module_path ${name})
    set(pyx_file ${CMAKE_CURRENT_SOURCE_DIR}/src/${module_path}.pyx)

    cython_transpile(${pyx_file} OUTPUT_VARIABLE c_file)

    # Handle static build modifications for Python 3.12
    if(PYGAME_SDL2_STATIC)
        set(static_c_file ${CMAKE_CURRENT_BINARY_DIR}/src/${module_path}_static.c)

        add_custom_command(
            OUTPUT ${static_c_file}
            COMMAND ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/scripts/fix_static.py
                ${c_file} ${static_c_file} ${name}
            DEPENDS ${c_file}
            COMMENT "Creating static version of ${name}"
        )

        set(final_c_file ${static_c_file})
    else()
        set(final_c_file ${c_file})
    endif()

    # Create Python extension
    python_add_library(${name} MODULE ${final_c_file} ${ARG_SOURCES})

    # Extract the base filename for the extension
    get_filename_component(base_filename ${module_path} NAME)

    # Set properties for Python 3.12
    set_target_properties(${name} PROPERTIES
        PREFIX ""
        OUTPUT_NAME ${base_filename}
    )

    # Link libraries
    target_link_libraries(${name} PRIVATE
        ${SDL2_LIBRARIES}
        ${ARG_LIBRARIES}
    )

    # Add compile flags
    target_compile_options(${name} PRIVATE
        ${SDL2_CFLAGS_OTHER}
        ${EXTRA_CFLAGS}
    )

    # Install the extension
    string(REPLACE "." "/" install_subpath ${name})
    get_filename_component(install_dir ${install_subpath} DIRECTORY)
    install(TARGETS ${name} DESTINATION ${install_dir})

endfunction()

# Add all Cython extensions
add_cython_extension(pygame_sdl2.error)
add_cython_extension(pygame_sdl2.color)
add_cython_extension(pygame_sdl2.controller)
add_cython_extension(pygame_sdl2.rect)
add_cython_extension(pygame_sdl2.rwobject)
add_cython_extension(pygame_sdl2.surface
    SOURCES src/alphablit.c
)
add_cython_extension(pygame_sdl2.display)
add_cython_extension(pygame_sdl2.event)
add_cython_extension(pygame_sdl2.locals)
add_cython_extension(pygame_sdl2.key)
add_cython_extension(pygame_sdl2.mouse)
add_cython_extension(pygame_sdl2.joystick)
add_cython_extension(pygame_sdl2.power)
add_cython_extension(pygame_sdl2.pygame_time)
add_cython_extension(pygame_sdl2.image
    SOURCES src/write_jpeg.c src/write_png.c
    LIBRARIES ${SDL2_IMAGE_LIBRARIES} ${JPEG_LIBRARY} ${PNG_LIBRARY}
)
add_cython_extension(pygame_sdl2.transform
    SOURCES src/SDL2_rotozoom.c
)
add_cython_extension(pygame_sdl2.gfxdraw
    SOURCES src/SDL_gfxPrimitives.c
)
add_cython_extension(pygame_sdl2.draw)
add_cython_extension(pygame_sdl2.font
    LIBRARIES ${SDL2_TTF_LIBRARIES}
)
add_cython_extension(pygame_sdl2.mixer
    LIBRARIES ${SDL2_MIXER_LIBRARIES}
)
add_cython_extension(pygame_sdl2.mixer_music
    LIBRARIES ${SDL2_MIXER_LIBRARIES}
)
add_cython_extension(pygame_sdl2.scrap)
add_cython_extension(pygame_sdl2.render
    LIBRARIES ${SDL2_IMAGE_LIBRARIES}
)

# Install Python modules
install(
    DIRECTORY src/pygame_sdl2/
    DESTINATION pygame_sdl2
    FILES_MATCHING PATTERN "*.py"
)

# Install data files
install(
    FILES
        src/pygame_sdl2/DejaVuSans.ttf
        src/pygame_sdl2/DejaVuSans.txt
    DESTINATION pygame_sdl2
)

# Install headers
install(
    FILES
        src/pygame_sdl2/pygame_sdl2.h
        ${CMAKE_CURRENT_BINARY_DIR}/src/pygame_sdl2/rwobject_api.h
        ${CMAKE_CURRENT_BINARY_DIR}/src/pygame_sdl2/surface_api.h
        ${CMAKE_CURRENT_BINARY_DIR}/src/pygame_sdl2/display_api.h
    DESTINATION include/pygame_sdl2
)

# Install dlls
if (NOT PYGAME_SDL2_STATIC AND WIN32)
    install(
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pygame_sdl2_windeps/lib/x64/
        DESTINATION pygame_sdl2
        FILES_MATCHING PATTERN "*.dll"
    )
endif()
