# NeoCMake

This is [CMake](https://cmake.org/) extension for [Zed editor](https://zed.dev/). It combines [uyha/tree-sitter-cmake](https://github.com/uyha/tree-sitter-cmake) and [Decodetalkers/neocmakelsp](https://github.com/Decodetalkers/neocmakelsp) (hence why it's "neo").
The tree-sitter grammar is taken from [helix repo](https://github.com/helix-editor/helix/tree/master/runtime/queries/cmake).

## C++ LSP support (`compile_commands.json`)

For making clangd and cmake work together do the following:

1. Add `set(CMAKE_EXPORT_COMPILE_COMMANDS ON)` at the top of the `CMakeLists.txt` (somewhere below `project`);
2. Reconfigure cmake project. If everything is correct there should be `compile_commands.json` file under build directory;
3. Go to Zed's `settings.json`: Ctrl+Shift+P `open local settings`;
4. Find `lsp` section. Inside it paste the following (replace `build` with your build directory name):

```json
"clangd": {
    "arguments": ["-background-index", "-compile-commands-dir=build"]
}
```

## CMake tasks

Until adding tasks to the extension is possible here are some templates for CMake project. Note that by default **all tasks use `build` directory**, but you can change it 

### Configure

```json
{
  "label": "CMake configure Debug",
  "command": "cmake",
  "args": ["-DCMAKE_BUILD_TYPE=Debug", "-B", "build/"],
  "env": {},
  "use_new_terminal": false,
  "allow_concurrent_runs": false,
  "reveal": "always"
}
```

### Build

```json
{
  "label": "CMake build",
  "command": "cmake",
  "args": ["--build", "build"],
  "env": {},
  "use_new_terminal": false,
  "allow_concurrent_runs": false,
  "reveal": "always"
}
```

### Build and configure

```json
{
  "label": "CMake configure Debug and build",
  "command": "cmake -DCMAKE_BUILD_TYPE=Debug -B build/ && cmake --build build/",
  "args": [],
  "env": {},
  "use_new_terminal": false,
  "allow_concurrent_runs": false,
  "reveal": "always"
}
```

### All together

```json
[
  {
    "label": "CMake configure Debug",
    "command": "cmake",
    "args": ["-DCMAKE_BUILD_TYPE=Debug", "-B", "build/"],
    "env": {},
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always"
  },
  {
    "label": "CMake configure Relase",
    "command": "cmake",
    "args": ["-DCMAKE_BUILD_TYPE=Release", "-B", "build/"],
    "env": {},
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always"
  },
  {
    "label": "CMake build",
    "command": "cmake",
    "args": ["--build", "build"],
    "env": {},
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always"
  },
  {
    "label": "CMake configure Debug and build",
    "command": "cmake -DCMAKE_BUILD_TYPE=Debug -B build/ && cmake --build build/",
    "args": [],
    "env": {},
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always"
  },
  {
    "label": "CMake configure Release and build",
    "command": "cmake -DCMAKE_BUILD_TYPE=Release -B build/ && cmake --build build/",
    "args": [],
    "env": {},
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always"
  }
]
```
