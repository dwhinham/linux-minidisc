add_executable(netmdcli
    # Sources
    netmdcli.c
)

if(WIN32)
    target_sources(netmdcli
        PRIVATE
            getopt.h
            getopt.c
    )

    target_compile_definitions(netmdcli
        PRIVATE
            _CRT_SECURE_NO_WARNINGS
    )

    # Copy DLL files to output directory after build
    add_custom_command(TARGET netmdcli POST_BUILD
        COMMAND
            ${CMAKE_COMMAND} -E copy_if_different "${LIBUSB_DLL}" $<TARGET_FILE_DIR:netmdcli>
        COMMAND
            ${CMAKE_COMMAND} -E copy_if_different "${LIBGCRYPT_DLL}" $<TARGET_FILE_DIR:netmdcli>
    )
endif()

target_include_directories(netmdcli
    PRIVATE
        ${LIBGCRYPT_INCLUDE_DIRS}
        ${LIBUSB_INCLUDE_DIRS}
)

target_link_libraries(netmdcli
    PRIVATE
        netmd
)
