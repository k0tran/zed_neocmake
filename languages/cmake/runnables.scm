(
  (normal_command
    (identifier) @_cmd
    (#eq? @_cmd "project")
    (argument_list
      (argument) @run @cmake_project))
  (#set! tag cmake-project)
)

(
  (normal_command
    (identifier) @_cmd
    (#eq? @_cmd "add_executable")
    (argument_list
      (argument) @run @cmake_target))
  (#set! tag cmake-executable)
)

(
  (normal_command
    (identifier) @_cmd
    (#eq? @_cmd "add_library")
    (argument_list
      (argument) @run @cmake_target))
  (#set! tag cmake-library)
)

(
  (normal_command
    (identifier) @_cmd
    (#eq? @_cmd "add_custom_target")
    (argument_list
      (argument) @run @cmake_target))
  (#set! tag cmake-custom-target)
)

(
  (normal_command
    (identifier) @_cmd
    (#eq? @_cmd "add_test")
    (argument_list
      (argument) @run @cmake_test))
  (#set! tag cmake-test)
)
