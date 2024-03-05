require 'nokogiri'
require 'territory'

data = File.read('example.svg')
output = data.dup

output.gsub!("</svg>", "")

@doc = Nokogiri::XML(data)
@doc.css('polygon').each do |poly|
  coordinates = poly.attributes['points'].to_s
  coord_array = coordinates.split(" ").map{|p| p.split(",").map(&:to_i) }
  coord_array.push(coord_array[0])
  feature_poly = Territory.polygon([coord_array])


  center = Territory.centroid(feature_poly)
  output += "<circle r='10' cx='#{center[:geometry][:coordinates][0]}' cy='#{center[:geometry][:coordinates][1]}' fill='red' />"

end

File.open('centered.svg', 'w+') do |f|
  output += "</svg>"
  f.puts output
end