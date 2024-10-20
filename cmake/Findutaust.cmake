#.rst:
# Findutaust
# ---------
#
# Try to locate the utaust.
#
# The following variables can be set to control the behavior of this find module:
#
# ``utaust_INCLUDE_DIR``
#   The directory containing the include files of utaust.
# ``utaust_LIBRARY``
#   The file path to the utaust library.

# If utaust is found, this will define the following variables:
#
# ``utaust_FOUND``
#   True if utaust is available
# ``utaust_INCLUDE_DIRS``
#   The utaust include directories
# ``utaust_LIBRARIES``
#   The libraries needed to use utaust.
#
# If ``utaust_FOUND`` is TRUE, it will also define the following
# imported target:
#
# ``utaust::utaust``
#     The utaust library.

if(NOT utaust_INCLUDE_DIRS)
  # self-implementation find method
  if(utaust_INCLUDE_DIR)
    set(utaust_include_dir_hints "${utaust_INCLUDE_DIR}")
  else()
    set(utaust_include_dir_hints
      "$ENV{HOME}/.local/include"
      "/usr/local/include"
      "/usr/include"
    )
  endif()
  find_path(utaust_INCLUDE_DIR
    NAMES libutaust/utaust.h
    HINTS ${utaust_include_dir_hints}
  )

  if(utaust_INCLUDE_DIR)
    set(utaust_INCLUDE_DIRS "${utaust_INCLUDE_DIR}")
  endif (utaust_INCLUDE_DIR)
endif(NOT utaust_INCLUDE_DIRS)

if(utaust_INCLUDE_DIRS AND NOT utaust_LIBRARIES)
  # self-implementation find method
  if(utaust_LIBRARY)
    if(EXISTS ${utaust_LIBRARY})
      set(utaust_LIBRARIES "${utaust_LIBRARY}")
    else()
      message(FATAL_ERROR "utaust_LIBRARY is set to ${utaust_LIBRARY}, but the file does not exist.")
    endif()
  else()
    # parent path of include path
    get_filename_component(_utaust_include_dir_parent ${utaust_INCLUDE_DIR} DIRECTORY)
    set(utaust_library_hints
      "${_utaust_include_dir_parent}/lib"
      "${utaust_INCLUDE_DIRS}/utaust"
      "$ENV{HOME}/.local/lib"
      "/usr/local/lib"
      "/usr/lib")
    find_library(utaust_LIBRARY
      NAMES utaust
      HINTS ${utaust_library_hints}
    )
  endif()

  if(utaust_LIBRARY)
    set(utaust_LIBRARIES "${utaust_LIBRARY}")
  endif (utaust_LIBRARY)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(utaust
  REQUIRED_VARS utaust_INCLUDE_DIRS utaust_LIBRARIES
)

if(utaust_FOUND)
  add_library(utaust::utaust UNKNOWN IMPORTED)
  set_target_properties(utaust::utaust PROPERTIES
    IMPORTED_LOCATION "${utaust_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${utaust_INCLUDE_DIRS}"
  )
  target_compile_definitions(utaust::utaust INTERFACE)
endif()
mark_as_advanced(utaust_INCLUDE_DIR)

include(FeatureSummary)
set_package_properties(utaust PROPERTIES
  URL "https://github.com/Dreamtonics/libutaust"
  DESCRIPTION "Parsing and writing UST (UTAU Sequence Text) files in C."
)
