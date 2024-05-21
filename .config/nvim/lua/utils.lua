local M = {}

function M.find_project_root()
    local cwd = vim.fn.expand("%:p:h") -- Get the directory of the current buffer
    local root_markers = { "go.work", "go.mod", ".git", "package.json", "Makefile", "pyproject.toml" }
    local root_dir = cwd

    while root_dir and root_dir ~= "/" do
        for _, marker in ipairs(root_markers) do
            if vim.fn.glob(root_dir .. "/" .. marker) ~= "" then
                print("Root directory: " .. root_dir)
                return root_dir
            end
        end
        root_dir = vim.fn.fnamemodify(root_dir, ":h")
    end
    print("CWD: " .. cwd)
    return root_dir -- Fallback to the current working directory
end

function M.file_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "file"
end

return M
