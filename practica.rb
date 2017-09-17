def sum_squares(array)
    if(!array.nil?)
            sum = 0
            array.each { |i| sum += i ** 2 }
            sum
    else
        puts "Objeto Vacio"
    end
end 


CCRIPT = Hash[  "A" => 0, "B" => 1, 
                "C" => 2, "D" => 3,
                "E" => 4, "F" => 5,
                "G" => 6, "H" => 7,
                "I" => 8, "J" => 9,
                "K" => 10, "L" => 11,
                "M" => 12, "N" => 13,
                "O" => 14, "P" => 15,
                "Q" => 16, "R" => 17,
                "S" => 18, "T" => 19,
                "U" => 20, "V" => 21,
                "W" => 22, "X" => 23,
                "Y" => 24, "Z" => 25]



def caesars_crypt(word)

    to_convert = sanitizeInput(word)
    if(to_convert.eql? "")
        puts "La cadena tiene que contener carcteres"
    else
        encrypted = ""
        to_convert.each_char { |c| encrypted += CCRIPT.key((CCRIPT[c] + 13) % 26)}
        encrypted
    end
end


def sanitizeInput(word)
    sanitized = word.delete "^[a-zA-Z]"
    sanitized = sanitized.upcase
end


def palindrome?(word)

    j = ((word.length) -1)
    i = 0
    flag = false
    word.each_char { |c| 
    if(i <= j)
        if(word[c] == word[j])
            flag = true
            j-= 1
            i+= 1
        else
            flag = false
            break
        end
    else
        break
    end
    }
    flag
end

