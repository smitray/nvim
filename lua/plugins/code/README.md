# Neovim Code Selection, Editing, and Navigation Guide

This guide documents the advanced code selection, editing, yanking, and deletion capabilities in your Neovim setup, powered by Treesitter and mini.ai.

## Table of Contents
1. [mini.ai Text Objects Cheatsheet](#miniai-text-objects-cheatsheet)
2. [Treesitter Text Objects Cheatsheet](#treesitter-text-objects-cheatsheet)
3. [mini.ai Text Objects with Examples](#miniai-text-objects-with-examples)
4. [Treesitter Text Objects with Examples](#treesitter-text-objects-with-examples)
5. [Treesitter Navigation and Swapping](#treesitter-navigation-and-swapping)
6. [Incremental Selection](#incremental-selection)
7. [Folding](#folding)
8. [Common Use Cases](#common-use-cases)
9. [Cheatsheet: Command Combinations](#cheatsheet-command-combinations)

## mini.ai Text Objects Cheatsheet

The mini.ai plugin provides powerful text objects that can be used with any operator:

| Mode | Keys | Description |
|------|------|-------------|
| v / d / y / c | `a + f` | Around function (e.g., `vaf`, `daf`) |
| v / d / y / c | `i + f` | Inside function (e.g., `vif`, `dif`) |
| v / d / y / c | `a + c` | Around class |
| v / d / y / c | `i + c` | Inside class |
| v / d / y / c | `a + o` | Around block/loop/conditional (if, for) |
| v / d / y / c | `i + o` | Inside block/loop/conditional |
| v / d / y / c | `a + t` | Around tag (e.g., `<div>...</div>`) |
| v / d / y / c | `i + t` | Inside tag content |
| v / d / y / c | `a + d` | Around digit sequence |
| v / d / y / c | `i + d` | Inside digit (same as around for single digit) |
| v / d / y / c | `a + e` | Around smart word (camelCase, PascalCase, etc.) |
| v / d / y / c | `i + e` | Inside smart word |
| v / d / y / c | `a + u` | Around function call |
| v / d / y / c | `i + u` | Inside function call |
| v / d / y / c | `a + U` | Around function call (without dot in name) |
| v / d / y / c | `i + U` | Inside function call (stricter match) |
| v / d / y / c | `a + r` | Around return { ... } table |
| v / d / y / c | `i + r` | Inside return { ... } table |
| v / d / y / c | `a + b` | Around any table literal {} |
| v / d / y / c | `i + b` | Inside any table literal {} |

ℹ️ Use these with any operator:
- `d` = delete
- `y` = yank
- `c` = change
- `v` = visually select
- `g~` = toggle case, etc.

## Treesitter Text Objects Cheatsheet

The nvim-treesitter-textobjects plugin provides language-aware text objects that can be used with any operator:

| Mode | Keys | Description |
|------|------|-------------|
| v / d / y / c | `a=` | Around assignment |
| v / d / y / c | `i=` | Inside assignment |
| v / d / y / c | `l=` | Left side of assignment |
| v / d / y / c | `r=` | Right side of assignment |
| v / d / y / c | `a:` | Around object property |
| v / d / y / c | `i:` | Inside object property |
| v / d / y / c | `l:` | Left part of object property |
| v / d / y / c | `r:` | Right part of object property |
| v / d / y / c | `aa` | Around parameter/argument |
| v / d / y / c | `ia` | Inside parameter/argument |
| v / d / y / c | `ai` | Around conditional |
| v / d / y / c | `ii` | Inside conditional |
| v / d / y / c | `al` | Around loop |
| v / d / y / c | `il` | Inside loop |
| v / d / y / c | `af` | Around function call |
| v / d / y / c | `if` | Inside function call |
| v / d / y / c | `am` | Around method/function definition |
| v / d / y / c | `im` | Inside method/function definition |
| v / d / y / c | `ac` | Around class |
| v / d / y / c | `ic` | Inside class |

ℹ️ Use these with any operator:
- `d` = delete
- `y` = yank
- `c` = change
- `v` = visually select
- `>` = indent
- `<` = unindent, etc.

### Swapping Text Objects

| Keymap | Description |
|--------|-------------|
| `<leader>na` | Swap parameter/argument with next |
| `<leader>n:` | Swap object property with next |
| `<leader>nm` | Swap function with next |
| `<leader>pa` | Swap parameter/argument with previous |
| `<leader>p:` | Swap object property with previous |
| `<leader>pm` | Swap function with previous |

### Navigating Between Text Objects

| Keymap | Description | Keymap | Description |
|--------|-------------|--------|-------------|
| `]f` | Next function call start | `[f` | Previous function call start |
| `]F` | Next function call end | `[F` | Previous function call end |
| `]m` | Next method/function start | `[m` | Previous method/function start |
| `]M` | Next method/function end | `[M` | Previous method/function end |
| `]c` | Next class start | `[c` | Previous class start |
| `]C` | Next class end | `[C` | Previous class end |
| `]i` | Next conditional start | `[i` | Previous conditional start |
| `]I` | Next conditional end | `[I` | Previous conditional end |
| `]l` | Next loop start | `[l` | Previous loop start |
| `]L` | Next loop end | `[L` | Previous loop end |
| `]s` | Next scope | | |
| `]z` | Next fold | | |

### Repeatable Movements

| Keymap | Description |
|--------|-------------|
| `;` | Repeat last treesitter textobject move |
| `,` | Repeat last treesitter textobject move (opposite direction) |

Native `f`, `F`, `t`, and `T` movements are made repeatable with `;` and `,` as well.

## Important Notes on Text Object Overlap

### Function Selection
- **mini.ai**: `af`/`if` - Function definition with its body
- **Treesitter**: `am`/`im` - Method/function definition
- **Treesitter**: `af`/`if` - Function call (not definition)

### Class Selection
- **mini.ai**: `ac`/`ic` - Class with its body
- **Treesitter**: `ac`/`ic` - Class with its body

### Block Selection
- **mini.ai**: `ao`/`io` - Block, conditional or loop (especially good for Lua functions)
- **Treesitter**: `ai`/`ii` - Conditional block specifically
- **Treesitter**: `al`/`il` - Loop block specifically

## mini.ai Text Objects

The mini.ai plugin provides additional text objects that can be used with operators like `d` (delete), `y` (yank), `c` (change), and `v` (visual select):

| Text Object | Description |
|-------------|-------------|
| `ao`/`io` | Around/inside block, conditional or loop (very useful for selecting Lua functions!) |
| `af`/`if` | Around/inside function |
| `ac`/`ic` | Around/inside class |
| `at`/`it` | Around/inside HTML/XML tags |
| `ad`/`id` | Around/inside digits |
| `ae`/`ie` | Around/inside whole words |
| `au`/`iu` | Around/inside function call |
| `aU`/`iU` | Around/inside function call with specific name pattern |
| `ar`/`ir` | Around/inside return {...} table |
| `ab`/`ib` | Around/inside any table literal {} |

## Usage Examples

Here are some practical examples of how to use these text objects with different operators:

### Basic Operations

- `dif` - Delete inside function
- `vao` - Select around block/conditional/loop (perfect for Lua functions)
- `vio` - Select inside block/conditional/loop (body of Lua functions)
- `yac` - Yank around class
- `caa` - Change around argument/parameter
- `vi=` - Visually select inside assignment
- `va:` - Visually select around property
- `ci"` - Change inside quotes
- `dat` - Delete around tag
- `>af` - Indent around function

### Common Use Cases

#### Code Refactoring

- `yaf + ]m + P` - Duplicate a function (yank around function, go to next function, paste before)
- `cim` - Change the implementation of a method while preserving its signature
- `<leader>nm` - Reorder methods in a class
- `daa + f, + p` - Move a parameter to after the next parameter

#### Quick Edits

- `ci=` - Change the right-hand side of an assignment (`let x = 1;` → change only `1`)
- `vil` - Select the body of a loop for modification
- `vii` - Select the body of an if statement
- `da:` - Delete an entire property from an object
- `cin` - Change inside number (using mini.ai's `n` text object)

#### Working with HTML/JSX/Vue Templates

- `vat` - Select an entire HTML tag including its content
- `cit` - Change the content between HTML tags
- `dat` - Delete an entire HTML tag and its content
- `vit` - Select just the content between tags

#### Editing Multiple Lines

- `vaf=` - Select an entire function and then apply indentation
- `vac>` - Select a class and indent it
- `val<` - Select a loop and unindent it

### Detailed Examples

#### Example 1: Lua Function Manipulation

Given this Lua code:
### Function Objects (af/if)
```bash
return {
    "plugin-name/plugin",
    opts = function()
        local util = require("util")
        return {
            setting1 = true,
            setting2 = {
                option1 = "value",
                option2 = false,
            }
        }
    end,
    config = function(_, opts)
        require("plugin").setup(opts)
    end,
}
```

- `vao` - Select the entire function block (when cursor is inside the function)
- `vio` - Select only the body of the function (everything inside but not including `function()` and `end`)
- `dao` - Delete the entire function block
- `cao` - Change the entire function block (delete and enter insert mode)
- `yao` - Yank/copy the entire function block

#### Example 2: Function Manipulation

Given this JavaScript code:
```javascript
function calculateTotal(items, taxRate) {
    let subtotal = 0;
    for (const item of items) {
        subtotal += item.price * item.quantity;
    }
    return subtotal * (1 + taxRate);
}
```

- `vaf` - Visually select the entire function including the name and arguments
- `vif` - Select only the body of the function (inside the curly braces)
- `yaf` - Yank/copy the entire function
- `dif` - Delete only the function body, leaving the function signature
- `caf` - Change the entire function (delete and enter insert mode)
- `vai` - Select the entire if/for statement (the for loop in this example)
- `vil` - Select inside the loop body

#### Example 2: Object Property Manipulation

Given this object:
```javascript
const user = {
    name: "John Doe",
    age: 30,
    email: "john@example.com",
    address: {
        street: "123 Main St",
        city: "Anytown"
    }
};
```

- `va:` - Select a property including the key and value (position cursor on `name:`)
- `vi:` - Select only the value part (`"John Doe"`)
- `di:` - Delete only the value, leaving the key and colon
- `ci:` - Change only the value
- `<leader>n:` - Swap this property with the next one (move `name` after `age`)

#### Example 3: Parameter/Argument Manipulation

Given this function call:
```javascript
fetchUserData("user123", { includeProfile: true }, 30, callback);
```

- `via` - Select inside the first argument (`"user123"`)
- `vaa` - Select the first argument including any comma
- `d2aa` - Delete the first two arguments
- `<leader>na` - Swap the current argument with the next one
- `<leader>pa` - Swap with the previous argument

## Navigation Examples

- `]m` - Go to next function definition
- `[c` - Go to previous class start
- `]L` - Go to next loop end
- `]f;]f` - Go to next function call, then to the function call after that

### Navigation Example

Starting in this file:
```javascript
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }

    getName() {
        return this.name;
    }

    setName(newName) {
        this.name = newName;
    }
}

function processUser(user) {
    console.log(user.getName());
    user.setName("New Name");
}
```

Navigation sequence:
1. Starting at the top, press `]m` to jump to the `constructor` method
2. Press `]m` again to jump to the `getName` method
3. Press `]m` again to jump to the `setName` method
4. Press `]m` again to jump to the `processUser` function
5. Press `[c` to jump back to the `User` class
6. Press `]f` to jump to the first function call (`console.log`)
7. Press `;` to repeat the jump to the next function call (`user.setName`)

## Folding

Treesitter is configured for smart code folding:

- Folding is disabled by default (`foldenable = false`)
- Standard Vim folding commands like `zc` (close fold), `zo` (open fold), `za` (toggle fold) apply
- Folds are defined by Treesitter's understanding of code structure

### Folding Examples

- `zM` - Close all folds in the file
- `zR` - Open all folds in the file
- `]mzc` - Go to next function and close its fold
- `zm` - Increase fold level throughout the file
- `zr` - Reduce fold level throughout the file
- `za` - Toggle fold under cursor
- Place cursor on a function and `zc` to fold just that function
- Place cursor on a class and `zc` to fold the entire class

## Cheatsheet: Common Command Combinations

| Goal | Command Sequence |
|------|------------------|
| Replace a function | `vafp` (select function, paste from register) |
| Swap two arguments | `viay<Right><Right>viavetP` (select first arg, yank, move to second arg, select and exchange with register) |
| Extract variable from expression | `viey` then `Ilet name = <Esc>p` |
| Comment out a block | `vako` (select block, add comment) |
| Move a method up | `vam"ad[mvam"bd[m"ap[m[m"bp` (complex but powerful) |
| Jump between argument positions | `]avi"` (next argument, select inside quotes) |
| Jump to and select function body | `]mvi{` (next method, select inside braces) |
| Rename a variable | `viw"aciwnewName<Esc>n"ap` (select word, change, paste to next occurrence) |
| Fix indentation in a function | `vaf=` (select around function, fix indent) |
