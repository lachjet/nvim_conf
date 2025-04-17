local M = {}

M.file_openers = {
    pdf = function(path) vim.fn.jobstart({ "zathura", path }, { detach = true }) end,
    png = function(path) vim.fn.jobstart({ "sxiv", path }, { detach = true }) end,
    jpg = function(path) vim.fn.jobstart({ "sxiv", path }, { detach = true }) end,
    jpeg = function(path) vim.fn.jobstart({ "sxiv", path }, { detach = true }) end,
    gif = function(path) vim.fn.jobstart({ "sxiv", path }, { detach = true }) end,
    html = function(path) vim.cmd("FloatermNew --title=preview.html --width=150 --height=50 w3m " .. path) end,
    odt = function(path) vim.fn.jobstart({ "libreoffice", path }, { detach = true }) end,
    doc = function(path) vim.fn.jobstart({ "libreoffice", path }, { detach = true }) end,
    docx = function(path) vim.fn.jobstart({ "libreoffice", path }, { detach = true }) end,
}

M.open_file = function(path)
    local ext = path:match("^.+%.([^.]+)$")
    if ext and M.file_openers[ext] then
        M.file_openers[ext](path)
    else
        return false
    end
    return true
end

return M
