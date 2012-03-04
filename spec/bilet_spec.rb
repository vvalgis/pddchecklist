require 'pddchecklist'

describe Bilet do
  before(:each) do
    @no = rand(5)+1
    @bilet = Bilet.new(@no, (1..20).map{ rand(5)+1 })
  end
  it "should got number" do
    @bilet.no.should == @no
  end
  it "should have 20 questions" do
    @bilet.questions.count.should == 20
    @bilet.questions.each do |q|
      q.class.name.should == 'Question'
    end
  end
  it "should return false if no one question is unanswered" do
    @bilet.answered?.should be_false
  end
  it "should return false if even one question is unanswered" do
    @bilet.questions[5] = Question.new(5, 2)
    @bilet.questions[5].answer(2)
    @bilet.questions[5].checked?.should be_true
    @bilet.answered?.should be_false
  end
  it "should return true if all questions is answered" do
    @bilet.questions.each do |q|
      q.answer(4)
    end
    @bilet.answered?.should be_true
  end

  it "should return current question in bilet" do
    (1..10).each do |i|
      @bilet.questions[i-1].answer(2)
    end
    @bilet.answered?.should be_false
    @bilet.current_question.no.should == 11
  end
end