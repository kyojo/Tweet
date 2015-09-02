require "open3"

per = Array.new(5,0)

out,err,status = Open3.capture3("ruby train2.rb 0 1740000")
out,err,status = Open3.capture3("ruby classify2.rb 0 1740000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 1740000 3155000")
out,err,status = Open3.capture3("ruby classify2.rb 1740000 3155000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 3155000 3543000")
out,err,status = Open3.capture3("ruby classify2.rb 3155000 3543000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 3543000 4010000")
out,err,status = Open3.capture3("ruby classify2.rb 3543000 4010000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 4010000 6256000")
out,err,status = Open3.capture3("ruby classify2.rb 4010000 6256000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 6256000 6696000")
out,err,status = Open3.capture3("ruby classify2.rb 6256000 6696000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 6696000 7170000")
out,err,status = Open3.capture3("ruby classify2.rb 6696000 7170000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 7170000 7580000")
out,err,status = Open3.capture3("ruby classify2.rb 7170000 7580000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 7580000 7784000")
out,err,status = Open3.capture3("ruby classify2.rb 7580000 7784000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end
out,err,status = Open3.capture3("ruby train2.rb 7784000 7840000")
out,err,status = Open3.capture3("ruby classify2.rb 7784000 7840000")
x = out.split(",")
for i in 0..4
  per[i] += x[i].to_f
end

for i in 0..4
  puts per[i] / 10.0
end
