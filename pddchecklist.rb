require "rubygems"
require "yaml"
require "ap"

class Question
  attr_reader :no
  def initialize(no, answer = nil)
    @no = no
    @answer = answer
  end
  def answer(point = nil)
    if point.nil?
      @answer
    else
      @answer = point
    end
  end
  def checked?
    @answer.nil? ? false : true
  end
end

class Bilet
  attr_reader :no
  attr_accessor :questions
  def initialize(no)
    @no = no
    @questions = (1..20).map{ |n| Question.new(n) }
  end
  def answered?
    @questions.all? {|q| q.checked? }
  end
  def current_question
    @questions.find {|q| !q.checked? }
  end
end

class Book
  attr_reader :bilets
  def initialize
    @bilets = (1..40).map{ |n| Bilet.new(n) }
  end
  def done?
    @bilets.all? {|b| b.answered? }
  end
  def current_bilet
    @bilets.find {|b| !b.answered? }
  end
end

class SessionStore
  attr_reader :store_filename, :sessions
  def initialize(filename)
    @store_filename = filename
    @sessions = []
    @sessions = YAML.load_file(@store_filename) if File.exists?(@store_filename)
  end
  def add_session(session)
    @sessions << session
  end
  def save
    f = File.open(@store_filename, 'w')
    YAML.dump(@sessions, f)
    f.close
  end
  def last_session
    last = @sessions.last
    if last.nil? || last.done?
      last = Book.new
      add_session(last)
    end
    last
  end
end