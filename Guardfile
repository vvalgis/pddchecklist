# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch('pddchecklist.rb') { ['spec/bilet_spec.rb'] }
end

