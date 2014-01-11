#Run this file with Ruby to generate the upper and lower pages of the calendar:
# ruby generator.rb
require 'active_support/all'
require 'debugger'
require 'nokogiri'
require './holiday_finder.rb'

class MonthWriter

	def set(xpath, val, inc = 1)
		xpath = xpath.gsub("*counter*", @counter.to_s)
		node = @doc.xpath(xpath, @doc.root.namespaces)
		node.children[0].content = val.to_s
		@counter += inc
		node
	end

	def main
		print "Writing files..."

		Dir.mkdir("lower") unless Dir.exists?("lower")
		Dir.mkdir("upper") unless Dir.exists?("upper")
		

		@year = Date.today.year + 1

		@grid_svg = IO.read("grid.svg")
		@top_svg = IO.read("top.svg")
		
		holidays = HolidayFinder.new(@year).holidays
		h = {}
		holidays.each do |date, list|
			h[date] = list.join("\n")
		end
		
		(1..12).each do |m|

			@doc = Nokogiri::XML.parse(@grid_svg)

			first = Date.new(@year,m,1)
			
			
			@counter = 0
			day_xpath = "//svg:tspan[.='d*counter*']"
			h_xpath = "//svg:tspan[.='Holiday*counter*']"
			first.wday.times do |x|
				set(h_xpath, "", 0)
				set(day_xpath, "")
			end
			(first..first.end_of_month).each do |d|
				if @counter <= 34
					node = set(h_xpath, h[d], 0)[0]
					if (h[d] && h[d].split("\n").size > 1)
						node["y"] = (node["y"].to_d - 9.5880).to_s
						node.parent["y"] = node["y"]
					end
				end
				set(day_xpath, d.day)
			end
			while @counter <= 36
				set(h_xpath, "", 0) if @counter <= 34
				set(day_xpath, "")
			end
	
			prev_month = first - 1.month
			next_month = first + 1.month

			{
				"Month Before" => prev_month,
				"Month After" => next_month
			}.each do |label, month_date|
				@counter = 0
				day_xpath = "//svg:g[svg:text/svg:tspan[.='#{label}']]//svg:tspan[text()='*counter*']"
				month_date.wday.times do |x|
					set(day_xpath, "")
				end
				(month_date..month_date.end_of_month).each do |d|
					set(day_xpath, d.day)
				end	
				while @counter <= 41
					set(day_xpath, "")
				end
			end

			if first.wday < 1
				@doc.xpath("//svg:g[svg:text/svg:tspan[.='Month Before']]", @doc.root.namespaces)[0]["transform"] = "translate(617.63819,497.90452)"
			end
			if first.wday + first.end_of_month.day < 35
				@doc.xpath("//svg:g[svg:text/svg:tspan[.='Month After']]", @doc.root.namespaces)[0]["transform"] = "translate(742.14804,497.90452)"
			end

			set("//svg:g/svg:text/svg:tspan[.='Month Before']", prev_month.strftime("%B"))
			set("//svg:g/svg:text/svg:tspan[.='Month After']", next_month.strftime("%B"))

			padded_month = "%02d" % m #makes 2-digit number
			bg_file = "#{padded_month}-bg.jpg"
						
			lower_svg = @doc.to_s
			unless File.exists?("lower/#{bg_file}")
				FileUtils.copy("sample-bg2.jpg", "lower/#{bg_file}")
			end
			lower_svg = lower_svg.gsub("sample-bg2.jpg", bg_file)			
			IO.write("lower/#{padded_month}-lower.svg", lower_svg)
			
			upper_filename = "upper/#{padded_month}-upper.svg"
			top_svg = File.exists?(upper_filename) ? IO.read(upper_filename) : @top_svg
			unless File.exists?("upper/#{bg_file}")
				FileUtils.copy("sample-bg1.jpg", "upper/#{bg_file}")
			end
			top_svg = top_svg.gsub("Month", first.strftime("%B")).gsub("sample-bg1.jpg", bg_file)	
			IO.write(upper_filename, top_svg)
		end

		puts "done."
	end
end

MonthWriter.new.main
