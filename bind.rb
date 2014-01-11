Dir.mkdir("pdf") unless Dir.exists?("pdf")
puts "Exporting..."
puts "...covers"
`inkscape --export-pdf='pdf/cover.pdf' cover.svg`
`inkscape --export-pdf='pdf/back.pdf' back.svg`
(1..12).each do |m|
	puts "..#{m}"
	month = "%02d" % m
	`inkscape --export-pdf='pdf/#{month}-upper.pdf' --export-dpi=300 upper/#{month}-upper.svg`
	`inkscape --export-pdf='pdf/#{month}-lower.pdf' --export-dpi=300 lower/#{month}-lower.svg`
end
print "Binding..."
input_files = (1..12).map{|m| month = "%02d" % m; "pdf/#{month}-upper.pdf pdf/#{month}-lower.pdf"}.join(" ")
`pdftk pdf/cover.pdf #{input_files} pdf/back.pdf cat output calendar.pdf`
puts "done."
