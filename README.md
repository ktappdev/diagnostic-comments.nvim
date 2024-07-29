# Diagnostic Comments for Neovim

A lightweight Neovim plugin that enhances code diagnostics by displaying them as comments above the current line.

This was made for me and this is how I use it with the amazing melbaldove/llm.nvim.

https://github.com/user-attachments/assets/5850d9ab-998b-48f3-81b6-ce8ec1208e8b

In a nutshell it dumps the error to a comment abone the line with the error.

Perfect for copying to llms

## Features

- Display diagnostic messages as comments on the current line
- Toggle diagnostic comments on/off with a customizable keymap
- Configurable comment style (above or inline)
- Option to use virtual text or actual comments
- Focus on the current line for improved performance and usability

- I originally wrote this plugin to make my workflow with llm.nvim smoother, Yes I am truely lazy.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "ktappdev/diagnostic-comments.nvim",
  config = function()
    require("diagnostic-comments").setup({
      -- your configuration here
    })
  end,
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'ktappdev/diagnostic-comments.nvim',
  config = function()
    require('diagnostic-comments').setup({
      -- your configuration here
    })
  end
}
```

## Configuration

Here's an example of how to configure the plugin:
These are the defaults, so if this works for you there is nothing to set.

```lua
require('diagnostic-comments').setup({
  comment_style = "above",  -- or "inline"
  keymap = "<leader>dc",     -- customize this to your preferred key mapping
  comment_prefix = "//",     -- prefix for comments
  use_virtual_text = false    -- set to true for virtual text
})
```

### Options

- `comment_style`: Determines where the diagnostic comments appear
  - `"above"`: Shows comments on a line above the diagnostic
  - `"inline"`: Shows comments at the end of the line (default)
- `keymap`: The key mapping to toggle diagnostic comments on/off
- `comment_prefix`: The prefix used for comments (default: "--")
- `use_virtual_text`: Whether to use virtual text (true) or actual comments (false)

## Usage

After installation and configuration, you can use the plugin as follows:

1. Move your cursor to a line with a diagnostic.
2. Press your configured keymap (default: `<leader>dc`) to toggle the diagnostic comment on/off for that line.
3. The diagnostic message will appear as a comment either above the line or inline, depending on your configuration.

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Before submitting a pull request, please ensure:

- Your code follows the existing style to maintain consistency
- You've added tests if you've introduced new functionality
- All tests pass when you run the test suite
- You've updated the documentation to reflect any changes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the Neovim community for inspiration and support
- Shout out to all contributors who help improve this plugin

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.
We appreciate your feedback and contributions to make this plugin better!

## Roadmap

Here are some features and improvements we're considering for future releases:

1. **Auto-detect comment style**: Automatically detect and use the appropriate comment syntax for the current file type (e.g., '//' for JavaScript, '#' for Python, '--' for Lua).

2. **Multiple diagnostic display**: Show multiple diagnostics for a single line, either as separate comments or in a condensed format.

3. **Customizable formatting**: Allow users to customize the format of diagnostic comments, including severity icons, colors, and text formatting.

4. **Integration with other plugins**: Explore integration possibilities with popular Neovim plugins like Telescope or nvim-cmp for enhanced functionality.

5. **Floating window option**: Add an option to display diagnostics in a floating window instead of as comments.

6. **Diagnostic filtering**: Allow users to filter which types of diagnostics are displayed (e.g., only errors, or exclude certain diagnostic codes).

7. **Localization support**: Add support for displaying diagnostic messages in different languages.

8. **Performance optimizations**: Continuous improvements to ensure the plugin remains fast and efficient, especially for large files.

9. **Code actions integration**: Provide quick-fix options directly from the diagnostic comments.

We welcome community input on prioritizing these features and suggestions for additional improvements!
