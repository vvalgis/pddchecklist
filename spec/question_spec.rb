require 'pddchecklist'

describe Question do
  before(:each) do
    @no = rand(5)+1
    @question = Question.new(@no)
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
  it "should initialize with answer" do
    answer = rand(5)+1
    question = Question.new(@no, answer)
    question.answer.should == answer
  end
end