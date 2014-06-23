Assumptions_
It is assumed that the text file is formatted such that the first line
is the target value and all subsequent lines are formatted with the
item separated from the price like so:

    [item],$[price]

For example:

    $15.05
    mixed fruit,$2.15
    french fries,$2.75
    side salad,$3.35
    hot wings,$3.55
    mozzarella sticks,$4.20
    sampler plate,$5.80

Bugs_
When the .gather_all_combos test is run before the .parse_menu test,
the values given in the test hash bleed into the .parse_menu test.
Otherwise, .parse_menu works fine.

Instructions_
Menu parser is a terminal application. Begin by loading the file
named txi_menu.rb:

    load txi_menu.rb

To parse the file and get a list of combinations, type:

    MenuParser::parse_menu('my_menu.txt')
