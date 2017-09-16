def sum_squares(array)
    if(!array.nil?)
        if(!array.empty?)

            sum = 0
            array.each { |i| sum+= i ** 2 }
            puts "Number #{sum}"
         else
        puts "Arreglo vacio"

        end
    else
        puts "Objeto Vacio"
    end
end 

CCRIPT = Hash["A" => 0, "B" => 1, 
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

convert = trimChars(word)
if(convert.eql? "")
puts "La cadena tiene que contener carcteres"
else
final = ""
convert.each_char { |c| final += CCRIPT.key((CCRIPT[c] +13) % 25)}
puts "#{convert}"
puts "#{final}"
end
end

def trimChars(word)

trimed = word.delete "^[a-zA-Z]"
trimed = trimed.upcase

end