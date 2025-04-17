local M = {}

-- Map file extensions to applications
M.file_applications = {
    pdf = "zathura",
    png = "sxiv",
    jpg = "sxiv",
    jpeg = "sxiv",
    gif = "sxiv",
    odt = "libreoffice",
    doc = "libreoffice",
    docx = "libreoffice",
}

-- Special handlers for formats needing more customization
local special_handlers = {
    html = function(path)
        vim.cmd("FloatermNew --title=preview.html --width=150 --height=50 w3m " .. path)
    end,
}

M.open_file = function(path)
    local ext = path:match("^.+%.([^.]+)$")
    if not ext then return false end

    if special_handlers[ext] then
        special_handlers[ext](path)
    elseif M.file_applications[ext] then
        vim.fn.jobstart({ M.file_applications[ext], path }, { detach = true })
    else
        return false
    end

    return true
end

return M
