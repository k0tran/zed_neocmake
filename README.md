# NeoCMake

This is [CMake](https://cmake.org/) extension for [Zed editor](https://zed.dev/). It combines [uyha/tree-sitter-cmake](https://github.com/uyha/tree-sitter-cmake) and [neocmakelsp/neocmakelsp](https://github.com/neocmakelsp/neocmakelsp) (hence why it's "neo").

## C++ LSP support (`compile_commands.json`)

For that you need to tell cmake to export compile commands.
Example:
1. Add `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` to the `CMakeLists.txt`, somewhere below `project`;
2. Reconfigure. If everything is correct there should be `compile_commands.json` file under build directory. It is also advised to use `CXX=clang` for clangd better compatibility;
3. Go to Zed's `settings.json` (Ctrl+Shift+P `open local settings`/`open default settings`);
5. Inside `lsp` section past the following (replace `build` with your build directory name):
```json
"clangd": {
    "arguments": ["-background-index", "-compile-commands-dir=build"]
}
```

## Tasks

This extension should atomatically create tasks from files.
If you want to use `CMakePresets.json` or `CMakeUserPresets.json` this can be done in tasks menu. Just type `cmake --preset <your-preset-name>` and hit enter.

## Bugs, suggestions, features

Hi! If you encountered a bug or want to contribute - look up existing issues or create one. Note that I sometimes it'll take a bit for me to answer, but I'll try best to maintain this project. Thanks!
