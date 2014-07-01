require_relative '../lib/txi_menu.rb'

describe "Menu Parser" do

  describe '.parse_by_line' do
    it "splits menu into array of items" do
      result = MenuParser::parse_by_line('menu.txt')
      expect(result.length).to eq(6)
      expect(result[0][0]).to eq('mixed fruit')
      expect(result[3][1]).to eq("$3.55\n")
    end
  end

  describe '.get_items' do
    it "returns array of menu items" do
      parsed = MenuParser::parse_by_line('menu.txt')
      result = MenuParser::get_items(parsed)
      expect(result[1]).to eq('french fries')
      expect(result[4]).to eq('mozzarella sticks')
    end
  end

  describe '.get_prices' do
    it "returns an array of menu prices" do
      parsed = MenuParser::parse_by_line('menu.txt')
      result = MenuParser::get_prices(parsed)
      expect(result[0]).to eq(2.15)
      expect(result[4]).to eq(4.2)
    end
  end

  describe '.hash_menu' do
    it 'puts menu in hash format' do
      parsed = MenuParser::parse_by_line('menu.txt')
      price_arr = MenuParser::get_prices(parsed)
      item_arr = MenuParser::get_items(parsed)
      result = MenuParser::hash_menu(item_arr, price_arr)
      expect(result.count).to eq(6)
      expect(result["mixed fruit"]).to eq(2.15)
      expect(result["hot wings"]).to eq(3.55)
    end
  end

  describe ".price_combo" do
    context "when array is short and combo values adjacent" do
      it "returns correct combination" do
        test_hash = {"this" => 1, "is" => 2, "a" => 3, "test" => 8}
        result = MenuParser::price_combo(6, test_hash)
        expect(result.length).to eq(3)
        expect(result.map{|i| i[0]}).to include("this","is", "a")
      end
    end

    context "no combinations exist" do
      it "returns false" do
        parsed = MenuParser::parse_by_line('menu.txt')
        price_arr = MenuParser::get_prices(parsed)
        item_arr = MenuParser::get_items(parsed)
        menu_hash = MenuParser::hash_menu(item_arr, price_arr)
        result = MenuParser::price_combo(15.05, menu_hash)
        expect(result).to eq(false)
      end
    end

    context "when combo values are not adjacent" do
      it "returns a price combination the sum of which is equal to the target value" do
        result = MenuParser::price_combo(100, {"this" => 1, "is" => 2, "a" => 5, "test" =>98})
        expect(result.length).to eq(2)
        expect(result.map{|i| i[0]}).to include("is", "test")

        result = MenuParser::price_combo(6, {"this" => 1, "is" => 2, "another" => 5, "test" =>98})
        expect(result.length).to eq(2)
        expect(result.map{|i| i[0]}).to include("this", "another")
      end
    end

    context "when combo values are not adjacent and are negative" do
      it "returns a price combination the sum of which is equal to the target value" do
        result = MenuParser::price_combo(99, {"this" => -1, "is" => 2, "a" => 5, "test" =>98})
        expect(result.length).to eq(3)
        expect(result.map{|i| i[0]}).to include("this", "is", "test")
      end
    end

    context "when combo values are floats" do
      it "returns a price combination the sum of which is equal to the target value" do
        result = MenuParser::price_combo(100.7, {"this" => 1, "is" => 2.5, "a" => 5, "test" =>98.2})
        expect(result.length).to eq(2)
        expect(result.map{|i| i[0]}).to include("is", "test")
      end
    end

  end

  describe '.formatted_response' do
    it "prints formatted list of all item combinations" do
      result = MenuParser::formatted_response([[["sliced mango", 2], ["dal tarka", 3]], [["blue moon", 1], ["naan", 4]]])
    end
  end

  describe '.gather_all_combos' do
    xit "determines all possible price combinations equal to target value" do
      MenuParser::set_target(100)
      MenuParser::set_found([["is", 2],["test", 98]])
      test_hash = {"this" =>1 , "is" => 2, "yet" => 3, "another" => 97, "test" => 98}
      result = MenuParser::gather_all_combos([["is", 2], ["test", 98]], test_hash)

      expect(result.length).to eq(3)
      expect(result[2].length).to eq(3)
      expect(result[2].map{|i| i[0]}).to include("this", "is", "another")

    end
  end

  describe '.parse_menu' do
    it "takes in a text file and prints a formatted list of item combinations" do
      puts ">> Original menu file:"
      MenuParser::parse_menu("menu.txt")
      puts "__________"

      puts ">> Test Menu 1"
      MenuParser::parse_menu("spec/test_menu1.txt")
      puts "__________"

      puts ">> Test Menu 2"
      MenuParser::parse_menu("spec/test_menu2.txt")
      puts "__________"

      puts ">> Test Menu 3"
      MenuParser::parse_menu("spec/test_menu3.txt")
    end
  end

end
