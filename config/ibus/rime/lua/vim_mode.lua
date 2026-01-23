-- ~/.config/ibus/rime/lua/vim_mode.lua
local function processor(key, env)
    local engine = env.engine
    local context = engine.context

    -- 检测 vmode 开关
    -- 如果你想全局强制开启，可以把下面这三行注释掉
    if not context:get_option("vmode") then
        return 2 -- kNoop
    end

    local code = key.keycode
    local is_ascii = context:get_option("ascii_mode")

    -- i=105, a=97, o=111, s=115, c=99
    local insert_triggers = { [105] = true, [97] = true, [111] = true, [115] = true, [99] = true }

    -- 1. 按下 Esc (65307)
    if code == 65307 then
        if not is_ascii then
            env.prev_is_cn = true
            context:clear()
            context:set_option("ascii_mode", true)
        end
        return 2
    end

    -- 2. 按下 i/a/o 等进入插入模式
    if is_ascii and env.prev_is_cn and insert_triggers[code] then
        -- IBus 下同样建议手动 commit，防止进入 Vim 时按键丢失
        engine:commit_text(string.char(code))

        context:set_option("ascii_mode", false)
        env.prev_is_cn = false

        return 1 -- 告诉 Rime 我们已经处理完了，停止传播
    end

    return 2
end

return processor
