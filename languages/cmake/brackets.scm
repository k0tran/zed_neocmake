("(" @open ")" @close)

(if_condition
  (if_command) @open
  (endif_command) @close)

(foreach_loop
  (foreach_command) @open
  (endforeach_command) @close)

(while_loop
  (while_command) @open
  (endwhile_command) @close)

(function_def
  (function_command) @open
  (endfunction_command) @close)

(macro_def
  (macro_command) @open
  (endmacro_command) @close)

(block_def
  (block_command) @open
  (endblock_command) @close)
