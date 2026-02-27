(normal_command
  (identifier) @context
  (#eq? @context "project")
  (argument_list
    (argument) @name)) @item

(normal_command
  (identifier) @context
  (#eq? @context "add_executable")
  (argument_list
    (argument) @name)) @item

(normal_command
  (identifier) @context
  (#eq? @context "add_library")
  (argument_list
    (argument) @name)) @item

(normal_command
  (identifier) @context
  (#eq? @context "add_custom_target")
  (argument_list
    (argument) @name)) @item

(function_def
  (function_command
    (argument_list
      (argument) @name))) @item

(macro_def
  (macro_command
    (argument_list
      (argument) @name))) @item

(normal_command
  (identifier) @context
  (#eq? @context "add_subdirectory")
  (argument_list
    (argument) @name)) @item

(normal_command
  (identifier) @context
  (#eq? @context "add_test")
  (argument_list
    (argument) @name)) @item

(normal_command
  (identifier) @context
  (#eq? @context "option")
  (argument_list
    (argument) @name)) @item
