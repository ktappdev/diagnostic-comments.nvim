# Diagnostic Comments for Neovim

A lightweight Neovim plugin that enhances code diagnostics by displaying them as comments.

## Features

- Display diagnostic messages as comments above the corresponding line or inline
- Toggle diagnostic comments on/off with a customizable keymap
- Configurable comment style (above or inline)
- Non-intrusive: uses virtual text to avoid modifying the actual buffer content

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "ktappdev/diagnostic-comments.nvim",
  config = function()
    require("diagnostic_comments").setup({
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
    require('diagnostic_comments').setup({
      -- your configuration here
    })
  end
}
```

## Configuration

Here's an example of how to configure the plugin:

```lua
require('diagnostic_comments').setup({
  comment_style = "above",  -- or "inline"
  keymap = "<leader>dc",    -- customize this to your preferred key mapping
})
```

### Options

- `comment_style`: Determines where the diagnostic comments appear
  - `"above"`: Shows comments on a virtual line above the diagnostic (default)
  - `"inline"`: Shows comments at the end of the line as virtual text
- `keymap`: The key mapping to toggle diagnostic comments on/off

## Usage

After installation and configuration, you can use the plugin as follows:

1. Press your configured keymap (default: `<leader>dc`) to toggle diagnostic comments on/off.
2. When enabled, diagnostic messages will appear as comments either above the line or inline, depending on your configuration.

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
