-- {{{ keymaps
-- qwerty keymap
local qwerty = {
    -- lowercase rows
    q = { '1', '2', 'w', 'a'           },
    w = { 'q', '2', '3', 'e', 's', 'a' },
    e = { 'w', '3', '4', 'r', 'd', 's' },
    r = { 'e', '4', '5', 't', 'f', 'd' },
    t = { 'r', '5', '6', 'y', 'g', 'f' },
    y = { 't', '6', '7', 'u', 'h', 'g' },
    u = { 'y', '7', '8', 'i', 'j', 'h' },
    i = { 'u', '8', '9', 'o', 'k', 'j' },
    o = { 'i', '9', '0', 'p', 'l', 'k' },
    p = { 'o', '0', '-', '[', ';', 'l' },

    a = { 'q', 'w', 's', 'z'           },
    s = { 'a', 'w', 'e', 'd', 'x', 'z' },
    d = { 's', 'e', 'r', 'f', 'c', 'x' },
    f = { 'd', 'r', 't', 'g', 'v', 'c' },
    g = { 'f', 't', 'y', 'h', 'b', 'v' },
    h = { 'g', 'y', 'u', 'j', 'n', 'b' },
    j = { 'h', 'u', 'i', 'k', 'm', 'n' },
    k = { 'j', 'i', 'o', 'l', ',', 'm' },
    l = { 'k', 'o', 'p', ';', '.', ',' },

    z = { 'a', 's', 'x'                },
    x = { 'z', 's', 'd', 'c', ' '      },
    c = { 'x', 'd', 'f', 'v', ' '      },
    v = { 'c', 'f', 'g', 'b', ' '      },
    b = { 'v', 'g', 'h', 'n', ' '      },
    n = { 'b', 'h', 'j', 'm', ' '      },
    m = { 'n', 'j', 'k', ',', ' '      },

    -- uppercase
    Q = { '!', '@', 'W', 'A'           },
    W = { 'Q', '@', '#', 'E', 'S', 'A' },
    E = { 'W', '#', '$', 'R', 'D', 'S' },
    R = { 'E', '$', '%', 'T', 'F', 'D' },
    T = { 'R', '%', '^', 'Y', 'G', 'F' },
    Y = { 'T', '^', '&', 'U', 'H', 'G' },
    U = { 'Y', '&', '*', 'I', 'J', 'H' },
    I = { 'U', '*', '(', 'O', 'K', 'J' },
    O = { 'I', '(', ')', 'P', 'L', 'K' },
    P = { 'O', ')', '_', '{', ':', 'L' },

    A = { 'Q', 'W', 'S', 'Z'           },
    S = { 'A', 'W', 'E', 'D', 'X', 'Z' },
    D = { 'S', 'E', 'R', 'F', 'C', 'X' },
    F = { 'D', 'R', 'T', 'G', 'V', 'C' },
    G = { 'F', 'T', 'Y', 'H', 'B', 'V' },
    H = { 'G', 'Y', 'U', 'J', 'N', 'B' },
    J = { 'H', 'U', 'I', 'K', 'M', 'N' },
    K = { 'J', 'I', 'O', 'L', '<', 'M' },
    L = { 'K', 'O', 'P', ':', '>', '<' },

    Z = { 'A', 'S', 'X'                },
    X = { 'Z', 'S', 'D', 'C', ' '      },
    C = { 'X', 'D', 'F', 'V', ' '      },
    V = { 'C', 'F', 'G', 'B', ' '      },
    B = { 'V', 'G', 'H', 'N', ' '      },
    N = { 'B', 'H', 'J', 'M', ' '      },
    M = { 'N', 'J', 'K', '<', ' '      },
}

-- table of all keymaps
local keymaps = {
    qwerty = qwerty,
    azerty = nil,
    dvorak = nil,
    colemak = nil,
}
-- }}}

-- {{{ helper functions
local math = math
local rand = math.random

local function get_char(c, keymap)
    local result = keymap[c]

    if result == nil then
        return ''
    else
        return result[rand(1, #result)]
    end
end

local function insert_typos(s, chance, keymap)
    local buf = {}

    local i = 0
    for c in s:gmatch('.') do
        local buf2 = {}

        local random_int = rand(0, 100)

        if c ~= ' ' and random_int < chance then
            if random_int < 3 then

                -- triple-hit
                buf2[#buf2+1] = c
                buf2[#buf2+1] = get_char(c, keymap)
                buf2[#buf2+1] = get_char(c, keymap)

            elseif random_int < 12 then

                -- double-hit
                buf2[#buf2+1] = c
                buf2[#buf2+1] = get_char(c, keymap)

            elseif random_int >= 12 then

                -- single typo
                buf2[#buf2+1] = c

            elseif i + 1 <= #s - 1 then

                local next_char = string.sub(s, i + 1, i + 1)

                -- keys pressed in the wrong order
                if random_int < math.min(chance * 2, 100) and next_char == ' ' then

                    -- space key
                    buf2[#buf2+1] = ' '
                    buf2[#buf2+1] = c

                elseif random_int < chance then

                    -- some other key
                    local new_random_int = rand(0, 100);

                    if new_random_int < math.min(10, chance / 3) then
                        next_char = get_char(next_char, keymap);
                    end

                    buf2[#buf2+1] = next_char
                    buf2[#buf2+1] = c
                end
            end

        else
            buf2[#buf2+1] = c
        end

        buf[#buf+1] = table.concat(buf2)
        i = i + 1;
    end

    return table.concat(buf)
end
-- }}}

-- {{{ return
return {
    keymaps = keymaps,
    mainfunc = insert_typos
}
-- }}}
