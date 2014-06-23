module MenuParser
  @@target_value = 0
  @@found_combos = []

  def self.parse_menu(file_path_string)
    split_file = parse_by_line(file_path_string)
    menu_items = get_items(split_file)
    menu_prices = get_prices(split_file)
    menu_hashed = hash_menu(menu_items, menu_prices)
    dish_combo = price_combo(@@target_value, menu_hashed)

    if dish_combo
      @@found_combos << dish_combo
      gather_all_combos(dish_combo, menu_hashed)
    end

    @@found_combos.uniq!
    delete_duplicates(@@found_combos)
    formatted_response(@@found_combos)

    @@target_value = 0
    @@found_combos = []
  end

  def self.parse_by_line(file_path_string)
    file_arr = [], split_lines = []
    menu_items = [], prices = []

    File.open(file_path_string, 'r') do |file|
      file.each_line do |line|
        file_arr << line
      end
      file.close
    end

    # unusual behavior; deleting empty arrays
    file_arr.delete([])

    @@target_value = file_arr.shift.chomp[1..-1].to_f

    file_arr.each do |line|
      split_lines << line.split(',')
    end
    split_lines
  end

  def self.get_items(file_arr)
    item_arr = []
    file_arr.each do |menu_line|
      item_arr << menu_line[0]
    end
    item_arr
  end

  def self.get_prices(file_arr)
    price_arr = []
    price_string = ""
    file_arr.each do |menu_line|
      price_string = menu_line[1].chomp
      price_float = price_string[1..-1].to_f
      price_arr << price_float
    end
    price_arr
  end

  def self.hash_menu(item_arr, price_arr)
    menu_hash = {}

    (0...item_arr.length).each do |index|
      menu_hash[item_arr[index]] = price_arr[index]
    end
    menu_hash
  end

  def self.gather_all_combos(combo_arr, menu_hash)
    combo_arr.each do |item|
      menu_hash_clone = menu_hash.clone
      menu_hash_clone.delete(item[0])
      new_combo = price_combo(@@target_value, menu_hash_clone)

      if new_combo
        @@found_combos << new_combo
        gather_all_combos(new_combo, menu_hash_clone)
      end
    end

    @@found_combos
  end

  def self.delete_duplicates(arr)

    arr.each_index do |index|
      arr.each_index do |i|
        if i != index
          if arr[i].length == arr[index].length
            a = arr[index].map{|j| j[0] }
            b = arr[i].map{|j| j[0]}
            complement = a - b
            if complement.empty?
              arr.delete_at(i)
            end
          end
        end
      end
    end

    arr
  end

  def self.price_combo(target, menu_hash)
    return false if menu_hash.empty?
    arr = menu_hash.to_a
    arr.sort!{|v1, v2| v1[1] <=> v2[1]}
    arr.select!{|val| val[1] <= target}

    sum = 0
    check = []

    arr.each_index do |index|
      sum+=arr[index][1]
      check << arr[index]
      arr.each_index do |i|
        if i!= index
          sum+=arr[i][1]
          check << arr[i]
          if sum == target
            return check
          end
        end
      end

      arr.each_index do |j|
        if j!=index
          sum-=arr[j][1]
          check.delete_if{|line_arr| line_arr[0] == arr[j][0] && line_arr[1] == arr[j][1] }

          if sum == target
            return check
          end
        end
      end

      sum = 0
      check = []
    end

    false
  end

  def self.formatted_response(all_combos)
    count = 0
    puts "No combinations possible that equal $#{@@target_value}" if all_combos.empty?

    all_combos.each do |combo|
      count+=1
      puts "Combo No. #{count}"
      combo.each do |item|
        puts "#{item[0]}: $#{item[1]}"
      end
      puts "\n"
    end
  end

  def self.set_found(arr_val)
    @@found_combos << arr_val
  end

  def self.set_target(value)
    @@target_value = value
  end

end
