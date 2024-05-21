local super_word = 'хуе'

-- Функция для разбивки строки на отдельные символы
function split_utf8_string(str)
    local chars = {}
    for pos, codepoint in utf8.codes(str) do
        chars[#chars + 1] = utf8.char(codepoint)
    end
    return chars
end

-- Функция для удаления части слова до первой гласной буквы
function remove_until_vowel(word)
    local vowels = {"а", "е", "ё", "и", "о", "у", "ы", "э", "ю", "я", "А", "Е", "Ё", "И", "О", "У", "Ы", "Э", "Ю", "Я", "a", "e", "i", "o", "u", "A", "E", "I", "O", "U"}
    local chars = split_utf8_string(word)
    local new_word = ""
    local vowel_found = false

    for i = 1, #chars do
        local char = chars[i]
        if not vowel_found then
            for j = 1, #vowels do
                if char == vowels[j] then
                    if char == "о" or char == "О" then
                        char = "ё"
                    end
                    if char == "а" or char == "А" then
                        char = "я"
                    end
                    if char == "у" or char == "У" then
                        char = "ю"
                    end
                    if char == "э" or char == "Э" then
                        char = "е"
                    end
                    if char == "ы" or char == "Ы" then
                        char = "и"
                    end
                    vowel_found = true
                    break
                end
            end
        end
        
        if vowel_found then
            new_word = new_word .. char
        end
    end
    
    return new_word
end

-- Функция для получения последней буквы слова
function get_last_letter(str)
    local chars = split_utf8_string(str)
    return chars[#chars]
end

-- Функция для удаления последней буквы слова
function remove_last_letter(str)
    local chars = split_utf8_string(str)
    local newstr = ""
    for i = 1, #chars - 1 do
        newstr = newstr .. chars[i]
    end
    return newstr
end


-- Основная функция
function create_new_word(input_word)
    local modified_word = remove_until_vowel(input_word)
    if #modified_word < 1 then
        modified_word = get_last_letter(super_word) .. get_last_letter(input_word)
    end
    return remove_last_letter(super_word) .. modified_word
end

local function has_no_letters(str)
    return str:match("[a-zA-Zа-яА-Я]") == nil
end

function process_words(input_string, separator)
    if separator == nil then
        separator = "%s"
    end

    local processed_string = ""
    local first_word = true

    -- Используем gmatch для получения слов из строки
    for word in string.gmatch(input_string, "([^"..separator.."]+)") do
        if not first_word then
            processed_string = processed_string .. " "
        end
        local new_word = create_new_word(word)
        if has_no_letters(word) then
            new_word = word
        end
        processed_string = processed_string .. new_word
        first_word = false
    end

    return processed_string
end

str = 'выше если я 1000$ - шагов иду'

local result = process_words(str)
print(result)
return result