-- 下記リンクの設定をベースにしています。
-- https://zenn.dev/yutakatay/articles/wezterm-intro

local wezterm = require 'wezterm';
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
config.window_background_opacity = 0.85

-- フルスクリーンで起動するようにします。
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
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

config.keys = {
  -- Alt (Opt) + Shift + F でフルスクリーンを切り替えます。
  {
    key = 'f',
    mods = 'SHIFT|META',
    action = wezterm.action.ToggleFullScreen,
  },
}

return config