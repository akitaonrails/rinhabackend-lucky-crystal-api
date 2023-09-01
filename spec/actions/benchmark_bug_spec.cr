require "../spec_helper"

describe Api::Pessoas::Show do
  it "should generate urls" do
    elapsed_time1 = Time.measure do
      url = ""
      100_000.times do |i|
        url = Api::Pessoas::Show.url("abc#{i}")
      end
    end
    puts "Api URL: #{elapsed_time1.milliseconds}"

    elapsed_time2 = Time.measure do
      100_000.times do |i|
        url = "http://localhost:9999/pessoas/abc#{i}"
      end
    end
    puts "Raw URL: #{elapsed_time2.milliseconds}"

    elapsed_time3 = Time.measure do
      100_000.times do |i|
        url = "#{Lucky::RouteHelper.settings.base_uri}/pessoas/abc#{i}"
      end
    end
    puts "base_uri concat: #{elapsed_time3.milliseconds}"

    # this only assesses that the Lucky routable.cr route method is almost 7x slower than just string concatenation
    (elapsed_time1).should_not be.>(elapsed_time2 * 10)
    (elapsed_time1).should_not be.>(elapsed_time3 * 10)
  end
end
