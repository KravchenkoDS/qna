every 1.days do
  #runner 'DailyDigestJob.perform_now'
  Services::DailyDigest.send_digest
end

# Learn more: http://github.com/javan/whenever
