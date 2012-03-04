require "pddchecklist"

describe Book do
  it "should contain bilets" do
    book = Book.new
    book.bilets.count.should == 40
    book.bilets.each do |b|
      b.class.name.should == 'Bilet'
    end
  end
  it "should return true if all bilets is answered" do
    book = Book.new
    book.bilets.each do |b|
      b.questions.each do |q|
        q.answer(5)
      end
    end
    book.done?.should be_true
  end
  it "should return false if even one question is unanswered" do
    book = Book.new
    book.bilets.each do |b|
      b.questions.each do |q|
        q.answer(5)
      end
    end
    book.bilets[5].questions[5] = Question.new(5)
    book.done?.should be_false
  end
  it "should return current bilet in book" do
    book = Book.new
    (0..4).each do |i|
      book.bilets[i].questions.each do |q|
        q.answer(5)
      end
    end
    (0..9).each do |i|
      book.bilets[5].questions[i].answer(2)
    end
    book.current_bilet.no.should == 6
  end
end