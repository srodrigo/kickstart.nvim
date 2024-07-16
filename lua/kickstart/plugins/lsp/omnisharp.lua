return {
  setup = function()
    require('lspconfig')['omnisharp'].setup {
      on_attach = function(_, bufnr)
        vim.keymap.set('n', 'gd', "<cmd>lua require('omnisharp_extended').telescope_lsp_definitions()<cr>", { buffer = bufnr, desc = 'Goto [d]efinition' })

        vim.keymap.set('n', 'gr', "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>", { buffer = bufnr, desc = 'Goto [r]eferences' })

        vim.keymap.set(
          'n',
          'gI',
          "<cmd>lua require('omnisharp_extended').telescope_lsp_implementation()<cr>",
          { buffer = bufnr, desc = 'Goto [I]mplementation' }
        )

        vim.keymap.set(
          'n',
          'gD',
          "<cmd>lua require('omnisharp_extended').telescope_type_definitions()<cr>",
          { buffer = bufnr, desc = 'Goto Type [D]efinition' }
        )
      end,
      root_dir = function(fname)
        local lspconfig = require 'lspconfig'
        local primary = lspconfig.util.root_pattern '*.sln'(fname)
        local fallback = lspconfig.util.root_pattern '*.csproj'(fname)
        return primary or fallback
      end,
      enable_roslyn_analyzers = true,
      organize_imports_on_format = true,
      enable_import_completion = true,
      settings = {
        FormattingOptions = {
          -- Enables support for reading code style, naming convention and analyzer
          -- settings from .editorconfig.
          EnableEditorConfigSupport = true,
          -- Specifies whether 'using' directives should be grouped and sorted during
          -- document formatting.
          OrganizeImports = true,
        },
        MsBuild = {
          -- If true, MSBuild project system will only load projects for files that
          -- were opened in the editor. This setting is useful for big C# codebases
          -- and allows for faster initialization of code navigation features only
          -- for projects that are relevant to code that is being edited. With this
          -- setting enabled OmniSharp may load fewer projects and may thus display
          -- incomplete reference lists for symbols.
          LoadProjectsOnDemand = nil,
        },
        RoslynExtensionsOptions = {
          -- Enables support for roslyn analyzers, code fixes and rulesets.
          EnableAnalyzersSupport = true,
          -- Enables support for showing unimported types and unimported extension
          -- methods in completion lists. When committed, the appropriate using
          -- directive will be added at the top of the current file. This option can
          -- have a negative impact on initial completion responsiveness,
          -- particularly for the first few completion sessions after opening a
          -- solution.
          EnableImportCompletion = true,
          -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
          -- true
          AnalyzeOpenDocumentsOnly = nil,
          -- Decompilation support
          EnableDecompilationSupport = true,
          -- Inlay Hints
          InlayHintsOptions = {
            EnableForParameters = true,
            ForLiteralParameters = true,
            ForIndexerParameters = true,
            ForObjectCreationParameters = true,
            ForOtherParameters = true,
            SuppressForParametersThatDifferOnlyBySuffix = false,
            SuppressForParametersThatMatchMethodIntent = false,
            SuppressForParametersThatMatchArgumentName = false,
            EnableForTypes = true,
            ForImplicitVariableTypes = true,
            ForLambdaParameterTypes = true,
            ForImplicitObjectCreation = true,
          },
        },
        Sdk = {
          -- Specifies whether to include preview versions of the .NET SDK when
          -- determining which version to use for project loading.
          IncludePrereleases = true,
        },
      },
    }
  end,
}
