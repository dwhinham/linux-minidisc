add_library(netmd STATIC
    # Headers
    common.h 
    const.h 
    error.h libnetmd.h
    libnetmd_extended.h
    log.h 
    netmd_dev.h
    playercontrol.h 
    secure.h 
    trackinformation.h
    utils.h

    # Sources
    common.c
    error.c
    libnetmd.c
    log.c
    netmd_dev.c
    playercontrol.c
    secure.c
    trackinformation.c
    utils.c
)

if(WIN32)
    target_compile_definitions(netmd
        PRIVATE
            _WINSOCKAPI_
            _CRT_SECURE_NO_WARNINGS
    )
endif()

target_include_directories(netmd
    PRIVATE
        ${LIBGCRYPT_INCLUDE_DIRS}
        ${LIBUSB_INCLUDE_DIRS}
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(netmd
    PUBLIC
        ${LIBGCRYPT_LIBRARIES}
        ${LIBUSB_LIBRARIES}
)
