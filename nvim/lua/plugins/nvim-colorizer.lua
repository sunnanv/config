local M = {}

function M.setup()
    require 'colorizer'.setup {
        '*';
        -- An example
        '!css';
        '!html';
        '!tsx';
        '!dart';
    }
end

return M
