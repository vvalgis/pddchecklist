require 'pddchecklist'

describe Question do
  before(:each) do
    @no = rand(5)+1
    @question = Question.new(@no, 1)
  end
  it "should got number" do
    @question.no.should == @no
  end
  it "should be not checked if answer is not set" do
    @question.checked?.should be_false
  end
  it "should save and retrun answer" do
    answer = rand(5)+1
    @question.answer(answer)
    @question.answer.should == answer
  end
  it "should initialize with correct answer" do
    answer = rand(5)+1
    question = Question.new(@no, answer)
    question.answer(answer)
    question.answer_correct?.should be_true
  end
  it "should return true if answer is wrong" do
    answer = rand(5)+1
    question = Question.new(@no, answer)
    question.answer(answer + 1)
    question.answer_wrong?.should be_true
  end
  it "should return false if answer is not answered" do
    answer = rand(5)+1
    question = Question.new(@no, answer)
    question.answer_wrong?.should be_false
  end
end