require './holiday_finder'
require 'active_support/all'
require 'debugger'

describe HolidayFinder do
	{
		2013 => {
			"Louis Riel Day" => "Feb 18",
			"Advent Begins" => "Dec 1",
			"Thanksgiving (US)" => "Nov 28"
		},
		2014 => {
			"Louis Riel Day" => "Feb 17",
			"Mother's Day" => "May 11",
			"Memorial Day"=> "May 26",
			"Pentecost" => "June 8",
			"Father's Day" => "June 15",
			"Labor Day" => "Sep 1",
		}
	}.each do |year, holidays|
		specify "#{year} holidays" do
			h = HolidayFinder.new(year).holidays
			holidays.each do |name, day|
				date = Date.parse("#{day} #{year}")
				h.values.flatten.should include(name), "Expected to find '#{name}' in the list of holidays"
				h.each do |d,names|
					if names.include?(name)
						d.should eq(date), "Expected to find '#{name}' on #{date} but it was on #{d}"
					end
				end
				h[date].should_not be_nil, "Expected to find a holiday for '#{name}' on '#{day}'"
				h[date].should include(name), "Expected to find a holiday for '#{name}' on '#{day}'"
			end
		end
	end
end
