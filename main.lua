-- code:sub(i, i)
local file = io.open(arg[1], "r")

if not file then
    os.exit(1)
end

local code = file:read("a")
file:close()

local tape = {}
local p = 1
local mp = 1

local loops = {}
local openLoops = {}

-- first fill the tape with 0's
for i = 1, 30000 do
    table.insert(tape, 0)
end

-- check for loops
for i = 1, #code do
    if code:sub(i, i) == "[" then
        table.insert(openLoops, i)
    elseif code:sub(i, i) == "]" then
        local lastLoop = table.remove(openLoops)
        table.insert(loops, { lastLoop, i })
    end
end

--now the code
while p <= #code do
    if code:sub(p, p) == "+" then
        tape[mp] = tape[mp] + 1
        if tape[mp] == 256 then
            tape[mp] = 0
        end
    elseif code:sub(p, p) == "-" then
        tape[mp] = tape[mp] - 1
        if tape[mp] == -1 then
            tape[mp] = 255
        end
    elseif code:sub(p, p) == ">" then
        mp = mp + 1
        if mp == 30001 then
            mp = 1
        end
    elseif code:sub(p, p) == "<" then
        mp = mp - 1
        if mp == 0 then
            mp = 30000
        end
    elseif code:sub(p, p) == "," then
        tape[mp] = string.byte(io.read(1))
    elseif code:sub(p, p) == "." then
        io.write(string.char(tape[mp]))
    elseif code:sub(p, p) == "[" then
        if tape[mp] == 0 then
            for i, v in pairs(loops) do
                if v[1] == p then
                    p = v[2]
                end
            end
        end
    elseif code:sub(p, p) == "]" then
        if tape[mp] ~= 0 then
            for i, v in pairs(loops) do
                if v[2] == p then
                    p = v[1]
                end
            end
        end
    end
    p = p + 1
end