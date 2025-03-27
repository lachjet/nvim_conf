return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")

    -- Define paths
    local home = os.getenv("HOME")
    local workspace_dir = home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    -- Update jdtls_path with the absolute path to where jdtls is installed
    local jdtls_path = "/lib/jdtls"  -- Change this to the absolute path to your jdtls folder
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local launcher_path = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    -- Ensure launcher_path is valid
    if launcher_path == "" then
      print("Error: Unable to find the JDTLS launcher JAR.")
      return
    end

    local config = {
      cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1G",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher_path, -- Dynamically found path
        "-configuration",
        jdtls_path .. "/config_linux", -- Adjust this for your OS
        "-data",
        workspace_dir,
      },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }),
      settings = {
        java = {
          format = { enabled = true },
          contentProvider = { preferred = "fernflower" },
        },
      },
      init_options = {
        bundles = {},
      },
    }

    -- Start JDTLS
    jdtls.start_or_attach(config)
  end,
}

