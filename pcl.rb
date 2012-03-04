#!/usr/bin/env ruby
$KCODE='u'
require "./pddchecklist"
require "ncurses"
STORE_FILE = File.join(File.expand_path(File.dirname(__FILE__)), 'pdd.yml')

class NcursesInterface

  def initialize
    @session_store = SessionStore.new(STORE_FILE)
    @book = @session_store.last_session
  end

  def gap(no)
    case no
    when 1..5 then 0
    when 6..10 then 1
    when 11..15 then 2
    when 16..20 then 3  
    end
  end

  def redraw_main_layout
    @window.move 0, 0
    @window.attrset(Ncurses.COLOR_PAIR(1))
    @window.printw("Answers for sheets\n")
    @window.attrset(Ncurses.COLOR_PAIR(2))
    @cb, @cq = current_position
    print_book(@book)
    @window.move @lines, 0
    @window.addstr "Bilet: #{@cb} Question: #{@cq} >> "
    @window.mvaddstr @lines, 27, ' '
    @window.move @lines, 26
  end

  def print_book(book) 
    book.bilets.each do |bilet|
      @window.move 1, (bilet.no * 2)
      print_bilet(bilet)
    end
  end

  def print_bilet(bilet)
    @window.attrset(Ncurses.COLOR_PAIR(1)) if bilet.no == @cb.to_i
    bilet.questions.each do |question|
      @window.move((question.no + gap(question.no)), ((bilet.no - 1) * 3))
      print_question(question, bilet)
    end
    @window.attrset(Ncurses.COLOR_PAIR(2))
  end

  def print_question(question, bilet)
    answer = question.answer
    answer = '-' if answer.nil?
    answer = answer.to_s.ljust(1) if @cb < 10
    if (bilet.no == @cb.to_i && question.no == @cq.to_i) || question.answer_wrong?
      @window.attrset(Ncurses.COLOR_PAIR(3)) 
    end
    @window.addstr(answer.to_s)
    if bilet.no == @cb.to_i
      @window.attrset(Ncurses.COLOR_PAIR(1)) 
    else
      @window.attrset(Ncurses.COLOR_PAIR(2)) 
    end
  end

  def current_position
    cb = @book.current_bilet
    [cb.no, cb.current_question.no]
  end

  def run
    @window = Ncurses.initscr
    Ncurses.cbreak
    lines, cols = [], []
    @window.getmaxyx(lines, cols)
    @lines = lines.first - 1
    @cols = cols.first - 1
    
    
    Ncurses.start_color
    Ncurses.init_pair(1, Ncurses::COLOR_WHITE, Ncurses::COLOR_BLUE)
    Ncurses.init_pair(2, Ncurses::COLOR_GREEN, Ncurses::COLOR_BLACK)
    Ncurses.init_pair(3, Ncurses::COLOR_RED, Ncurses::COLOR_BLACK)

    loop do
      redraw_main_layout
      ch = @window.getch
      break if ch == ?q
      next unless (?1..?9).include?(ch)
      @book.current_bilet.current_question.answer(ch.chr.to_i)
      @window.refresh
    end

  ensure
    @session_store.save
    Ncurses.endwin
  end

end


NcursesInterface.new.run

