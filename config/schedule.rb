every 1.days do
  #runner 'DailyDigestJob.perform_now'
  Services::DailyDigest.new.call
end

# Learn more: http://github.com/javan/whenever
