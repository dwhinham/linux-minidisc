cmake_minimum_required(VERSION 3.10)
project(linux-minidisc LANGUAGES C)

option(BUILD_NETMDCLI "Build the netmdcli command-line tool" ON)

# Additional CMake modules
LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

if(WIN32)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(64_BIT TRUE)
    endif()

    include(ExternalProject)

    # Get libgcrypt binaries
    ExternalProject_Add(libgcrypt
        URL
            https://github.com/ShiftMediaProject/libgcrypt/releases/download/libgcrypt-1.8.5/libgcrypt_libgcrypt-1.8.5_msvc16.zip
        URL_MD5
            d6013376bf29fdb5a7f54446de21cc30
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )

    ExternalProject_Get_property(libgcrypt SOURCE_DIR)
    set(LIBGCRYPT_INCLUDE_DIRS ${SOURCE_DIR}/include)
    if(64_BIT)
        set(LIBGCRYPT_LIBRARIES ${SOURCE_DIR}/lib/x64/gcrypt.lib)
        set(LIBGCRYPT_DLL ${SOURCE_DIR}/bin/x64/gcrypt.dll)
    else()
        set(LIBGCRYPT_LIBRARIES ${SOURCE_DIR}/lib/x86/gcrypt.lib)
        set(LIBGCRYPT_DLL ${SOURCE_DIR}/bin/x64/gcrypt.dll)
    endif()

    # Get libusb binaries
    ExternalProject_Add(libusb
        URL
            https://github.com/libusb/libusb/releases/download/v1.0.22/libusb-1.0.22.7z
        URL_MD5
            750e64b45aca94fafbdff07171004d03
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
    )

    ExternalProject_Get_property(libusb SOURCE_DIR)
    set(LIBUSB_INCLUDE_DIRS ${SOURCE_DIR}/include/libusb-1.0)
    if(64_BIT)
        set(LIBUSB_LIBRARIES ${SOURCE_DIR}/MS64/dll/libusb-1.0.lib)
        set(LIBUSB_DLL ${SOURCE_DIR}/MS64/dll/libusb-1.0.dll)
    else()
        set(LIBUSB_LIBRARIES ${SOURCE_DIR}/MS32/dll/libusb-1.0.lib)
        set(LIBUSB_DLL ${SOURCE_DIR}/MS32/dll/libusb-1.0.dll)
    endif()
else()
    find_package(PkgConfig)
    find_package(LibUSB 1.0 REQUIRED)
    find_package(LibGcrypt 1.0 REQUIRED)
endif()

add_subdirectory(libnetmd)
if(BUILD_NETMDCLI)
    add_subdirectory(netmdcli)
endif()

if(WIN32)
    # Ensure external projects are ready before building dependant targets
    add_dependencies(netmd libusb libgcrypt)
    if(BUILD_NETMDCLI)
        add_dependencies(netmdcli libusb libgcrypt)
    endif()
endif()

# Set default Visual Studio startup project
if(BUILD_NETMDCLI)
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT netmdcli)
endif()
