local utils = require("utils")

utils.keymap("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
utils.keymap("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git add" })
utils.keymap("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
utils.keymap("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff" })
utils.keymap("n", "<leader>gpl", "<cmd>Git pull<cr>", { desc = "Git pull" })
utils.keymap("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", { desc = "Git push" })
utils.keymap("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
