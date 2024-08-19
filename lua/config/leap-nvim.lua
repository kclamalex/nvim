local leap = require("leap")
local leap_user = require("leap.user")
leap.create_default_mappings()
-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group.
leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
-- Use the traversal keys to repeat the previous motion without explicitly
-- invoking Leap.
leap_user.set_repeat_keys('<enter>', '<backspace>')

-- The below settings make Leap's highlighting closer to what you've been
-- used to in Lightspeed.
vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' }) -- or some grey
vim.api.nvim_set_hl(0, 'LeapMatch', {
  -- For light themes, set to 'black' or similar.
  fg = 'white', bold = true, nocombine = true,
})
