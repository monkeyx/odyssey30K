task :maintenance => :environment do
  start_time = Time.zone.now
  puts "===        Maintenance Started #{start_time}        ==="
  
  Colony.maintain_all!
  puts "\n"

  Starship.maintain_all!
  puts "\n"
  
  end_time = Time.zone.now
  time_diff = (end_time - start_time).round.to_f 
  puts "=== Maintenance Finished #{end_time} (#{time_diff}s) ==="
end