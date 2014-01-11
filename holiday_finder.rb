#This file can be configured to add/remove holidays

require 'active_support/all'

class HolidayFinder

	#Add/edit holidays in here...
	def generate
		easters = {
			2013 => Date.new(2013,3,31),
			2014 => Date.new(2014,4,20),
			2015 => Date.new(2015,4,5)
		}
		easter = easters[@year]
		good_friday = easter - 2
		lent = easter - 46
		tuesday = lent - 1
		christmas = d(12,25)
		advent = weekday_before(0, christmas) - 3.weeks #4th Sunday before
		dst_start = nth_weekday_of(2, 0, 3) #2nd Sunday in March
		dst_end = nth_weekday_of(1, 0, 11) #1st Sunday in November
		victoria = weekday_before(1, d(5,25))
		riel = nth_weekday_of(3, 1, 2) #3rd Monday in February
		mothers = nth_weekday_of(2, 0, 5) #2nd Sunday in May
		memorial = weekday_before(1, d(6,1)) #last monday in May
		pentecost = easter + 49
		fathers = nth_weekday_of(3, 0, 6) #3rd Sunday in June
		civic = nth_weekday_of(1, 1, 8) #	1st Monday of August
		labor = nth_weekday_of(1, 1, 9) #1st Monday of Sept
		columbus = nth_weekday_of(2, 1, 10) #2nd Monday of Oct
		thanksgiving = nth_weekday_of(4, 4, 11) #4th Thursday
		mlk = nth_weekday_of(3, 1, 1) #3rd Monday in Jan
		presidents = nth_weekday_of(3, 1, 2) #3rd Monday of Feb, AKA Washington's Birthday
		
		add d(1,1), "New Year's Day"
		add mlk, "MLK, Jr. Day"
		add d(2,14), "Valentine's Day"
		add presidents, "President's Day"
		add riel, "Louis Riel Day"
		add dst_start, "DST Begins"
		add d(3,17), "St. Patrick's Day"
		add tuesday, "Shrove Tuesday"
		add lent, "Ash Wednesday"
		add good_friday, "Good Friday"
		add easter, "Easter"
		add mothers, "Mother's Day"
		add victoria, "Victoria Day"
		add memorial, "Memorial Day"
		add pentecost, "Pentecost"
		add fathers, "Father's Day"
		add d(7,1), "Canada Day"
		add d(7,4), "Independence Day"
		add civic, "Civic Holiday"
		add labor, "Labor Day"
		add labor, "Labour Day"
		add columbus, "Columbus Day"
		add columbus, "Thanksgiving (CA)"
		add d(10,31), "Halloween"
		add dst_end, "DST Ends"
		add d(11,11), "Veterans Day"
		add d(11,11), "Remembrance Day"
		add thanksgiving, "Thanksgiving (US)"
		add advent, "Advent Begins"
		add d(12,24), "Christmas Eve"
		add christmas, "Christmas"
		add d(12,26), "Boxing Day"
		add d(12,31), "New Year's Eve"
		@holidays
	end

	
	def initialize(year)
		@year = year
	end

	def d(month,day)
		Date.new(@year, month, day)
	end
	
	def weekday_before(weekday, day)
		result = day - 1.day
		while result.wday != weekday
			result -= 1
		end
		result
	end
	
	def nth_weekday_of(n, weekday, month)
		result = Date.new(@year, month, 1)
		while result.wday != weekday
			result += 1
		end
		result + (n-1).weeks
	end 
	
	def add(date, name)
		@holidays ||= {}
		@holidays[date] ||= []
		@holidays[date] << name
	end
	
	def holidays
		@holidays || generate
	end
	
end
