-- 下記リンクの設定をベースにしています。
-- https://zenn.dev/yutakatay/articles/wezterm-intro

local wezterm = require "wezterm"
local act = wezterm.action

local config = {}

--------------------------------------------------
-- シェルの設定
--------------------------------------------------

-- デフォルトのプログラムを設定します。
config.default_prog = {"powershell"}

--------------------------------------------------
-- フォントに関する設定
--------------------------------------------------

-- 使用するフォントを指定します。
config.font = wezterm.font("Ricty Diminished")

-- フォント サイズを指定します。
config.font_size = 14.0

--------------------------------------------------
-- 見た目に関する設定
--------------------------------------------------

-- カラー スキームを指定します。
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "iceberg-dark"

-- タブが一つの場合はタブ バーを表示しないようにします。
config.hide_tab_bar_if_only_one_tab = true

-- フォント サイズに応じた自動ウィンドウ サイズ調整を off にします。
config.adjust_window_size_when_changing_font_size = false

-- 画面を透過させます。
config.window_background_opacity = 0.94

-- タイトルバーを非表示にします。
config.window_decorations = "RESIZE"

-- 画面を最大化して起動するようにします。
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

--------------------------------------------------
-- 操作に関する設定
--------------------------------------------------

-- IME が動作するようにします。
config.use_ime = true

-- 右クリックでクリップボードを使えるようにします。
-- https://github.com/wez/wezterm/discussions/3541
-- 最後の投稿にあるように local act = wezterm.action を本ファイル冒頭で宣言しています。
config.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
            end
        end),
    },
}

--------------------------------------------------
-- キーマップ
--------------------------------------------------

config.leader = {key = "Space", mods = "META"}
config.keys = {
  -- Alt (Opt) + Shift + F でフルスクリーンを切り替えます。
  {
    key = "f",
    mods = "SHIFT|META",
    action = wezterm.action.ToggleFullScreen,
  },
  
  -- Ctrl + Shift + t で新しいタブを作成します。
  {
    key = "t",
    mods = "SHIFT|CTRL",
    action = act.SpawnTab "CurrentPaneDomain",
  },
  
  -- Ctrl + Shift + d で新しいペインを縦分割で作成します。
  {
    key = "d",
    mods = "SHIFT|CTRL",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
  },

  -- Alt + Ctrl + Shift + d で新しいペインを横分割で作成します。
  {
    key = "d",
    mods = "CTRL|META",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
  },

  -- ペインのサイズを変更するキーマップです。
  {
    key = "h",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Left", 5 },
  },
  {
    key = "j",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Down", 5 },
  },
  { 
    key = "k",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Up", 5 },
  },
  {
    key = "l",
    mods = "LEADER",
    action = act.AdjustPaneSize { "Right", 5 },
  },

  -- ペイン間を移動します。
  {
      key = "Tab",
      mods = "LEADER",
      action = act.ActivatePaneDirection "Next",
  },

  -- 現在のペインを最大化/最小化します。
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.TogglePaneZoomState,
  },
}

return config
