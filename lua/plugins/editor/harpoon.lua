-- ~/.config/nvim/lua/plugins/editor/harpoon.lua

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    -- Basic setup
    harpoon:setup()

    -- Keymaps
    vim.keymap.set("n", "<leader>ha", function()
      harpoon:list():add()
      vim.notify("Harpooned file: " .. vim.fn.expand("%:t"), vim.log.levels.INFO, { title = "Harpoon" })
    end, { desc = "Harpoon: Add file" })

    vim.keymap.set("n", "<leader>hm", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Toggle Menu" })

    -- Navigation to marks
    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "Harpoon: Go to mark 1" })

    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "Harpoon: Go to mark 2" })

    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "Harpoon: Go to mark 3" })

    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "Harpoon: Go to mark 4" })

    -- Cycle through marks
    vim.keymap.set("n", "<leader>hn", function()
      harpoon:list():next()
    end, { desc = "Harpoon: Next Mark" })

    vim.keymap.set("n", "<leader>hp", function()
      harpoon:list():prev()
    end, { desc = "Harpoon: Previous Mark" })
  end,
}
