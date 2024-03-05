require 'nokogiri'
require 'polylabel'
require 'territory'

data = File.read('input.svg')
output = data.dup

output.gsub!("</svg>", "")

@doc = Nokogiri::XML(data)
@doc.css('polygon').each do |poly|
  coordinates = poly.attributes['points'].to_s
  coord_array = coordinates.split(" ").map{|p| p.split(",").map(&:to_i) }
  coord_array.push(coord_array[0])
  feature_poly = Territory.polygon([coord_array])

  centroid = Territory.centroid(feature_poly)
  output += "<circle r='5' cx='#{centroid[:geometry][:coordinates][0]}' cy='#{centroid[:geometry][:coordinates][1]}' fill='red' />"

  inaccessable_center = Polylabel.compute(feature_poly[:geometry][:coordinates])
  output += "<circle r='5' cx='#{inaccessable_center[:x]}' cy='#{inaccessable_center[:y]}' fill='orange' />"

  puts inaccessable_center
end

File.open('output.svg', 'w+') do |f|
  output += "</svg>"
  f.puts output
end