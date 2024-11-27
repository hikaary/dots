local wez = require "wezterm"
local act = wez.action
local callback = wez.action_callback

local resurrect = wez.plugin.require "https://github.com/MLFlexer/resurrect.wezterm"

local mod = {
  c = "CTRL",
  s = "SHIFT",
  a = "ALT",
  l = "LEADER",
}

local keybind = function(mods, key, action)
  return { mods = table.concat(mods, "|"), key = key, action = action }
end

local M = {}

local leader = { mods = mod.c, key = "a", timeout_miliseconds = 1000 }

local keys = function()
  local keys = {
    -- CTRL-A, CTRL-A sends CTRL-A
    keybind({ mod.l, mod.c }, "a", act.SendString "\x01"),

    -- pane and tabs
    keybind({ mod.l }, "v", act.SplitHorizontal { domain = "CurrentPaneDomain" }),
    keybind({ mod.l }, "z", act.TogglePaneZoomState),
    keybind({ mod.l }, "c", act.SpawnTab "CurrentPaneDomain"),
    keybind({ mod.l }, "h", act.ActivatePaneDirection "Left"),
    keybind({ mod.l }, "j", act.ActivatePaneDirection "Down"),
    keybind({ mod.l }, "k", act.ActivatePaneDirection "Up"),
    keybind({ mod.l }, "l", act.ActivatePaneDirection "Right"),
    keybind({ mod.l }, "x", act.CloseCurrentPane { confirm = true }),
    keybind({ mod.l, mod.s }, "H", act.AdjustPaneSize { "Left", 5 }),
    keybind({ mod.l, mod.s }, "J", act.AdjustPaneSize { "Down", 5 }),
    keybind({ mod.l, mod.s }, "K", act.AdjustPaneSize { "Up", 5 }),
    keybind({ mod.l, mod.s }, "L", act.AdjustPaneSize { "Right", 5 }),
    keybind({ mod.l, mod.s }, "&", act.CloseCurrentTab { confirm = true }),
    keybind(
      { mod.l },
      "e",
      act.PromptInputLine {
        description = wez.format {
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        },
        action = callback(function(win, _, line)
          if line == "" then
            return
          end
          win:active_tab():set_title(line)
        end),
      }
    ),

    -- workspaces
    keybind({ mod.l }, "w", act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }),
    keybind(
      { mod.l, mod.s },
      "e",

      act.PromptInputLine {
        description = wez.format {
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming workspace title...:" },
        },
        action = callback(function(win, _, line)
          if line == "" then
            return
          end
          wez.mux.rename_workspace(wez.mux.get_active_workspace(), line)
        end),
      }
    ),

    -- copy and paste
    keybind({ mod.c, mod.s }, "v", act.PasteFrom "Clipboard"),
    keybind({ mod.c, mod.s }, "c", act.CopyTo "Clipboard"),

    -- launch spotify_player as a small pane in the bottom
    keybind(
      { mod.l },
      "s",
      act.SplitPane {
        direction = "Down",
        command = { args = { "spotify_player" } },
        size = { Cells = 6 },
      }
    ),

    -- update all plugins
    keybind(
      { mod.l },
      "u",
      callback(function(win)
        wez.plugin.update_all()
        win:toast_notification("wezterm", "plugins updated!", nil, 4000)
      end)
    ),

    -- Сохранение текущего рабочего пространства
    keybind(
      { mod.l, mod.a },
      "s",
      callback(function(win, pane)
        resurrect.save_state(resurrect.workspace_state.get_workspace_state())
        resurrect.window_state.save_window_action()
      end)
    ),

    -- Сохранение текущего окна
    keybind({ mod.l, mod.s }, "w", resurrect.window_state.save_window_action()),

    -- Сохранение текущей вкладки
    keybind({ mod.l, mod.s }, "t", resurrect.tab_state.save_tab_action()),

    -- Восстановление состояния через fuzzy finder
    keybind(
      { mod.l, mod.a },
      "r",
      callback(function(win, pane)
        resurrect.fuzzy_load(win, pane, function(id, label)
          local type = string.match(id, "^([^/]+)") -- поиск до '/'
          id = string.match(id, "([^/]+)$") -- поиск после '/'
          id = string.match(id, "(.+)%..+$") -- удаление расширения файла
          local opts = {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          }
          if type == "workspace" then
            local state = resurrect.load_state(id, "workspace")
            resurrect.workspace_state.restore_workspace(state, opts)
          elseif type == "window" then
            local state = resurrect.load_state(id, "window")
            resurrect.window_state.restore_window(pane:window(), state, opts)
          elseif type == "tab" then
            local state = resurrect.load_state(id, "tab")
            resurrect.tab_state.restore_tab(pane:tab(), state, opts)
          end
        end)
      end)
    ),

    -- Удаление сохраненных состояний через fuzzy finder
    keybind(
      { mod.l, mod.a },
      "d",
      callback(function(win, pane)
        resurrect.fuzzy_load(win, pane, function(id)
          resurrect.delete_state(id)
        end, {
          title = "Delete State",
          description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
          fuzzy_description = "Search State to Delete: ",
          is_fuzzy = true,
        })
      end)
    ),
  }

  -- tab navigation
  for i = 1, 9 do
    table.insert(keys, keybind({ mod.l }, tostring(i), act.ActivateTab(i - 1)))
  end
  return keys
end

M.apply_to_config = function(c)
  c.treat_left_ctrlalt_as_altgr = true
  c.leader = leader
  c.keys = keys()
end

return M
