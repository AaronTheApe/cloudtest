#require 'fog'

class Cloudtest
#  def self.cloudtest(suite_path, suites_per_instance,)
#    #s
#  end

  def self.gen_suites(path, num_suites, test_cases_per_suite, tests_per_test_case, pass_fail_ratio, selenium)
    num_suites.times do |suite_number|
      name = "#{suite_number}"
      gen_suite(path, name, test_cases_per_suite, tests_per_test_case, pass_fail_ratio, selenium)
    end
  end

  def self.gen_suite(path, name, test_cases_per_suite, tests_per_test_case, pass_fail_ratio, selenium)
    File::open("#{path}/ts_#{name}.rb", 'w') do |ts_file|
      ts_file.write("require 'test/unit'\n\n")
      Dir::mkdir("#{path}/#{name}")
      test_cases_per_suite.times do |test_case_number|
        test_case_name = "#{test_case_number}_of_suite_#{name}"
        ts_file.write("require '#{name}/tc_#{test_case_name}'\n")
        gen_test_case("#{path}/#{name}", test_case_name, tests_per_test_case, pass_fail_ratio, selenium)
      end
    end
  end

  def self.gen_test_case(path, name, num_tests, pass_fail_ratio, selenium)
    File::open("#{path}/tc_#{name}.rb", 'w') do |tc_file|
      tc_file.write("require 'test/unit'\n\n")
      tc_file.write("require 'mathn'\n\n")
      if(selenium)
        tc_file.write("require 'selenium-webdriver'\n")
        tc_file.write("require 'headless'\n\n")
      end
      tc_file.write("class TC_#{name} < Test::Unit::TestCase\n")
      passes_remaining = (num_tests * pass_fail_ratio).round
      fails_remaining = num_tests - passes_remaining
      num_tests.times do |test_number|
        if passes_remaining > 0 && fails_remaining > 0
          if rand > pass_fail_ratio
            gen_fail(tc_file, selenium)
          else
            gen_pass(tc_file, selenium)
          end
        elsif passes_remaining > 0
          gen_pass(tc_file, selenium)
        else
          gen_fail(tc_file, selenium)
        end
      end
      tc_file.write("end\n")
    end
  end

  def self.gen_pass(tc_file, selenium)
    if selenium
      tc_file.write <<EOS
  def test_google_is_google_#{rand(100000)}
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to "http://google.com"

    Prime.each(100000) do |prime| end

    assert_equal("google.com", driver.title)

    driver.quit    
  end
EOS
    else
      tc_file.write <<EOS
  def test_true_is_true_#{rand(100000)}
    Prime.each(100000) do |prime| end

    assert_equal(true, true)
  end
EOS
    end
  end

  def self.gen_fail(tc_file, selenium)
    if selenium
      tc_file.write <<EOS
  def test_google_is_bing_#{rand(100000)}
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to "http://bing.com"

    Prime.each(100000) do |prime| end

    assert_equal("google.com", driver.title)

    driver.quit    
  end
EOS
    else
      tc_file.write <<EOS
  def test_true_is_false_#{rand(100000)}
    Prime.each(100000) do |prime| end

    assert_equal(true, false)
  end
EOS
    end
  end
end
