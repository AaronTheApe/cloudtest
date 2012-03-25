class Cloudtest
  def self.gen_rand_tests
    passes_remaining = (count * pass_fail_ratio).round
    fails_remaining = (count * (1-pass_fail_ratio)).round
    count.times do |x|
      File.open(dir + "/ts_#{x}.rb", 'w') do |file|
        file.write("require 'test/unit'\n")
        file.write("\n")
        file.write("class TS_0 < Test::Unit::TestCase\n")
        file.write("  def test_something_#{rand(1000000)}\n")
        if passes_remaining > 0 && fails_remaining > 0 then 
          if rand > pass_fail_ratio
            file.write("    assert false\n")
          else
            file.write("    assert true\n")
          end
        elsif passes_remaining > 0
          file.write("    assert true\n")         
        else
          file.write("    assert false\n")
        end
        file.write("  end\n")
        file.write("end\n")
      end
    end
  end
end
