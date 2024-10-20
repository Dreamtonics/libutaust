cmake_minimum_required(VERSION 3.21)
project(utaust)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR
    "In-source builds are not allowed."
    "\n Please remove \"${CMAKE_SOURCE_DIR}/CMakeCache.txt\" and try again from another folder"
  )
endif()

option(UTAUST_BUILD_TESTS "Build tests" OFF)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_library(utaust STATIC utaust.c)

install(TARGETS utaust
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)
install(FILES utaust.h DESTINATION include/libutaust)

# Test
if (UTAUST_BUILD_TESTS)
  message(STATUS "Tests are enabled")
  enable_testing()

  add_executable(test-utaust test/test.c)
  target_link_libraries(test-utaust PRIVATE utaust)
  add_test(NAME test-utaust COMMAND test-utaust)
endif()
