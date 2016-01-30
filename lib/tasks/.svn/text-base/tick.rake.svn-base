task :tick => :environment do
  start_time = Time.zone.now
  puts "===        Ticker Started #{start_time}        ==="
  
  Starship.all.each do |s|
    s.tick!
    print "."
  end
  puts "\n"
  
  end_time = Time.zone.now
  time_diff = (end_time - start_time).round.to_f 
  puts "=== Ticker Finished #{end_time} (#{time_diff}s) ==="
end