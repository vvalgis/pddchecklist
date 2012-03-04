require "rubygems"
require "yaml"
require "ap"

class Question
  attr_reader :no
  def initialize(no, answer)
    @no = no
    @correct_answer = answer
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
  def answer_correct?
    @correct_answer == @answer
  end
  def answer_wrong?
    checked? && !answer_correct?
  end
end

class Bilet
  attr_reader :no
  attr_accessor :questions
  def initialize(no, answers)
    @no = no
    @questions = answers.each_with_index.map {|a, i| Question.new((i + 1), a) }
  end
  def answered?
    @questions.all? {|q| q.checked? }
  end
  def current_question
    @questions.find {|q| !q.checked? }
  end
end

class Book
  attr_reader :bilets, :correct_answers
  def initialize
    filename = File.join(File.expand_path(File.dirname(__FILE__)), 'answers.yml')
    @correct_answers = YAML.load_file(filename)
    @bilets = (1..40).map { |no| Bilet.new(no, @correct_answers[no]) }
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