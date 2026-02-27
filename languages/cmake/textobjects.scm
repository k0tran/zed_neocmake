(function_def) @function.around

(function_def
  (function_command)
  .
  (_)* @function.inner
  (endfunction_command))

(macro_def) @function.around

(macro_def
  (macro_command)
  .
  (_)* @function.inner
  (endmacro_command))

(if_condition) @conditional.around

(if_condition
  (if_command)
  .
  (_)* @conditional.inner
  (endif_command))

(foreach_loop) @loop.around

(foreach_loop
  (foreach_command)
  .
  (_)* @loop.inner
  (endforeach_command))

(while_loop) @loop.around

(while_loop
  (while_command)
  .
  (_)* @loop.inner
  (endwhile_command))

(block_def) @block.around

(block_def
  (block_command)
  .
  (_)* @block.inner
  (endblock_command))

(line_comment) @comment.around
(bracket_comment) @comment.around

(argument_list) @parameter.around
(argument) @parameter.inner

(quoted_argument) @string.around
(bracket_argument) @string.around
