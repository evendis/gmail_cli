# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: 'bundle exec rspec', all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/gmail_cli/(.+)\.rb$})   { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

