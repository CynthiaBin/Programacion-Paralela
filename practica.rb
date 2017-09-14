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