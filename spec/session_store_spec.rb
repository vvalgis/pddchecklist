require 'pddchecklist'

describe SessionStore do

  STORE_FILE = File.join(File.expand_path(File.dirname(__FILE__)), 'pdd_test.yml')

  before(:each) do
    File.unlink STORE_FILE if File.exists? STORE_FILE
  end

  after(:all) do
    File.unlink STORE_FILE if File.exists? STORE_FILE
  end

  def prepare_session_store
    ss = SessionStore.new(STORE_FILE)
    ss.add_session Book.new
    ss.add_session Book.new
    ss.save
    ss
  end

  it "should accept store file name" do
    s = SessionStore.new(STORE_FILE)
    s.store_filename.should == STORE_FILE
  end

  it "should have save sessions" do
    s = SessionStore.new(STORE_FILE)
    s.add_session(Book.new)
    s.save
    File.exists?(STORE_FILE).should be_true
  end

  it "should restore sessions" do
    prepare_session_store
    ss = SessionStore.new(STORE_FILE)
    ss.sessions.count.should == 2
  end

  it "should return last session" do
    prepare_session_store
    ss = SessionStore.new(STORE_FILE)
    ss.last_session.class.should == Book
    ss.last_session.should === ss.sessions.last
  end

  it "should create session if it doesn't exist" do
    File.exists?(STORE_FILE).should be_false
    ss = SessionStore.new(STORE_FILE)
    ss.last_session.class.should == Book
    ss.last_session.should === ss.sessions.last
  end

  it "should create new session if last session is done" do
    ss = SessionStore.new(STORE_FILE)
    b1, b2= (1..2).map do |i|
      b = Book.new
      b.stub(:done? => true)
      ss.add_session(b)
      b
    end
    ss.sessions.count.should == 2
    ss.last_session.done?.should be_false
    ss.sessions.count.should == 3
  end
end