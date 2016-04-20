require './questions.rb'
require './world.rb'
include Questions

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

class Politician < Person
  attr_accessor :party
  def initialize(name, party)
    super(name)
    @party = party
  end
end

class Voter < Person
  attr_accessor :affiliation
  def initialize(name, affiliation)
    super(name)
    @affiliation = affiliation
  end
end

module Election
  # creates a new politician
  def create_politician
    @world.politicians << Politician.new(input_name, input_party)
    main_menu
  end

  # creates a new voter
  def create_voter  
    @world.voters << Voter.new(input_name, input_affiliation)
    main_menu
  end

  # ask the user to input a name
  def input_name
    puts "\nWhat is their name?"
    input = gets.chomp.capitalize
  end

  # ask the user to choose an affiliation
  def input_affiliation
    puts "\nWhat is their party affiliation?"
    puts "(L)iberal, (C)onservative, (T)ea Party, (S)ocialist, (N)eutral."
    input = gets.chomp.downcase
    case input
    when "l"
      "Liberal"
    when "c"
      "Conservative"
    when "t"
      "Tea Party"
    when "s"
      "Socialist"
    when "n"
      "Neutral"
    else
      puts "I don't recognize that affiliation."
      input_affiliation
    end
  end

  # input choice between politician or voter
  def get_politician_or_voter(plural="")
    puts "\n(P)olitician#{plural} or (V)oter#{plural}?"
    input = gets.chomp.downcase
  end

  # asks the user to input a party
  def input_party
    puts "\nWhat is their party?"
    puts "(D)emocrat or (R)epublican"
    input = gets.chomp.downcase
    case input
    when "d"
      "Democrat"
    when "r"
      "Republican"
    else
      puts "I don't recognize that party."
      input_party
    end
  end 

  # prints the list of people 
  def print_list(group)
    group.each do |people|
      if people.class == Politician
        puts "\nPoliticians:"
        puts "#{people.class}, #{people.name}, #{people.party}"
      else
        puts "\nVoters:"
        puts "#{people.class}, #{people.name}, #{people.affiliation}"
      end
    end
  end

  def update
    case get_politician_or_voter
    when "p"
      update_politician
    when "v"
      update_voter
      # print_list(@world.voters)
      # puts "\nWho would you like to update?"
      # input = gets.chomp
      # update_index = @world.voters.index { |person| person.name == input }
      # puts "\nUpdate (N)ame or (P)arty?"
      # input = gets.chomp.downcase
      # case input
      # when "n"
      #   @world.voters[update_index].name = input_name
      #   main_menu
      # when "p"
      #   @world.voters[update_index].affiliation = input_affiliation
      #   main_menu
      # end
    else
      main_menu
    end
  end 

  def update_politician
      print_list(@world.politicians)
      puts "\nWho would you like to update?"
      input = gets.chomp
      update_index = @world.politicians.index { |person| person.name == input }
      puts "Update (N)ame or (A)ffiliation?"
      input = gets.chomp.downcase
      case input
      when "n"
        @world.politicians[update_index].name = input_name
        main_menu
      when "a"
        @world.politicians[update_index].party = input_party
        main_menu
      end  
  end

  def update_voter
    print_list(@world.voters)
    puts "\nWho would you like to update?"
    input = gets.chomp
    update_index = @world.voters.index { |person| person.name == input }
    puts "\nUpdate (N)ame or (P)arty?"
    input = gets.chomp.downcase
    case input
    when "n"
      @world.voters[update_index].name = input_name
      main_menu
    when "p"
      @world.voters[update_index].affiliation = input_affiliation
      main_menu
    end
  end
  
  def delete(group)
    puts "\nWho would you like to delete?"
    input = gets.chomp
    group.delete_if { |person| person.name == input }
    main_menu
  end

  def start
    @world = World.new
    @world.politicians << Politician.new("Kevin", "Democrat")
    @world.politicians << Politician.new("Serena", "Democrat")
    @world.voters << Voter.new("Israel", "Neutral")
    @world.voters << Voter.new("Deven", "Liberal")
    main_menu
  end

  # prompts the user with the main menu options
  def main_menu
    puts Questions.main_menu_prompt
    # puts "\nWhat would you like to do?"
    # puts "(C)reate, (L)ist, (U)pdate, (D)elete" # (E)xit
    input = gets.chomp.downcase
    case input
    when "c"
      case get_politician_or_voter
      when "p"
        create_politician
      when "v"
        create_voter
      else
        puts "\nInvalid option."
        main_menu
      end
    when "l"
      case get_politician_or_voter("s")
      when "p"
        puts "\nPoliticians:"
        print_list(@world.politicians)
        main_menu
      when "v"
        puts "\nVoters:"
        print_list(@world.voters)
        main_menu
      else
        main_menu
      end
    when "u"
      update
    when "d"  
      case get_politician_or_voter
      when "p"
        print_list(@world.politicians)
        delete(@world.politicians)
      when "v"
        print_list(@world.voters)
        delete(@world.voters)
      else
        puts "Not a valid option."
        main_menu
      end
    end
  end
end

include Election
Election.start

#election should contain a world and add politicians and voters to it
# a politician or a voter should not add itself to world when it is created
# the election module should do that