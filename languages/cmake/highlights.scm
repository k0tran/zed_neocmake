(line_comment) @comment
(bracket_comment) @comment

(quoted_argument) @string
(bracket_argument) @string
(bracket_argument_content) @string

(variable) @property

"$" @punctuation.special
"{" @punctuation.special
"}" @punctuation.special

((unquoted_argument) @number
  (#match? @number "^[0-9]+\\.?[0-9]*$"))

(escape_sequence) @string.escape

"(" @punctuation.bracket
")" @punctuation.bracket

(if) @keyword.control
(elseif) @keyword.control
(else) @keyword.control
(endif) @keyword.control
(foreach) @keyword.control
(endforeach) @keyword.control
(while) @keyword.control
(endwhile) @keyword.control

(function) @keyword.function
(endfunction) @keyword.function
(macro) @keyword.function
(endmacro) @keyword.function

(block) @keyword
(endblock) @keyword

(function_command
  (argument_list
    .
    (argument) @function.definition))

(macro_command
  (argument_list
    .
    (argument) @function.definition))

(normal_command
  (identifier) @function.builtin
  (#eq? @function.builtin "project"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "add_executable"
    "add_library"
    "add_custom_target"
    "add_custom_command"
    "add_subdirectory"
    "add_dependencies"
    "add_test"
    "add_compile_definitions"
    "add_compile_options"
    "add_link_options"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "find_package"
    "find_library"
    "find_path"
    "find_file"
    "find_program"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "include"
    "include_directories"
    "include_guard"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "target_compile_definitions"
    "target_compile_features"
    "target_compile_options"
    "target_include_directories"
    "target_link_directories"
    "target_link_libraries"
    "target_link_options"
    "target_precompile_headers"
    "target_sources"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "set"
    "unset"
    "set_property"
    "set_target_properties"
    "set_source_files_properties"
    "set_tests_properties"
    "set_directory_properties"
    "get_property"
    "get_target_property"
    "get_source_file_property"
    "get_test_property"
    "get_directory_property"
    "get_cmake_property"
    "define_property"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "file"
    "configure_file"
    "write_file"
    "install"
    "export"
    "cmake_path"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "string"
    "list"
    "separate_arguments"
    "math"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "message"
    "cmake_print_properties"
    "cmake_print_variables"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "option"
    "mark_as_advanced"
    "variable_watch"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "cmake_minimum_required"
    "cmake_policy"
    "cmake_parse_arguments"
    "cmake_language"
    "cmake_host_system_information"
    "cmake_dependent_option"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "enable_testing"
    "ctest_test"
    "ctest_build"
    "ctest_configure"
    "ctest_coverage"
    "ctest_memcheck"
    "ctest_start"
    "ctest_submit"
    "ctest_upload"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "execute_process"
    "try_compile"
    "try_run"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "link_directories"
    "link_libraries"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "aux_source_directory"
    "source_group"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "enable_language"
    "get_filename_component"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "FetchContent_Declare"
    "FetchContent_MakeAvailable"
    "FetchContent_GetProperties"
    "FetchContent_Populate"
    "FetchContent_SetPopulated"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "ExternalProject_Add"
    "ExternalProject_Add_Step"
    "ExternalProject_Add_StepDependencies"
    "ExternalProject_Add_StepTargets"
    "ExternalProject_Get_Property"))

(normal_command
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "cpack_add_component"
    "cpack_add_component_group"
    "cpack_add_install_type"
    "cpack_configure_downloads"))

(normal_command
  (identifier) @keyword.control
  (#any-of? @keyword.control
    "return"
    "break"
    "continue"))

(normal_command
  (identifier) @function)

(identifier) @function

((unquoted_argument) @constant
  (#any-of? @constant
    "PUBLIC"
    "PRIVATE"
    "INTERFACE"
    "IMPORTED"
    "ALIAS"
    "SHARED"
    "STATIC"
    "MODULE"
    "OBJECT"
    "EXCLUDE_FROM_ALL"
    "WIN32"
    "MACOSX_BUNDLE"
    "REQUIRED"
    "COMPONENTS"
    "CONFIG"
    "OPTIONAL_COMPONENTS"
    "QUIET"
    "NO_MODULE"
    "GLOBAL"))

((unquoted_argument) @constant
  (#any-of? @constant
    "FATAL_ERROR"
    "SEND_ERROR"
    "WARNING"
    "AUTHOR_WARNING"
    "STATUS"
    "VERBOSE"
    "DEBUG"
    "TRACE"
    "NOTICE"
    "DEPRECATION"
    "CHECK_START"
    "CHECK_PASS"
    "CHECK_FAIL"))

((unquoted_argument) @boolean
  (#any-of? @boolean
    "TRUE"
    "FALSE"
    "ON"
    "OFF"
    "YES"
    "NO"))

((unquoted_argument) @keyword.operator
  (#any-of? @keyword.operator
    "AND"
    "OR"
    "NOT"
    "LESS"
    "GREATER"
    "EQUAL"
    "LESS_EQUAL"
    "GREATER_EQUAL"
    "STRLESS"
    "STRGREATER"
    "STREQUAL"
    "STRLESS_EQUAL"
    "STRGREATER_EQUAL"
    "VERSION_LESS"
    "VERSION_GREATER"
    "VERSION_EQUAL"
    "VERSION_LESS_EQUAL"
    "VERSION_GREATER_EQUAL"
    "IN_LIST"
    "DEFINED"
    "MATCHES"
    "EXISTS"
    "IS_DIRECTORY"
    "IS_SYMLINK"
    "IS_ABSOLUTE"
    "COMMAND"
    "POLICY"
    "TARGET"
    "TEST"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "IN"
    "ITEMS"
    "LISTS"
    "RANGE"
    "ZIP_LISTS"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "CACHE"
    "PARENT_SCOPE"
    "FORCE"
    "INTERNAL"
    "BOOL"
    "FILEPATH"
    "PATH"
    "STRING"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "APPEND"
    "WRITE"
    "READ"
    "COPY"
    "RENAME"
    "REMOVE"
    "MAKE_DIRECTORY"
    "GLOB"
    "GLOB_RECURSE"
    "DOWNLOAD"
    "UPLOAD"
    "GENERATE"
    "TOUCH"
    "CHMOD"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "VERSION"
    "LANGUAGES"
    "DESCRIPTION"
    "HOMEPAGE_URL"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "FATAL_ERROR"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "DESTINATION"
    "TARGETS"
    "FILES"
    "DIRECTORY"
    "PROGRAMS"
    "RUNTIME"
    "LIBRARY"
    "ARCHIVE"
    "FRAMEWORK"
    "BUNDLE"
    "INCLUDES"
    "EXPORT"
    "NAMESPACE"
    "FILE_SET"
    "PERMISSIONS"
    "CONFIGURATIONS"
    "COMPONENT"
    "OPTIONAL"
    "EXCLUDE_FROM_ALL"
    "RENAME"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "PROPERTIES"
    "PROPERTY"
    "APPEND"
    "APPEND_STRING"
    "BRIEF_DOCS"
    "FULL_DOCS"
    "INHERITED"))

((unquoted_argument) @keyword
  (#any-of? @keyword
    "COMPILE_LANGUAGE"
    "COMPILE_FEATURES"
    "CONFIG"
    "PLATFORM_ID"
    "C_COMPILER_ID"
    "CXX_COMPILER_ID"
    "TARGET_FILE"
    "TARGET_FILE_NAME"
    "TARGET_FILE_DIR"
    "TARGET_PROPERTY"
    "BUILD_INTERFACE"
    "INSTALL_INTERFACE"))

((unquoted_argument) @type
  (#any-of? @type
    "CMAKE_C_COMPILER"
    "CMAKE_C_COMPILER_ID"
    "CMAKE_C_COMPILER_VERSION"
    "CMAKE_C_STANDARD"
    "CMAKE_C_STANDARD_REQUIRED"
    "CMAKE_C_EXTENSIONS"
    "CMAKE_C_FLAGS"
    "CMAKE_CXX_COMPILER"
    "CMAKE_CXX_COMPILER_ID"
    "CMAKE_CXX_COMPILER_VERSION"
    "CMAKE_CXX_STANDARD"
    "CMAKE_CXX_STANDARD_REQUIRED"
    "CMAKE_CXX_EXTENSIONS"
    "CMAKE_CXX_FLAGS"
    "CMAKE_BUILD_TYPE"
    "CMAKE_CONFIGURATION_TYPES"
    "CMAKE_EXPORT_COMPILE_COMMANDS"
    "CMAKE_POSITION_INDEPENDENT_CODE"
    "CMAKE_VERBOSE_MAKEFILE"
    "CMAKE_SOURCE_DIR"
    "CMAKE_BINARY_DIR"
    "CMAKE_CURRENT_SOURCE_DIR"
    "CMAKE_CURRENT_BINARY_DIR"
    "CMAKE_CURRENT_LIST_DIR"
    "CMAKE_MODULE_PATH"
    "CMAKE_PREFIX_PATH"
    "CMAKE_INSTALL_PREFIX"
    "CMAKE_INSTALL_BINDIR"
    "CMAKE_INSTALL_LIBDIR"
    "CMAKE_INSTALL_INCLUDEDIR"
    "CMAKE_RUNTIME_OUTPUT_DIRECTORY"
    "CMAKE_LIBRARY_OUTPUT_DIRECTORY"
    "CMAKE_ARCHIVE_OUTPUT_DIRECTORY"
    "PROJECT_NAME"
    "PROJECT_VERSION"
    "PROJECT_SOURCE_DIR"
    "PROJECT_BINARY_DIR"
    "CMAKE_EXE_LINKER_FLAGS"
    "CMAKE_SHARED_LINKER_FLAGS"
    "BUILD_TESTING"
    "CMAKE_AUTOMOC"
    "CMAKE_AUTOUIC"
    "CMAKE_AUTORCC"
    "CMAKE_INSTALL_RPATH"
    "CMAKE_MACOSX_RPATH"
    "CMAKE_DEBUG_POSTFIX"))

((variable) @variable.builtin
  (#any-of? @variable.builtin
    "PROJECT_NAME"
    "PROJECT_VERSION"
    "PROJECT_VERSION_MAJOR"
    "PROJECT_VERSION_MINOR"
    "PROJECT_VERSION_PATCH"
    "PROJECT_VERSION_TWEAK"
    "PROJECT_DESCRIPTION"
    "PROJECT_HOMEPAGE_URL"
    "PROJECT_SOURCE_DIR"
    "PROJECT_BINARY_DIR"
    "CMAKE_VERSION"
    "CMAKE_MAJOR_VERSION"
    "CMAKE_MINOR_VERSION"
    "CMAKE_PATCH_VERSION"
    "CMAKE_SOURCE_DIR"
    "CMAKE_BINARY_DIR"
    "CMAKE_CURRENT_SOURCE_DIR"
    "CMAKE_CURRENT_BINARY_DIR"
    "CMAKE_CURRENT_LIST_DIR"
    "CMAKE_CURRENT_LIST_FILE"
    "CMAKE_CURRENT_LIST_LINE"
    "CMAKE_CURRENT_FUNCTION"
    "CMAKE_CURRENT_FUNCTION_LIST_DIR"
    "CMAKE_CURRENT_FUNCTION_LIST_FILE"
    "CMAKE_CURRENT_FUNCTION_LIST_LINE"
    "CMAKE_PARENT_LIST_FILE"
    "CMAKE_MODULE_PATH"
    "CMAKE_PREFIX_PATH"
    "CMAKE_INSTALL_PREFIX"
    "CMAKE_INSTALL_BINDIR"
    "CMAKE_INSTALL_LIBDIR"
    "CMAKE_INSTALL_INCLUDEDIR"
    "CMAKE_INSTALL_DATADIR"
    "CMAKE_C_COMPILER"
    "CMAKE_C_COMPILER_ID"
    "CMAKE_C_COMPILER_VERSION"
    "CMAKE_C_STANDARD"
    "CMAKE_C_STANDARD_REQUIRED"
    "CMAKE_C_EXTENSIONS"
    "CMAKE_C_FLAGS"
    "CMAKE_C_FLAGS_DEBUG"
    "CMAKE_C_FLAGS_RELEASE"
    "CMAKE_C_FLAGS_RELWITHDEBINFO"
    "CMAKE_C_FLAGS_MINSIZEREL"
    "CMAKE_CXX_COMPILER"
    "CMAKE_CXX_COMPILER_ID"
    "CMAKE_CXX_COMPILER_VERSION"
    "CMAKE_CXX_STANDARD"
    "CMAKE_CXX_STANDARD_REQUIRED"
    "CMAKE_CXX_EXTENSIONS"
    "CMAKE_CXX_FLAGS"
    "CMAKE_CXX_FLAGS_DEBUG"
    "CMAKE_CXX_FLAGS_RELEASE"
    "CMAKE_CXX_FLAGS_RELWITHDEBINFO"
    "CMAKE_CXX_FLAGS_MINSIZEREL"
    "CMAKE_BUILD_TYPE"
    "CMAKE_CONFIGURATION_TYPES"
    "CMAKE_GENERATOR"
    "CMAKE_GENERATOR_PLATFORM"
    "CMAKE_GENERATOR_TOOLSET"
    "CMAKE_MAKE_PROGRAM"
    "CMAKE_EXPORT_COMPILE_COMMANDS"
    "CMAKE_POSITION_INDEPENDENT_CODE"
    "CMAKE_VERBOSE_MAKEFILE"
    "CMAKE_COLOR_MAKEFILE"
    "CMAKE_RUNTIME_OUTPUT_DIRECTORY"
    "CMAKE_LIBRARY_OUTPUT_DIRECTORY"
    "CMAKE_ARCHIVE_OUTPUT_DIRECTORY"
    "CMAKE_SYSTEM"
    "CMAKE_SYSTEM_NAME"
    "CMAKE_SYSTEM_VERSION"
    "CMAKE_SYSTEM_PROCESSOR"
    "CMAKE_HOST_SYSTEM"
    "CMAKE_HOST_SYSTEM_NAME"
    "CMAKE_HOST_SYSTEM_VERSION"
    "CMAKE_HOST_SYSTEM_PROCESSOR"
    "CMAKE_SIZEOF_VOID_P"
    "CMAKE_CROSSCOMPILING"
    "WIN32"
    "APPLE"
    "UNIX"
    "LINUX"
    "MSVC"
    "MINGW"
    "CYGWIN"
    "ANDROID"
    "IOS"
    "CMAKE_EXE_LINKER_FLAGS"
    "CMAKE_SHARED_LINKER_FLAGS"
    "CMAKE_MODULE_LINKER_FLAGS"
    "CMAKE_STATIC_LINKER_FLAGS"
    "CMAKE_SKIP_RPATH"
    "CMAKE_SKIP_BUILD_RPATH"
    "CMAKE_BUILD_WITH_INSTALL_RPATH"
    "CMAKE_INSTALL_RPATH"
    "CMAKE_INSTALL_RPATH_USE_LINK_PATH"
    "CMAKE_MACOSX_RPATH"
    "CMAKE_FIND_ROOT_PATH"
    "CMAKE_FIND_ROOT_PATH_MODE_PROGRAM"
    "CMAKE_FIND_ROOT_PATH_MODE_LIBRARY"
    "CMAKE_FIND_ROOT_PATH_MODE_INCLUDE"
    "CMAKE_FIND_ROOT_PATH_MODE_PACKAGE"
    "CMAKE_CTEST_COMMAND"
    "BUILD_TESTING"
    "CMAKE_INCLUDE_CURRENT_DIR"
    "CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE"
    "CMAKE_DEBUG_POSTFIX"
    "CMAKE_AUTOMOC"
    "CMAKE_AUTOUIC"
    "CMAKE_AUTORCC"
    "CMAKE_POLICY_DEFAULT_CMP0077"
    "CACHE"
    "ARGC"
    "ARGV"
    "ARGN"
    "ARGV0"
    "ARGV1"
    "ARGV2"
    "ARGV3"
    "ARGV4"
    "ARGV5"
    "ARGV6"
    "ARGV7"
    "ARGV8"
    "ARGV9"))
